import { EMAIL, SITE } from "../config";

export default function HomeSection(): JSX.Element {
  return (
    <section id="home" className="hero">
      <h1>{SITE.headline}</h1>
      <p className="tagline">{SITE.tagline}</p>
      <div className="cta-row">
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
