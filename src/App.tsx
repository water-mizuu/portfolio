import type { ReactNode } from "react";
import { useState } from "react";
import styles from "./App.module.css";
import ProjectModal from "./components/modal/ProjectModal";
import AboutSection from "./components/sections/AboutSection";
import ContactSection from "./components/sections/ContactSection";
import HomeSection from "./components/sections/HomeSection";
import ProjectsSection from "./components/sections/ProjectsSection";
import SkillsSection from "./components/sections/SkillsSection";
import { SideSection } from "./components/sections/SideSection";
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
        <SkillsSection />
        <ProjectsSection repos={GITHUB_REPOS} onOpen={(r) => setSelectedRepo(r)} />
        <ContactSection />

        <footer className={styles.footer}>
          <small>© {new Date().getFullYear()} • water-mizuu</small>
        </footer>
      </main>
    </div>
  );
}

