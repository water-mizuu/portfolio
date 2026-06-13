import { MouseEvent, ReactNode } from "react";
import { SectionId } from "../../types";
import styles from "./SideSection.module.css";

interface Props {
  activeSection: SectionId;
  handleNavClick: (event: MouseEvent<HTMLButtonElement>, sectionId: SectionId) => void;
}

// prettier-ignore
const sections = [
  { name: "Home",     id: "home"     },
  { name: "About",    id: "about"    },
  { name: "Skills",   id: "skills"   },
  { name: "Projects", id: "projects" },
  { name: "Contact",  id: "contact"  },
] as const satisfies { name: string; id: SectionId }[];

export function SideSection({ activeSection, handleNavClick }: Props): ReactNode {
  return (
    <aside className={styles.vbar} aria-hidden="false">
      <nav className={styles.vnav} aria-label="Primary">
        {sections.map((v) => (
          <button
            key={v.id}
            type="button"
            className={activeSection === v.id ? styles.active : ""}
            onClick={(e) => handleNavClick(e, v.id)}
          >
            {v.name}
          </button>
        ))}
      </nav>
    </aside>
  );
}
