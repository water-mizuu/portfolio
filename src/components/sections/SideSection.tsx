import { MouseEvent, ReactNode } from "react";
import { SectionId } from "../../types";
import styles from "./SideSection.module.css";

interface Props {
  activeSection: SectionId;
  handleNavClick: (event: MouseEvent<HTMLButtonElement>, sectionId: SectionId) => void;
}

export function SideSection({ activeSection, handleNavClick }: Props): ReactNode {
  return (
    <aside className={styles.vbar} aria-hidden="false">
      <nav className={styles.vnav} aria-label="Primary">
        <button
          type="button"
          className={activeSection === "home" ? styles.active : ""}
          onClick={(event) => handleNavClick(event, "home")}
        >
          Home
        </button>
        <button
          type="button"
          className={activeSection === "about" ? styles.active : ""}
          onClick={(event) => handleNavClick(event, "about")}
        >
          About
        </button>
        <button
          type="button"
          className={activeSection === "skills" ? styles.active : ""}
          onClick={(event) => handleNavClick(event, "skills")}
        >
          Skills
        </button>
        <button
          type="button"
          className={activeSection === "projects" ? styles.active : ""}
          onClick={(event) => handleNavClick(event, "projects")}
        >
          Projects
        </button>
        <button
          type="button"
          className={activeSection === "contact" ? styles.active : ""}
          onClick={(event) => handleNavClick(event, "contact")}
        >
          Contact
        </button>

      </nav>
    </aside>
  );
}
