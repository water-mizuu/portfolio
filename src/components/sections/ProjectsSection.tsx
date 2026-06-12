import type { ReactElement } from "react";
import type { GitHubRepo } from "../../types";
import ProjectCard from "../shared/ProjectCard";
import styles from "./ProjectsSection.module.css";

interface Props {
  repos: GitHubRepo[];
  onOpen(repo: GitHubRepo): void;
}

export default function ProjectsSection({ repos, onOpen }: Props): ReactElement {
  return (
    <section id="projects" className={styles.projects}>
      <h2>Projects</h2>
      <div className={styles.projectsList}>
        {repos.length === 0 && (
          <div className="card muted">
            No projects found — set your GitHub username in <code>src/config.ts</code>.
          </div>
        )}
        {repos.map((repo) => (
          <ProjectCard key={repo.id} repo={repo} onOpen={(r) => onOpen(r)} />
        ))}
      </div>
    </section>
  );
}
