import type { ReactElement } from "react";
import { EMAIL, SOCIALS } from "../config";
import styles from "./ContactSection.module.css";

export default function ContactSection(): ReactElement {
  return (
    <section id="contact" className={`${styles.contact} card`}>
      <h2>Contact</h2>
      <p>
        Email: <a href={`mailto:${EMAIL}`}>{EMAIL}</a>
      </p>
      <div className={styles.social}>
        {SOCIALS.github && (
          <a href={SOCIALS.github} target="_blank" rel="noreferrer">
            GitHub
          </a>
        )}
        {SOCIALS.linkedin && (
          <a href={SOCIALS.linkedin} target="_blank" rel="noreferrer">
            LinkedIn
          </a>
        )}
        {SOCIALS.twitter && (
          <a href={SOCIALS.twitter} target="_blank" rel="noreferrer">
            Twitter
          </a>
        )}
      </div>
    </section>
  );
}
