import type { MouseEvent } from "react";
import { useEffect, useRef, useState } from "react";
import type { SectionId } from "../types";

export function useActiveSection() {
  const [activeSection, setActiveSection] = useState<SectionId>("home");

  // Keep track of the visibility ratio of each section to determine
  //   which one is currently in view.
  const sectionRatiosRef = useRef<Map<SectionId, number>>(new Map());

  // Keep a mutable reference to the active section to avoid stale closures.
  const activeSectionRef = useRef<SectionId>("home");

  // A timeout variable used for debouncing the update of the active section.
  const updateDebounce = useRef<NodeJS.Timeout | null>(null);

  // Synchronize the mutable activeSectionRef with the React activeSection state.
  useEffect(() => {
    activeSectionRef.current = activeSection;
  }, [activeSection]);

  // Set up scroll listeners to dynamically highlight the current navigation item.
  useEffect(() => {
    const sections = [...document.querySelectorAll<HTMLElement>("section[id]")];
    if (sections.length <= 0) return;

    // Evaluates which section is dominant and updates the active section state if necessary.
    const updateActiveSection = () => {
      const currentActiveSection = activeSectionRef.current;
      const viewportHeight = window.innerHeight || 1;
      const triggerTop = viewportHeight * 0.4;
      const triggerBottom = viewportHeight * 0.6;
      const triggerHeight = triggerBottom - triggerTop;

      let bestId: SectionId = currentActiveSection;
      let bestRatio = 0;

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

      // Edge case: If the user scrolls to the absolute bottom of the page, force active section to "contact"
      const scrollEndReached =
        window.innerHeight + window.scrollY >= document.documentElement.scrollHeight - 2;
      if (scrollEndReached) {
        setActiveSection("contact");
        return;
      }

      const hysteresisDelta = 0.12;
      const currentActiveRatio = sectionRatiosRef.current.get(currentActiveSection) ?? 0;
      if (bestId !== currentActiveSection && bestRatio > currentActiveRatio + hysteresisDelta) {
        setActiveSection(bestId);
      }
    };

    const handleScroll = () => {
      let timeout: NodeJS.Timeout | null = updateDebounce.current;
      if (timeout != null) {
        clearTimeout(timeout);
      }

      updateDebounce.current = setTimeout(() => {
        updateActiveSection();
        updateDebounce.current = null;
      }, 100);
    };

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

  return {
    activeSection,
    setActiveSection,
    handleNavClick,
  };
}
