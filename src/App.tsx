import type { MouseEvent, ReactNode } from "react";
import { useEffect, useRef, useState } from "react";
import AboutSection from "./components/AboutSection";
import ContactSection from "./components/ContactSection";
import HomeSection from "./components/HomeSection";
import ProjectModal from "./components/ProjectModal";
import ProjectsSection from "./components/ProjectsSection";
import RepoNotesSection from "./components/RepoNotesSection";
import SkillsSection from "./components/SkillsSection";
import { GITHUB_REPOS } from "./generated/github-data";
import type { GitHubRepo, PortfolioNote, SectionId } from "./types";

export default function App(): ReactNode {
  const [repos] = useState<GitHubRepo[]>(GITHUB_REPOS);
  const [activeSection, setActiveSection] = useState<SectionId>("home");
  const [selectedRepo, setSelectedRepo] = useState<GitHubRepo | null>(null);

  const sectionRatiosRef = useRef<Map<SectionId, number>>(new Map());
  const activeSectionRef = useRef<SectionId>("home");
  const portfolioNotes: PortfolioNote[] = repos.flatMap((repo) =>
    repo.portfolioNote ? [{ repoName: repo.name, content: repo.portfolioNote }] : [],
  );

  useEffect(() => {
    activeSectionRef.current = activeSection;
  }, [activeSection]);

  useEffect(() => {
    const sections = Array.from(document.querySelectorAll<HTMLElement>("section[id]"));
    if (!sections.length) return;

    const updateActiveSection = () => {
      const currentActiveSection = activeSectionRef.current;
      const currentActiveRatio = sectionRatiosRef.current.get(currentActiveSection) ?? 0;
      let bestId: SectionId = currentActiveSection;
      let bestRatio = currentActiveRatio;

      sectionRatiosRef.current.forEach((ratio, id) => {
        if (ratio > bestRatio) {
          bestId = id;
          bestRatio = ratio;
        }
      });

      const scrollEndReached =
        window.innerHeight + window.scrollY >= document.documentElement.scrollHeight - 2;
      if (scrollEndReached) {
        setActiveSection("contact");
        return;
      }

      const hysteresisDelta = 0.12;
      if (bestId !== currentActiveSection && bestRatio > currentActiveRatio + hysteresisDelta) {
        setActiveSection(bestId);
      }
    };

    const observer = new IntersectionObserver(
      (entries: IntersectionObserverEntry[]) => {
        entries.forEach((entry) => {
          const id = entry.target.getAttribute("id") as SectionId | null;
          if (!id) return;
          sectionRatiosRef.current.set(id, entry.isIntersecting ? entry.intersectionRatio : 0);
        });
        updateActiveSection();
      },
      { root: null, rootMargin: "-40% 0px -40% 0px", threshold: [0, 0.1, 0.25, 0.5, 0.75, 1] },
    );

    sections.forEach((section) => observer.observe(section));
    const handleScroll = () => {
      updateActiveSection();
    };

    window.addEventListener("scroll", handleScroll, { passive: true });
    window.addEventListener("resize", handleScroll);
    handleScroll();

    return () => {
      observer.disconnect();
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
      <aside className="vbar" aria-hidden="false">
        <nav className="vnav" aria-label="Primary">
          <button
            type="button"
            className={activeSection === "home" ? "active" : ""}
            onClick={(event) => handleNavClick(event, "home")}
          >
            Home
          </button>
          <button
            type="button"
            className={activeSection === "projects" ? "active" : ""}
            onClick={(event) => handleNavClick(event, "projects")}
          >
            Projects
          </button>
          <button
            type="button"
            className={activeSection === "contact" ? "active" : ""}
            onClick={(event) => handleNavClick(event, "contact")}
          >
            Contact
          </button>
        </nav>
      </aside>

      <main className="container">
        <HomeSection />
        <AboutSection />
        <ProjectsSection repos={repos} onOpen={(r) => setSelectedRepo(r)} />
        <RepoNotesSection notes={portfolioNotes} />

        {selectedRepo && <ProjectModal repo={selectedRepo} onClose={() => setSelectedRepo(null)} />}

        <SkillsSection />
        <ContactSection />

        <footer className="footer">
          <small>© {new Date().getFullYear()} • Minimal portfolio</small>
        </footer>
      </main>
    </div>
  );
}
