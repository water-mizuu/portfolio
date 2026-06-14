import { ReactElement, useContext, useEffect, useState } from "react";
import { ModalContext } from "../../App";
import styles from "./ImageLightbox.module.css";

interface ImageLightboxProps {
  src: string;
  alt: string;
  onClose(): void;
}

export default function ImageLightbox({ src, alt, onClose }: ImageLightboxProps): ReactElement {
  const [visible, setVisible] = useState(false);
  const { activeModal } = useContext(ModalContext);
  const isTop = activeModal?.type === "image";

  useEffect(() => {
    // Entrance transition animation
    requestAnimationFrame(() => setVisible(true));
  }, []);

  useEffect(() => {
    const onKey = (e: KeyboardEvent) => {
      if (e.key === "Escape" && isTop) {
        handleClose();
      }
    };

    window.addEventListener("keydown", onKey);
    return () => window.removeEventListener("keydown", onKey);
  }, [isTop]);

  function handleClose() {
    setVisible(false);
    // Wait for the exit transition to finish before unmounting
    window.setTimeout(() => onClose(), 220);
  }

  return (
    <div
      className={`${styles.lightboxOverlay} ${visible ? styles.show : ""}`}
      role="dialog"
      aria-modal="true"
      aria-label="Image preview"
      onMouseDown={(e) => {
        if (e.button !== 0) return;
        if (e.target === e.currentTarget) handleClose();
      }}
    >
      <button
        type="button"
        className={styles.lightboxClose}
        onClick={handleClose}
        aria-label="Close image preview"
      >
        Close
      </button>
      <div className={styles.lightboxImageWrapper}>
        <img src={src} alt={alt} className={styles.lightboxImage} />
      </div>
      {alt && <p className={styles.lightboxCaption}>{alt}</p>}
    </div>
  );
}
