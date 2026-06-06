import { useEffect, useRef, useState } from "react";
import type { GitHubRepo } from "../types";

interface Props {
  repo: GitHubRepo;
  onClose(): void;
}

export default function ProjectModal({ repo, onClose }: Props) {
  const [visible, setVisible] = useState(false);
  const closingRef = useRef(false);

  // CHANGEABLE: Edit this message if you want a different fallback when no Portfolio.md is found.
  // This is the single place to update the UI text shown when no details exist.
  const NO_DETAILS_MESSAGE = "No details found.";

  useEffect(() => {
    // entrance animation
    requestAnimationFrame(() => setVisible(true));
    return () => {};
  }, []);

  useEffect(() => {
    function onKey(e: KeyboardEvent) {
      if (e.key === "Escape") handleClose();
    }
    window.addEventListener("keydown", onKey);
    return () => window.removeEventListener("keydown", onKey);
  }, []);

  function handleClose() {
    if (closingRef.current) return;
    closingRef.current = true;
    setVisible(false);
    // wait for CSS transition then call onClose
    window.setTimeout(() => onClose(), 220);
  }

  return (
    <div
      className={"modal-overlay " + (visible ? "show" : "")}
      role="dialog"
      aria-modal="true"
      aria-label={`Project ${repo.name}`}
      onMouseDown={(e) => {
        if (e.button !== 0) return;
        if (e.target === e.currentTarget) handleClose();
      }}
    >
      <div className={"modal " + (visible ? "show" : "")}>
        <header className="modal-header">
          <h2>{repo.name}</h2>
          <div className="modal-controls">
            <a href={repo.url} target="_blank" rel="noreferrer" className="btn ghost">
              Repo
            </a>
            {repo.live && (
              <a href={repo.live} target="_blank" rel="noreferrer" className="btn">
                Live
              </a>
            )}
            <button className="btn ghost" onClick={handleClose} aria-label="Close project modal">
              Close
            </button>
          </div>
        </header>

        <div className="modal-body">
          <section className="card">
            <h3>About</h3>
            <p>{repo.description ?? "No description provided."}</p>
          </section>

          <section className="card">
            <h3>Portfolio.md</h3>
            {repo.portfolioNote ? (
              <pre>{repo.portfolioNote}</pre>
            ) : (
              // CHANGE HERE: To change the fallback message edit `NO_DETAILS_MESSAGE` above.
              <div className="no-details">{NO_DETAILS_MESSAGE}</div>
            )}
          </section>

          {repo.readme && (
            <section className="card">
              <h3>README</h3>
              <pre>{repo.readme}</pre>
            </section>
          )}
        </div>
      </div>
    </div>
  );
}
