import type {
  GitHubContentFileResponse,
  GitHubContentsItem,
  GitHubRepo,
  GitHubRepoApiResponse,
} from "./types";

export async function fetchRepos(username: string, count = 6): Promise<GitHubRepo[]> {
  if (!username || username === "your-github-username") return [];

  try {
    const res = await fetch(
      `https://api.github.com/users/${username}/repos?sort=updated&per_page=${count}`,
    );
    if (!res.ok) return [];

    const data = (await res.json()) as GitHubRepoApiResponse[];
    return data.map((repo) => ({
      id: repo.id,
      name: repo.name,
      description: repo.description,
      url: repo.html_url,
      homepage: repo.homepage ?? null,
      live: findGithubPagesUrl(repo.description) || repo.homepage || null,
      language: repo.language,
    }));
  } catch (error) {
    console.error("Failed to fetch repos", error);
    return [];
  }
}

export async function readTopLevelPortfolioMd(
  username: string,
  repoName: string,
): Promise<string | null> {
  if (!username || !repoName) return null;

  try {
    const rootRes = await fetch(`https://api.github.com/repos/${username}/${repoName}/contents`);
    if (!rootRes.ok) return null;

    const items = (await rootRes.json()) as unknown;
    if (!Array.isArray(items)) return null;

    const match = items.find((item): item is GitHubContentsItem => {
      if (!item || typeof item !== "object") return false;
      const candidate = item as Partial<GitHubContentsItem>;
      return candidate.type === "file" && candidate.name?.toLowerCase() === "portfolio.md";
    });

    if (!match) return null;

    if (match.download_url) {
      const contentRes = await fetch(match.download_url);
      if (!contentRes.ok) return null;
      return await contentRes.text();
    }

    const contentRes = await fetch(match.url);
    if (!contentRes.ok) return null;

    const fileData = (await contentRes.json()) as GitHubContentFileResponse;
    if (fileData.encoding === "base64" && typeof fileData.content === "string") {
      return atob(fileData.content.replace(/\n/g, ""));
    }

    return null;
  } catch (error) {
    console.error(`Failed to read portfolio.md from ${username}/${repoName}`, error);
    return null;
  }
}

export async function readRepoReadme(username: string, repoName: string): Promise<string | null> {
  if (!username || !repoName) return null;

  try {
    // Try the contents API for README.md at the repo root
    const url = `https://api.github.com/repos/${username}/${repoName}/readme`;
    const res = await fetch(url, { headers: { Accept: "application/vnd.github.v3+json" } });
    if (!res.ok) return null;

    const data = (await res.json()) as GitHubContentFileResponse;
    if (data.encoding === "base64" && typeof data.content === "string") {
      return atob(data.content.replace(/\n/g, ""));
    }

    // fallback: try raw README
    return null;
  } catch (error) {
    console.error(`Failed to read README.md from ${username}/${repoName}`, error);
    return null;
  }
}

function findGithubPagesUrl(text: string | null): string | null {
  if (!text) return null;
  const urlRegex = /(https?:\/\/[^\s]+)/g;
  const matches = text.match(urlRegex);
  if (!matches) return null;
  const gh = matches.find((url) => url.includes("github.io"));
  if (gh) return gh.replace(/[)\.\s]+$/, "");
  return matches[0].replace(/[)\.\s]+$/, "");
}
