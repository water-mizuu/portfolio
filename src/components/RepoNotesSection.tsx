import type { PortfolioNote } from "../types";

interface Props {
  notes: PortfolioNote[];
}

export default function RepoNotesSection({ notes }: Props): JSX.Element {
  return (
    <section id="repo-notes" className="repo-notes card">
      <h2>Repo Notes</h2>
      {notes.length === 0 ? (
        <p className="muted">
          No top-level <code>portfolio.md</code> files were found in the generated repo data.
        </p>
      ) : (
        notes.map((note) => (
          <article key={note.repoName} className="portfolio-note">
            <h3>{note.repoName}</h3>
            <pre>{note.content}</pre>
          </article>
        ))
      )}
    </section>
  );
}
