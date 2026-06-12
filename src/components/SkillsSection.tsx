import { ReactElement } from "react";
import styles from "./SkillsSection.module.css";

export default function SkillsSection(): ReactElement {
  return (
    <section id="skills" className={`${styles.skills} card`}>
      <h2>Skills</h2>
      <p>JavaScript, TypeScript, React, Node.js — minimal & pragmatic.</p>
    </section>
  );
}
