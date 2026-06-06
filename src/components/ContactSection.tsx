import { EMAIL, SOCIALS } from "../config";

export default function ContactSection(): JSX.Element {
  return (
    <section id="contact" className="contact card">
      <h2>Contact</h2>
      <p>
        Email: <a href={`mailto:${EMAIL}`}>{EMAIL}</a>
      </p>
      <div className="social">
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
