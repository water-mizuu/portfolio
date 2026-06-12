import { ReactElement } from "react";
import styles from "./SkillsSection.module.css";

export default function SkillsSection(): ReactElement {
  return (
    <section id="skills" className={`${styles.skills} card`}>
      <h2>Skills</h2>
      <div>
        <p>
          <b>A</b> b c d e
        </p>
        <p>
          <b>B</b> c d e f
        </p>
      </div>
    </section>
  );
}
