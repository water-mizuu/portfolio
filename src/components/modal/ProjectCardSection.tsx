import Markdown from "marked-react";
import { ReactElement, useContext } from "react";
import { ModalContext } from "../../App";
import styles from "./ProjectModal.module.css";

interface ProjectCardSectionProps {
  title?: string;
  content: string;
  repoUrl: string;
  defaultBranch?: string;
}

export function hasProjectCardContent(content: string | undefined | null): boolean {
  if (!content || content.trim().length === 0) return false;
  const cardImages = extractImagesFromMarkdown(content);
  const cleanContent = removeImagesFromMarkdown(content);
  return cleanContent.trim().length > 0 || cardImages.length > 0;
}

export default function ProjectCardSection({
  title,
  content,
  repoUrl,
  defaultBranch = "main",
}: ProjectCardSectionProps): ReactElement {
  const { openModal } = useContext(ModalContext);

  const cardImages = extractImagesFromMarkdown(content);
  const cleanContent = removeImagesFromMarkdown(content);

  if (cardImages.length > 0) {
    return (
      <div className={styles.cardGrid}>
        <section className="card">
          {title && <h3>{title}</h3>}
          <div className={styles.markdownBody}>
            <Markdown>{cleanContent}</Markdown>
          </div>
        </section>
        <div className={styles.rightColumn}>
          {cardImages.map((img, index) => {
            const resolvedUrl = resolveImageUrl(img.url, repoUrl, defaultBranch);
            return (
              <div key={index} className={styles.imageCardWrapper}>
                <div
                  className={styles.imageMockup}
                  onClick={() =>
                    openModal({ type: "image", payload: { src: resolvedUrl, alt: img.alt } })
                  }
                  role="button"
                  tabIndex={0}
                  aria-label={`View image: ${img.alt || "Project image"}`}
                  onKeyDown={(e) => {
                    if (e.key === "Enter" || e.key === " ") {
                      e.preventDefault();
                      openModal({ type: "image", payload: { src: resolvedUrl, alt: img.alt } });
                    }
                  }}
                >
                  <img src={resolvedUrl} alt={img.alt} />
                </div>
                {img.alt && <p className={styles.imageCaption}>“{img.alt}”</p>}
              </div>
            );
          })}
        </div>
      </div>
    );
  } else {
    return (
      <section className="card">
        {title && <h3>{title}</h3>}
        <div className={styles.markdownBody}>
          <Markdown>{cleanContent}</Markdown>
        </div>
      </section>
    );
  }
}

interface ExtractedImage {
  url: string;
  alt: string;
}

/**
 * Scans markdown text to find markdown image syntaxes and HTML img tags
 * only if their alt text ends with a '#' character.
 */
function extractImagesFromMarkdown(md: string): ExtractedImage[] {
  if (!md) return [];
  const images: ExtractedImage[] = [];

  // Standard Markdown Image regex: ![alt#](url) (must end with #)
  const mdImageRegex = /!\[([^\]]*#)\]\(([^)]+)\)/g;
  let match;
  while ((match = mdImageRegex.exec(md)) !== null) {
    const rawAlt = match[1] ? match[1].trim() : "";
    images.push({
      alt: rawAlt.endsWith("#") ? rawAlt.slice(0, -1).trim() : rawAlt,
      url: match[2] ? match[2].trim() : "",
    });
  }

  // HTML img tags regex: <img src="url" alt="alt#" /> (must end with #)
  const imgTagRegex = /<img\b[^>]*>/gi;
  while ((match = imgTagRegex.exec(md)) !== null) {
    const tag = match[0];
    const srcMatch = tag.match(/src=["']([^"']+)["']/i);
    const altMatch = tag.match(/alt=["']([^"']*#)["']/i);
    if (srcMatch && altMatch) {
      const rawAlt = altMatch[1].trim();
      images.push({
        url: srcMatch[1].trim(),
        alt: rawAlt.endsWith("#") ? rawAlt.slice(0, -1).trim() : rawAlt,
      });
    }
  }

  return images;
}

/**
 * Strips only markdown image syntax and HTML img tags that have alt text ending with '#'
 */
function removeImagesFromMarkdown(md: string): string {
  if (!md) return "";
  let clean = md.replace(/!\[([^\]]*#)\]\(([^)]+)\)/g, "");
  clean = clean.replace(/<img\b[^>]*alt=["']([^"']*#)["'][^>]*>/gi, "");
  return clean.replace(/\n{3,}/g, "\n\n").trim();
}

function resolveImageUrl(url: string, repoUrl: string, defaultBranch: string = "main"): string {
  if (url.startsWith("http://") || url.startsWith("https://") || url.startsWith("data:")) {
    return url;
  }

  let cleanPath = url.replace(/^\.?\//, "");

  // If the path starts with public/, strip it because Vite serves public/ contents at root
  if (cleanPath.startsWith("public/")) {
    cleanPath = cleanPath.substring(7);
  }

  // For the current portfolio repository, or if it is a downloaded local portfolio asset
  if (cleanPath.startsWith("portfolio/") || repoUrl.toLowerCase().endsWith("/portfolio")) {
    const base = import.meta.env.BASE_URL || "/";
    const separator = base.endsWith("/") ? "" : "/";
    return `${base}${separator}${cleanPath}`;
  }

  // Otherwise, construct raw github user content URL
  const rawBase = repoUrl.replace("github.com", "raw.githubusercontent.com");
  return `${rawBase}/${defaultBranch}/${cleanPath}`;
}
