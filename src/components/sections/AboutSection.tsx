import type { ReactElement } from "react";
import styles from "./AboutSection.module.css";

export default function AboutSection(): ReactElement {
  return (
    <section id="about" className={`${styles.about} card`}>
      <h2>About</h2>
      <p>Minimal, technical portfolio. No photo, no logo — focused on work and clarity.</p>
    </section>
  );
}
