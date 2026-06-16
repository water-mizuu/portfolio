import babel from "@rolldown/plugin-babel";
import react, { reactCompilerPreset } from "@vitejs/plugin-react";
import { defineConfig } from "vite";

const config: Record<string, any> = {
  plugins: [
    react(),
    babel({
      presets: [reactCompilerPreset()],
    }),
  ],
};

if (process.env["GITHUB_ACTIONS"] != null) {
  config["base"] = "/portfolio/";
}

export default defineConfig(config);
