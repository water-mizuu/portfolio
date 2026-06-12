import type { MouseEvent, ReactNode } from "react";
import { useEffect, useRef, useState } from "react";
import styles from "./App.module.css";
import AboutSection from "./components/AboutSection";
import ContactSection from "./components/ContactSection";
import HomeSection from "./components/HomeSection";
import ProjectModal from "./components/ProjectModal";
import ProjectsSection from "./components/ProjectsSection";
import { SideSection } from "./components/SideSection";
import SkillsSection from "./components/SkillsSection";
import { GITHUB_REPOS } from "./generated/github-data";
import type { GitHubRepo, SectionId } from "./types";

export default function App(): ReactNode {
  const [activeSection, setActiveSection] = useState<SectionId>("home");
  const [selectedRepo, setSelectedRepo] = useState<GitHubRepo | null>(null);

  // Keep track of the visibility ratio of each section to determine which one is currently in view.
  // We use a ref instead of component state to store this map because updating it on every scroll or
  // intersection event would trigger unnecessary and expensive re-renders.
  const sectionRatiosRef = useRef<Map<SectionId, number>>(new Map());

  // Keep a mutable reference to the active section. This is crucial for avoiding "stale closures"
  // within the scroll event listeners. Since the main scroll useEffect hook runs only once
  // (empty dependency array `[]`), any function defined inside it only captures the initial state.
  // Using a ref allows us to always read the current active section without rebuilding the event listeners.
  const activeSectionRef = useRef<SectionId>("home");

  // Synchronize the mutable activeSectionRef with the React activeSection state when it changes.
  useEffect(() => {
    activeSectionRef.current = activeSection;
  }, [activeSection]);

  /// Set up scroll listeners to dynamically highlight the current navigation item.
  useEffect(() => {
    const sections = [...document.querySelectorAll<HTMLElement>("section[id]")];
    if (sections.length <= 0) return;

    // Evaluates which section is dominant and updates the active section state if necessary.
    const updateActiveSection = () => {
      const currentActiveSection = activeSectionRef.current;
      const viewportHeight = window.innerHeight || 1;
      // Define our central trigger band (40% to 60% of viewport height).
      const triggerTop = viewportHeight * 0.4;
      const triggerBottom = viewportHeight * 0.6;
      const triggerHeight = triggerBottom - triggerTop;

      let bestId: SectionId = currentActiveSection;
      let bestRatio = 0;

      // Calculate the exact overlap of each section with the trigger band.
      // This solves the issue where large sections (like projects) have a tiny relative intersectionRatio
      // and fail to get highlighted.
      for (const section of sections) {
        const id = section.getAttribute("id") as SectionId | null;
        if (!id) continue;

        const rect = section.getBoundingClientRect();
        const overlapTop = Math.max(rect.top, triggerTop);
        const overlapBottom = Math.min(rect.bottom, triggerBottom);
        const overlapHeight = Math.max(0, overlapBottom - overlapTop);
        const ratio = overlapHeight / triggerHeight;

        sectionRatiosRef.current.set(id, ratio);

        if (ratio > bestRatio) {
          bestId = id;
          bestRatio = ratio;
        }
      }

      // Edge case: If the user scrolls to the absolute bottom of the page, automatically force the
      // active section to the last one ("contact") even if it isn't taking up the majority of the viewport.
      const scrollEndReached =
        window.innerHeight + window.scrollY >= document.documentElement.scrollHeight - 2;
      if (scrollEndReached) {
        setActiveSection("contact");
        return;
      }

      // Hysteresis is used to prevent rapid toggling (jitter) between sections when scrolling.
      // We only switch the active section if the new candidate section is visible by a margin (delta)
      // significantly greater than the current section's visibility.
      const hysteresisDelta = 0.12;
      const currentActiveRatio = sectionRatiosRef.current.get(currentActiveSection) ?? 0;
      if (bestId !== currentActiveSection && bestRatio > currentActiveRatio + hysteresisDelta) {
        setActiveSection(bestId);
      }
    };

    const handleScroll = () => {
      updateActiveSection();
    };

    /// Using the parameter passive: true ensures that scroll is not hindered by code.
    window.addEventListener("scroll", handleScroll, { passive: true });
    window.addEventListener("resize", handleScroll);
    handleScroll();

    return () => {
      window.removeEventListener("scroll", handleScroll);
      window.removeEventListener("resize", handleScroll);
    };
  }, []);

  const handleNavClick = (event: MouseEvent<HTMLButtonElement>, sectionId: SectionId) => {
    event.preventDefault();
    setActiveSection(sectionId);
    document.getElementById(sectionId)?.scrollIntoView({ behavior: "smooth", block: "start" });
  };

  return (
    <div className="site-root">
      <SideSection activeSection={activeSection} handleNavClick={handleNavClick} />

      <main className={styles.container}>
        <HomeSection />
        <AboutSection />
        <ProjectsSection repos={GITHUB_REPOS} onOpen={(r) => setSelectedRepo(r)} />

        {selectedRepo != null && (
          <ProjectModal repo={selectedRepo} onClose={() => setSelectedRepo(null)} />
        )}

        <SkillsSection />
        <ContactSection />

        <footer className={styles.footer}>
          <small>© {new Date().getFullYear()} • Minimal portfolio</small>
        </footer>
      </main>
    </div>
  );
}
