import { ReactElement, useContext } from "react";
import { ModalContext } from "../../providers/ModalProvider";
import styles from "./ClickableImage.module.css";

type Props = {
  url: string;
  alt: string;
};

export default function ClickableImage({ url, alt }: Props): ReactElement {
  const { openModal } = useContext(ModalContext);

  return (
    <div
      className={styles.imageMockup}
      onClick={() => openModal({ type: "image", payload: { src: url, alt: alt } })}
      role="button"
      tabIndex={0}
      aria-label={`View image: ${alt || "Project image"}`}
      onKeyDown={(e) => {
        if (e.key === "Enter" || e.key === " ") {
          e.preventDefault();
          openModal({ type: "image", payload: { src: url, alt: alt } });
        }
      }}
    >
      <img src={url} alt={alt} />
    </div>
  );
}
