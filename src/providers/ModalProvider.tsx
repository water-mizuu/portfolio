import { createContext, ReactElement, useCallback, useState } from "react";
import ImageLightbox from "../components/modal/ImageLightbox";
import ProjectModal from "../components/modal/ProjectModal";
import { GitHubRepo } from "../types";

type ModalLayer =
  | { type: "project"; payload: GitHubRepo }
  | { type: "image"; payload: { src: string; alt: string } };

export const ModalContext = createContext<{
  activeModal: ModalLayer | null;
  openModal: (layer: ModalLayer) => void;
  closeModal: () => void;
}>({
  activeModal: null,
  openModal: () => {},
  closeModal: () => {},
});

export function ModalProvider({
  children,
}: {
  children: ReactElement | ReactElement[];
}): ReactElement {
  const [modalStack, setModalStack] = useState<ModalLayer[]>([]);

  const openModal = useCallback((layer: ModalLayer) => {
    setModalStack((prev) => [...prev, layer]);
  }, []);

  const closeModal = useCallback(() => {
    setModalStack((prev) => prev.slice(0, -1));
  }, []);

  return (
    <ModalContext.Provider
      value={{
        activeModal: modalStack.at(-1) || null,
        openModal,
        closeModal,
      }}
    >
      {children}
      {modalStack.map((layer) => {
        if (layer.type === "project") {
          return (
            <ProjectModal
              key={`project-${layer.payload.name}`}
              repo={layer.payload}
              onClose={closeModal}
            />
          );
        }
        if (layer.type === "image") {
          return (
            <ImageLightbox
              key={`image-${layer.payload.src}`}
              src={layer.payload.src}
              alt={layer.payload.alt}
              onClose={closeModal}
            />
          );
        }
      })}
    </ModalContext.Provider>
  );
}
