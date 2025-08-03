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

    // Reset back flag on regular navigation (but not immediately)
    document.addEventListener("turbo:before-visit", (event) => {
      // Only reset if this is NOT a popstate navigation
      if (!isBack) {
        console.log("Regular navigation detected");
      }
    });

    // Apply transitions with ultra-aggressive deduplication
    document.addEventListener("turbo:render", () => {
      const currentUrl = window.location.href;
      const currentId = ++transitionId;

      // Skip if URL hasn't changed (duplicate event)
      if (currentUrl === lastUrl) {
        console.log("Skipped: same URL");
        return;
      }

      lastUrl = currentUrl;
      const direction = isBack ? "back" : "forward";

      console.log(`Transition ${currentId}:`, direction, `(isBack: ${isBack})`);

      // Apply transition immediately
      const body = document.body;
      body.classList.remove("animate-slide-in-left", "animate-slide-in-right");

      // Small delay to ensure clean transition
      requestAnimationFrame(() => {
        if (direction === "forward") {
          body.classList.add("animate-slide-in-right");
          console.log("Applied: animate-slide-in-right");
        } else {
          body.classList.add("animate-slide-in-left");
          console.log("Applied: animate-slide-in-left");
        }
      });

      // Clean up after animation
      setTimeout(() => {
        body.classList.remove(
          "animate-slide-in-left",
          "animate-slide-in-right"
        );
      }, 300);

      // Reset back flag AFTER using it
      isBack = false;
    });
  }
}
