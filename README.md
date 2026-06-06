Minimal single-screen portfolio (React + Vite)

Overview

- Single-column, vertical scroll only
- Minimal, technical tone
- No photo or logo — headline `Software Engineer`
- Static site intended for GitHub Pages deployment

Color options

- Default (cyan accent): dark `#0b0f12` + accent `#00d1ff`
- Slate + Orange: dark `#0b0d10` + accent `#ff8a00`
- Deep Blue + Purple: dark `#030417` + accent `#7b61ff`
- Charcoal + Green: dark `#0b0b0b` + accent `#5af27c`

To customize: edit the CSS variables at `src/styles.css` top or pick another hex.

Setup

1. Install dependencies:

```bash
npm install
```

2. Run dev server:

```bash
npm run dev
```

3. Build:

```bash
npm run build
```

4. Deploy to GitHub Pages (requires `gh-pages` and a repo configured):

```bash
npm run deploy
```

Configuration

- Set your GitHub username in `src/config.ts` (`GITHUB_USERNAME`) so the build-time data generator knows which account to snapshot.
- Add a `resume.pdf` to the `public/` folder (path `/resume.pdf`) or change `SITE.resumePath` in `src/config.js`.
- Update contact email and social links in `src/App.tsx`.

Notes

- Repo metadata, README content, and top-level `portfolio.md` files are fetched during `npm run dev` and `npm run build`, then written to `src/generated/github-data.ts`.
- The app no longer hits the GitHub API in the browser.
- If you'd like, I can replace the static `you@example.com` and social placeholders with your real links.
