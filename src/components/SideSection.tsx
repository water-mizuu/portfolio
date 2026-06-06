import { MouseEvent, ReactNode } from "react";
import { SectionId } from "../types";

interface Props {
  activeSection: SectionId;
  handleNavClick: (event: MouseEvent<HTMLButtonElement>, sectionId: SectionId) => void;
}

export function SideSection({ activeSection, handleNavClick }: Props): ReactNode {
  return (
    <aside className="vbar" aria-hidden="false">
      <nav className="vnav" aria-label="Primary">
        <button
          type="button"
          className={activeSection === "home" ? "active" : ""}
          onClick={(event) => handleNavClick(event, "home")}
        >
          Home
        </button>
        <button
          type="button"
          className={activeSection === "projects" ? "active" : ""}
          onClick={(event) => handleNavClick(event, "projects")}
        >
          Projects
        </button>
        <button
          type="button"
          className={activeSection === "contact" ? "active" : ""}
          onClick={(event) => handleNavClick(event, "contact")}
        >
          Contact
        </button>
      </nav>
    </aside>
  );
}
