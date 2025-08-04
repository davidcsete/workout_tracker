import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = [];

  connect() {
    // Ultra-simple approach that works despite double firing
    if (window.transitionSetup) return;
    window.transitionSetup = true;

    let isBack = false;
    let lastUrl = window.location.href;
    let transitionId = 0;
    let pendingTransition = false;

    // Track back navigation
    window.addEventListener("popstate", () => {
      console.log("Popstate detected - setting back navigation");
      isBack = true;
    });

    // Track clicks on "Back" links/buttons
    document.addEventListener("click", (event) => {
      const clickedElement = event.target;
      const text = clickedElement.textContent || clickedElement.innerText || "";

      if (text.toLowerCase().includes("back")) {
        console.log("Back link clicked - setting back navigation");
        isBack = true;
      }
    });

    // Apply transitions on turbo:before-render (earlier in the process)
    document.addEventListener("turbo:before-render", () => {
      const currentUrl = window.location.href;
      const currentId = ++transitionId;

      // More lenient URL check - compare pathname and search only
      const currentPath = new URL(currentUrl).pathname + new URL(currentUrl).search;
      const lastPath = new URL(lastUrl).pathname + new URL(lastUrl).search;

      // Skip if path hasn't changed or we already have a pending transition
      if (currentPath === lastPath || pendingTransition) {
        console.log("Skipped: same path or pending transition");
        return;
      }

      pendingTransition = true;
      lastUrl = currentUrl;
      const direction = isBack ? "back" : "forward";

      console.log(`Transition ${currentId}:`, direction, `(isBack: ${isBack})`);

      // Apply transition immediately
      const body = document.body;
      body.classList.remove("animate-slide-in-left", "animate-slide-in-right");

      // Apply the animation class
      if (direction === "forward") {
        body.classList.add("animate-slide-in-right");
        console.log("Applied: animate-slide-in-right");
      } else {
        body.classList.add("animate-slide-in-left");
        console.log("Applied: animate-slide-in-left");
      }

      // Clean up after animation
      setTimeout(() => {
        body.classList.remove(
          "animate-slide-in-left",
          "animate-slide-in-right"
        );
        pendingTransition = false;
      }, 300);

      // Reset back flag AFTER using it
      isBack = false;
    });
  }
}
