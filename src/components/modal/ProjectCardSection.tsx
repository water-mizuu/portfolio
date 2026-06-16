import Markdown from "marked-react";
import { ReactElement } from "react";
import ClickableImage from "../shared/ClickableImage";
import styles from "./ProjectModal.module.css";

interface Props {
  title?: string;
  content: string;
}

export default function ProjectCardSection({ title, content }: Props): ReactElement {
  return (
    <section className="card">
      {title && <h3>{title}</h3>}
      <div className={styles.markdownBody}>
        <Markdown
          renderer={{
            image(src, alt) {
              const parsedAlt = alt.endsWith("#") ? alt.substring(0, alt.length - 1) : alt;
              return (
                <span className={styles.markdownImageWrapper}>
                  <ClickableImage url={src} alt={parsedAlt} />
                  {parsedAlt && <p className={styles.imageCaption}>“{parsedAlt}”</p>}
                </span>
              );
            },
          }}
        >
          {content}
        </Markdown>
      </div>
    </section>
  );
}
