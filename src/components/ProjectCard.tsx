import type { GitHubRepo } from "../types";

interface ProjectCardProps {
  repo: GitHubRepo;
  onOpen?: (repo: GitHubRepo) => void;
}

export default function ProjectCard({ repo, onOpen }: ProjectCardProps): JSX.Element {
  return (
    <article className="card">
      <h3 className="card-title">
        <a href={repo.url} target="_blank" rel="noreferrer">
          {repo.name}
        </a>
      </h3>
      {repo.description && <p className="card-desc">{repo.description}</p>}
      <div className="card-meta">
        <span>{repo.language || "—"}</span>
        <div className="meta-links">
          {repo.live && (
            <a className="live-link" href={repo.live} target="_blank" rel="noreferrer">
              Live
            </a>
          )}
          <a href={repo.url} target="_blank" rel="noreferrer">
            Repo
          </a>
          <button onClick={() => onOpen && onOpen(repo)} className="btn ghost" type="button">
            Details
          </button>
        </div>
      </div>
    </article>
  );
}
