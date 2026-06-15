import { type ReactNode } from "react";
import styles from "./App.module.css";
import InteractiveGridBackground from "./components/InteractiveGridBackground";
import AboutSection from "./components/sections/AboutSection";
import ContactSection from "./components/sections/ContactSection";
import HomeSection from "./components/sections/HomeSection";
import ProjectsSection from "./components/sections/ProjectsSection";
import { SideSection } from "./components/sections/SideSection";
import SkillsSection from "./components/sections/SkillsSection";
import { GITHUB_REPOS } from "./generated/github-data";
import { useActiveSection } from "./hooks/useActiveSection";
import { ModalProvider } from "./providers/ModalProvider";

export default function App(): ReactNode {
  const { activeSection, handleNavClick } = useActiveSection();

  return (
    <ModalProvider>
      <div className="site-root">
        <InteractiveGridBackground />
        <SideSection activeSection={activeSection} handleNavClick={handleNavClick} />

        <main className={styles.container}>
          <HomeSection />
          <AboutSection />
          <SkillsSection />
          <ProjectsSection repos={GITHUB_REPOS} />
          <ContactSection />

          <footer className={styles.footer}>
            <small>© {new Date().getFullYear()} • water-mizuu</small>
          </footer>
        </main>
      </div>
    </ModalProvider>
  );
}
