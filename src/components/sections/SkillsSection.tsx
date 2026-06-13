import { ReactElement } from "react";
import styles from "./SkillsSection.module.css";

export default function SkillsSection(): ReactElement {
  const categories = [
    {
      title: "Languages",
      items: ["Dart", "Python", "TypeScript", "JavaScript", "C/C++", "HTML/CSS"],
    },
    {
      title: "Frameworks & Libraries",
      items: ["Flutter", "React", "Node.js", "Vite", "Express"],
    },
    {
      title: "Specializations",
      items: ["AI / Machine Learning", "Computer Vision", "Automata Theory", "Parser Generators"],
    },
    {
      title: "Tools & Infrastructure",
      items: ["Git", "Docker", "Linux", "GitHub Pages"],
    },
  ];

  return (
    <section id="skills" className={styles.skills}>
      <h2>Skills</h2>
      <div className="card">
        <div className={styles.grid}>
          {categories.map((cat) => (
            <div key={cat.title} className={styles.category}>
              <h3>{cat.title}</h3>
              <div className={styles.tags}>
                {cat.items.map((item) => (
                  <span key={item} className={styles.tag}>
                    {item}
                  </span>
                ))}
              </div>
            </div>
          ))}
        </div>
      </div>
    </section>
  );
}

