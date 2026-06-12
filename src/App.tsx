import type { ReactNode } from "react";
import { useState } from "react";
import styles from "./App.module.css";
import AboutSection from "./components/AboutSection";
import ContactSection from "./components/ContactSection";
import HomeSection from "./components/HomeSection";
import ProjectModal from "./components/ProjectModal";
import ProjectsSection from "./components/ProjectsSection";
import { SideSection } from "./components/SideSection";
import SkillsSection from "./components/SkillsSection";
import { GITHUB_REPOS } from "./generated/github-data";
import { useActiveSection } from "./hooks/useActiveSection";
import type { GitHubRepo } from "./types";

export default function App(): ReactNode {
  const { activeSection, handleNavClick } = useActiveSection();
  const [selectedRepo, setSelectedRepo] = useState<GitHubRepo | null>(null);

  return (
    <div className="site-root">
      <SideSection activeSection={activeSection} handleNavClick={handleNavClick} />

      {selectedRepo != null && (
        <ProjectModal repo={selectedRepo} onClose={() => setSelectedRepo(null)} />
      )}

      <main className={styles.container}>
        <HomeSection />
        <AboutSection />
        <ProjectsSection repos={GITHUB_REPOS} onOpen={(r) => setSelectedRepo(r)} />

        <SkillsSection />
        <ContactSection />

        <footer className={styles.footer}>
          <small>© {new Date().getFullYear()} • Minimal portfolio</small>
        </footer>
      </main>
    </div>
  );
}
