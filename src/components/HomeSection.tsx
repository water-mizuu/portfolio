import type { ReactElement } from "react";
import { EMAIL, SITE } from "../config";
import styles from "./HomeSection.module.css";

export default function HomeSection(): ReactElement {
  return (
    <section id="home" className={styles.hero}>
      <h1>{SITE.headline}</h1>
      <p className={styles.tagline}>{SITE.tagline}</p>
      <div className={styles.ctaRow}>
        <a className="btn" href={SITE.resumePath} target="_blank" rel="noreferrer">
          Resume
        </a>
        <a className="btn ghost" href={`mailto:${EMAIL}`}>
          Email
        </a>
      </div>
    </section>
  );
}
