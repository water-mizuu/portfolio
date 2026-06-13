import { type ReactElement, useState } from "react";
import type { GitHubRepo } from "../../types";
import ProjectCard from "../shared/ProjectCard";
import styles from "./ProjectsSection.module.css";

interface Props {
  repos: GitHubRepo[];
  onOpen(repo: GitHubRepo): void;
}

export default function ProjectsSection({ repos, onOpen }: Props): ReactElement {
  const [shownRepoCount, setShownRepoCount] = useState<number>(5);
  const shownRepos = repos.slice(0, shownRepoCount);

  return (
    <section id="projects" className={styles.projects}>
      <h2>Projects</h2>
      <div className={styles.projectsList}>
        {repos.length === 0 && (
          <div className="card muted">
            No projects found — set your GitHub username in <code>src/config.ts</code>.
          </div>
        )}

        {shownRepos.map((repo) => (
          <ProjectCard key={repo.id} repo={repo} onOpen={(r) => onOpen(r)} />
        ))}

        <More setShownRepoCount={setShownRepoCount} remaining={repos.length - shownRepoCount} />
      </div>
    </section>
  );
}

type MoreProps = {
  setShownRepoCount: (n: (v: number) => number) => void;
  remaining: number; //
};
function More({ setShownRepoCount, remaining }: MoreProps): ReactElement {
  return (
    <>
      {remaining > 0 && (
        <button className="btn" onClick={() => setShownRepoCount((curr) => curr + 5)}>
          Show More {`+${remaining} remaining`}
        </button>
      )}
    </>
  );
}
