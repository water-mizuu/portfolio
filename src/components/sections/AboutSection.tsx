import { type ReactElement } from "react";
import styles from "./AboutSection.module.css";

export default function AboutSection(): ReactElement {
  return (
    <section id="about" className={`${styles.about} card`}>
      <h2>About</h2>
      <p className={styles.summary}>
        Computer Science graduate (Magna Cum Laude, DOST Scholar) specializing in embedded hardware,
        ML/AI systems, and full-stack development across Flutter, Python, and web ecosystems.
      </p>

      <div className={styles.detailsGrid}>
        <div className={styles.category}>
          <h3>Work Experience</h3>
          <div className={styles.item}>
            <div className={styles.headerRow}>
              <strong>Ateneo Innovation Center</strong>
              <span className={styles.date}>Jan - Mar 2026</span>
            </div>
            <div className={styles.role}>Software Developer Intern</div>
            <ul className={styles.bulletList}>
              <li>Built environmental telemetry data pipelines in Python.</li>
              <li>Managed time-series databases and local server deployments.</li>
              <li>Created real-time React/WebSocket sensor visualization dashboards.</li>
            </ul>
          </div>
        </div>

        <div className={styles.category}>
          <h3>Education</h3>
          <div className={styles.item}>
            <div className={styles.headerRow}>
              <strong>Technological Institute of the Philippines</strong>
              <span className={styles.date}>2022 - 2026</span>
            </div>
            <div className={styles.role}>BS in Computer Science</div>
            <ul className={styles.bulletList}>
              <li>Magna Cum Laude (GPA: 1.31)</li>
              <li>DOST Science Merit Scholar</li>
            </ul>
          </div>
        </div>
      </div>
    </section>
  );
}
