import type { ReactNode } from "react";
import { useEffect, useRef } from "react";

/**
 * InteractiveGridBackground
 * Renders a full-screen, high-performance HTML5 canvas dot matrix background.
 * Uses a double-layered layout to achieve 3D parallax scrolling and a
 * physics-based interactive hover effect where dots glow and shift away
 * to "avoid" the user's cursor.
 */
export default function InteractiveGridBackground(): ReactNode {
  const canvasRef = useRef<HTMLCanvasElement | null>(null);

  useEffect(() => {
    const canvas = canvasRef.current;
    if (!canvas) return;

    const ctx = canvas.getContext("2d");
    if (!ctx) return;

    // Configuration for the two grid layers to simulate depth (3D effect).
    const LAYERS = [
      {
        // Far/Background layer: moves slower, smaller dots, fader opacity.
        spacing: 55, // Distance in pixels between dots on this grid
        dotBaseRadius: 0.75, // Starting size of the dots
        influenceRadius: 130, // Cursor interaction distance threshold
        maxGlowOpacity: 0.12, // Brightest alpha when cursor is directly over
        baseOpacity: 0.02, // Default resting opacity
        displacementLimit: 2, // Max pixels shifted away from the cursor
        parallaxSpeed: 0.07, // Speed factor relative to scroll velocity
      },
      {
        // Near/Foreground layer: moves faster, larger dots, more prominent.
        spacing: 35,
        dotBaseRadius: 1.25,
        influenceRadius: 180,
        maxGlowOpacity: 0.22,
        baseOpacity: 0.05,
        displacementLimit: 5,
        parallaxSpeed: 0.18,
      },
    ];

    // Animation state tracking variables.
    let width = 0; // Viewport width
    let height = 0; // Viewport height

    // Mouse coordinates: target is immediate, current is smoothed with easing.
    let targetMouse = { x: -1000, y: -1000 };
    let currentMouse = { x: -1000, y: -1000 };

    // Scroll coordinates: target is immediate window scroll, current is eased.
    let targetScrollY = 0;
    let currentScrollY = 0;

    let isMouseOver = false;
    let animationFrameId: number | null = null;
    let isRunning = false; // Tracks if the requestAnimationFrame loop is active

    /**
     * Handles browser resizing and adjusts canvas scale.
     * Uses devicePixelRatio to ensure crisp, sharp rendering on Retina/HiDPI
     * screens without raster blurriness.
     */
    const resize = () => {
      const dpr = window.devicePixelRatio || 1;
      width = window.innerWidth;
      height = window.innerHeight;

      // Scale underlying canvas pixels for high-DPI displays
      canvas.width = width * dpr;
      canvas.height = height * dpr;

      // Set CSS dimensions to match layout size
      canvas.style.width = `${width}px`;
      canvas.style.height = `${height}px`;

      // Normalize canvas drawing scale to standard CSS pixels
      ctx.scale(dpr, dpr);

      targetScrollY = window.scrollY;
      currentScrollY = window.scrollY;
      startLoop();
    };

    /**
     * Renders a single frame of the double-layer grid.
     */
    const draw = () => {
      ctx.clearRect(0, 0, width, height);

      // Dynamically fetch the text color variable from the stylesheet.
      const textStyle = getComputedStyle(document.documentElement)
        .getPropertyValue("--text")
        .trim();
      const dotColor = textStyle || "#e6eef2";

      // Render each parallax layer sequentially.
      LAYERS.forEach((layer) => {
        const cols = Math.ceil(width / layer.spacing);

        // Add an extra row to guarantee complete vertical screen coverage
        // when the scroll offset slides the grid upwards.
        const rows = Math.ceil(height / layer.spacing) + 1;

        // Wrap scroll offset within repeating interval [0, layer.spacing].
        // This ensures the pattern tiles infinitely as you scroll.
        const scrollOffset = (currentScrollY * layer.parallaxSpeed) % layer.spacing;

        for (let c = 0; c <= cols; c++) {
          for (let r = 0; r <= rows; r++) {
            const originalX = c * layer.spacing;
            const originalY = r * layer.spacing - scrollOffset;

            let drawX = originalX;
            let drawY = originalY;
            let radius = layer.dotBaseRadius;
            let opacity = layer.baseOpacity;

            // Cursor Avoidance & Glow Logic:
            // Evaluates proximity between the mouse and each dot to apply forces.
            if (isMouseOver) {
              const dx = originalX - currentMouse.x;
              const dy = originalY - currentMouse.y;
              let dist = Math.sqrt(dx * dx + dy * dy);

              // Apply effect only if the dot is inside the influence radius
              if (dist < layer.influenceRadius) {
                // Linear scaling factor (1.0 at center, 0.0 at outer limit)
                const factor = 1 - dist / layer.influenceRadius;

                // Scale up dot size near cursor
                radius = layer.dotBaseRadius + factor * 1.5;

                // Scale up dot alpha near cursor
                opacity = layer.baseOpacity + factor * (layer.maxGlowOpacity - layer.baseOpacity);

                // Warping offset (avoidance physics):
                // Finds the angle between the cursor and the dot.
                // Displaces coordinates along that angle away from the cursor.
                if (dist <= 0) dist = 0.1;
                const angle = Math.atan2(dy, dx);
                const shift = factor * layer.displacementLimit;

                // Move dot outward along direction vector (dx/dist, dy/dist)
                drawX = originalX + Math.cos(angle) * shift;
                drawY = originalY + Math.sin(angle) * shift;
              }
            }

            ctx.beginPath();
            ctx.arc(drawX, drawY, radius, 0, Math.PI * 2);
            ctx.fillStyle = dotColor;
            ctx.globalAlpha = opacity;
            ctx.fill();
          }
        }
      });
    };

    /**
     * Primary animation loop driving smooth transitions.
     * Uses linear interpolation (LERP) for mouse and scroll position.
     * Shuts down automatically when values settle to conserve CPU cycles.
     */
    const loop = () => {
      let needsRedraw = false;

      // Easing of mouse coordinates (8% of remaining distance per frame)
      if (isMouseOver) {
        const dx = targetMouse.x - currentMouse.x;
        const dy = targetMouse.y - currentMouse.y;
        currentMouse.x += dx * 0.08;
        currentMouse.y += dy * 0.08;

        // Keep loop running if mouse easing hasn't fully converged
        if (Math.abs(dx) > 0.1 || Math.abs(dy) > 0.1) {
          needsRedraw = true;
        }
      }

      // Easing of scroll coordinates (8% of remaining distance per frame)
      const ds = targetScrollY - currentScrollY;
      if (Math.abs(ds) > 0.1) {
        currentScrollY += ds * 0.08;
        needsRedraw = true;
      } else {
        currentScrollY = targetScrollY;
      }

      draw();

      // Keep running if there are active mouse/scroll transitions in progress.
      if (needsRedraw || isMouseOver) {
        animationFrameId = requestAnimationFrame(loop);
      } else {
        isRunning = false;
      }
    };

    /**
     * Starts the loop if it's currently dormant/idle to save power.
     */
    const startLoop = () => {
      if (!isRunning) {
        isRunning = true;
        animationFrameId = requestAnimationFrame(loop);
      }
    };

    const handleMouseMove = (e: MouseEvent) => {
      targetMouse.x = e.clientX;
      targetMouse.y = e.clientY;
      isMouseOver = true;
      startLoop();
    };

    const handleMouseLeave = () => {
      isMouseOver = false;
      targetMouse = { x: -1000, y: -1000 };
      startLoop();
    };

    const handleTouchMove = (e: TouchEvent) => {
      if (e.touches.length > 0) {
        targetMouse.x = e.touches[0].clientX;
        targetMouse.y = e.touches[0].clientY;
        isMouseOver = true;
        startLoop();
      }
    };

    const handleScroll = () => {
      targetScrollY = window.scrollY;
      startLoop();
    };

    // Attach listeners
    window.addEventListener("resize", resize);
    window.addEventListener("mousemove", handleMouseMove);
    document.addEventListener("mouseleave", handleMouseLeave);
    window.addEventListener("touchmove", handleTouchMove);
    window.addEventListener("touchend", handleMouseLeave);
    window.addEventListener("scroll", handleScroll, { passive: true });

    // Initial positioning and rendering setup
    resize();

    // Clean up event listeners and stop loops when component unmounts
    return () => {
      window.removeEventListener("resize", resize);
      window.removeEventListener("mousemove", handleMouseMove);
      document.removeEventListener("mouseleave", handleMouseLeave);
      window.removeEventListener("touchmove", handleTouchMove);
      window.removeEventListener("touchend", handleMouseLeave);
      window.removeEventListener("scroll", handleScroll);
      if (animationFrameId) {
        cancelAnimationFrame(animationFrameId);
      }
    };
  }, []);

  return (
    <canvas
      ref={canvasRef}
      style={{
        position: "fixed",
        top: 0,
        left: 0,
        width: "100%",
        height: "100%",
        zIndex: -1,
        pointerEvents: "none",
        display: "block",
      }}
    />
  );
}
