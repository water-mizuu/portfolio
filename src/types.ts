export type SectionId = "home" | "about" | "projects" | "repo-notes" | "skills" | "contact";

export interface SiteConfig {
  // name: string;
  headline: string;
  tagline: string;
  resumePath: string;
}

export interface SocialLinks {
  github: string;
  linkedin: string;
  twitter: string;
}

export interface GitHubRepo {
  id: number;
  name: string;
  description: string | null;
  url: string;
  homepage: string | null;
  live: string | null;
  language: string | null;
  readme?: string | null;
  portfolioNote?: string | null;
}

export interface PortfolioNote {
  repoName: string;
  content: string;
}

export interface GitHubRepoApiResponse {
  id: number;
  name: string;
  description: string | null;
  html_url: string;
  homepage: string | null;
  language: string | null;
}

export interface GitHubContentsItem {
  type: string;
  name: string;
  download_url: string | null;
  url: string;
}

export interface GitHubContentFileResponse {
  content?: string;
  encoding?: string;
  download_url?: string | null;
}
