import type { ReactElement } from "react";
import type { GitHubRepo } from "../types";
import styles from "./ProjectCard.module.css";

interface Props {
  repo: GitHubRepo;
  onOpen?: (repo: GitHubRepo) => void;
}

export default function ProjectCard({ repo, onOpen }: Props): ReactElement {
  return (
    <article className="card">
      <h3 className={styles.cardTitle}>
        <a href={repo.url} target="_blank" rel="noreferrer">
          {repo.name}
        </a>
      </h3>
      {repo.description && <p className={styles.cardDesc}>{repo.description}</p>}
      <div className={styles.cardMeta}>
        <span>{repo.language || "—"}</span>
        <div className={styles.metaLinks}>
          {repo.live && (
            <a className={styles.liveLink} href={repo.live} target="_blank" rel="noreferrer">
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
