import { useContext, type ReactElement } from "react";
import { ModalContext } from "../../providers/ModalProvider";
import type { GitHubRepo } from "../../types";
import styles from "./ProjectCard.module.css";

interface Props {
  repo: GitHubRepo;
}

export default function ProjectCard({ repo }: Props): ReactElement {
  const modalContext = useContext(ModalContext);
  const openRepo = () => modalContext.openModal({ type: "project", payload: repo });

  return (
    <article onClick={openRepo} className={`${styles.clickableCard} card`}>
      <h3 className={styles.cardTitle}>
        <a href={repo.url} target="_blank" rel="noreferrer">
          {repo.name}
        </a>
      </h3>
      {repo.description && <p className={styles.cardDesc}>{repo.description}</p>}
      <div className={styles.cardMeta}>
        <span>{repo.language || "—"}</span>
        <div onClick={(e) => e.stopPropagation()} className={styles.metaLinks}>
          {repo.live && (
            <a className={styles.liveLink} href={repo.live} target="_blank" rel="noreferrer">
              Live
            </a>
          )}
          <a href={repo.url} target="_blank" rel="noreferrer">
            Repo
          </a>
          <button onClick={openRepo} className="btn ghost" type="button">
            Details
          </button>
        </div>
      </div>
    </article>
  );
}
