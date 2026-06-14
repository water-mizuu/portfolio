import { type ReactNode, createContext, useCallback, useRef, useState } from "react";
import styles from "./App.module.css";
import InteractiveGridBackground from "./components/InteractiveGridBackground";
import ImageLightbox from "./components/modal/ImageLightbox";
import ProjectModal from "./components/modal/ProjectModal";
import AboutSection from "./components/sections/AboutSection";
import ContactSection from "./components/sections/ContactSection";
import HomeSection from "./components/sections/HomeSection";
import ProjectsSection from "./components/sections/ProjectsSection";
import { SideSection } from "./components/sections/SideSection";
import SkillsSection from "./components/sections/SkillsSection";
import { GITHUB_REPOS } from "./generated/github-data";
import { useActiveSection } from "./hooks/useActiveSection";
import type { GitHubRepo } from "./types";

export interface ModalLayer {
  type: "project" | "image" | string;
  payload: any;
}

export const ModalContext = createContext<{
  activeModal: ModalLayer | null;
  openModal: (type: string, payload: any) => void;
  closeModal: () => void;
}>({
  activeModal: null,
  openModal: () => {},
  closeModal: () => {},
});

export default function App(): ReactNode {
  const { activeSection, handleNavClick } = useActiveSection();
  const [modalStack, setModalStack] = useState<ModalLayer[]>([]);

  const openModal = useCallback((type: string, payload: any) => {
    setModalStack((prev) => [...prev, { type, payload }]);
  }, []);

  const closeModal = useCallback(() => {
    setModalStack((prev) => prev.slice(0, -1));
  }, []);

  return (
    <ModalContext.Provider
      value={{
        activeModal: modalStack[modalStack.length - 1] || null,
        openModal,
        closeModal,
      }}
    >
      <div className="site-root">
        <InteractiveGridBackground />
        <SideSection activeSection={activeSection} handleNavClick={handleNavClick} />

        {modalStack.map((layer, index) => {
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
          return <></>;
        })}

        <main className={styles.container}>
          <HomeSection />
          <AboutSection />
          <SkillsSection />
          <ProjectsSection repos={GITHUB_REPOS} onOpen={(r) => openModal("project", r)} />
          <ContactSection />

          <footer className={styles.footer}>
            <small>© {new Date().getFullYear()} • water-mizuu</small>
          </footer>
        </main>
      </div>
    </ModalContext.Provider>
  );
}
