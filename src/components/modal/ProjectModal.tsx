import { ReactElement, useContext, useEffect, useRef, useState } from "react";
import { ModalContext } from "../../providers/ModalProvider";
import type { GitHubRepo } from "../../types";
import ProjectCardSection from "./ProjectCardSection";
import styles from "./ProjectModal.module.css";

interface Props {
  repo: GitHubRepo;
  onClose(): void;
}

export default function ProjectModal({ repo, onClose }: Props): ReactElement {
  const [visible, setVisible] = useState(false);
  const closingRef = useRef(false);

  const { activeModal } = useContext(ModalContext);
  const isTop = activeModal?.type === "project";

  useEffect(() => {
    // entrance animation
    requestAnimationFrame(() => setVisible(true));
  }, []);

  /// Key onPress listener.
  useEffect(() => {
    const onKey = (e: KeyboardEvent) => {
      if (e.key === "Escape" && isTop) {
        handleClose();
      }
    };

    window.addEventListener("keydown", onKey);

    return () => window.removeEventListener("keydown", onKey);
  }, [isTop]);

  function handleClose() {
    if (closingRef.current) return;
    closingRef.current = true;
    setVisible(false);
    window.setTimeout(() => onClose(), 220);
  }

  return (
    <div
      className={`${styles.modalOverlay} ${visible ? styles.show : ""}`}
      role="dialog"
      aria-modal="true"
      aria-label={`Project ${repo.name}`}
      onMouseDown={(e) => {
        if (e.button !== 0) return;
        if (e.target === e.currentTarget) handleClose();
      }}
    >
      <div className={`${styles.modal} ${visible ? styles.show : ""}`}>
        <div className="top">
          <header className={styles.modalHeader}>
            <h2>{repo.name}</h2>
            <div className={styles.modalControls}>
              {repo.live && (
                <a href={repo.live} target="_blank" rel="noreferrer" className="btn">
                  Live
                </a>
              )}
              <a href={repo.url} target="_blank" rel="noreferrer" className="btn ghost">
                Repo
              </a>
              <button
                type="button"
                className="btn ghost"
                onClick={handleClose}
                aria-label="Close project modal"
              >
                Close
              </button>
            </div>
          </header>

          <div>{repo.description}</div>
        </div>

        <div className={styles.modalBody}>
          <ProjectCardSection content={repo.portfolioNote || ""} />

          {repo.readme != null && repo.readme!.trim().length > 0 && (
            <ProjectCardSection content={repo.readme || ""} />
          )}
        </div>
      </div>
    </div>
  );
}
