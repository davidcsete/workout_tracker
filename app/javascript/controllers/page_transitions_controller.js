import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = [];

  connect() {
    console.log("Page transitions controller connected");
    this.setupTransitions();
  }

  setupTransitions() {
    let isBackNavigation = false;

    // Simple test - apply animation on every page load
    document.addEventListener("turbo:load", () => {
      console.log("Turbo load event - applying test animation");
      this.testAnimation();
    });

    // Track browser back button
    window.addEventListener("popstate", () => {
      console.log("Browser back button pressed");
      isBackNavigation = true;
    });

    // Track clicks on links/buttons that might be "back" actions
    document.addEventListener("click", (event) => {
      const element = event.target.closest('a, button');
      if (!element) return;

      const text = (element.textContent || "").toLowerCase();
      if (text.includes("back") || text.includes("←")) {
        console.log("Back link clicked");
        isBackNavigation = true;
      }
    });

    // Apply transition on navigation
    document.addEventListener("turbo:before-render", () => {
      console.log("Before render - applying transition", isBackNavigation ? "back" : "forward");
      
      const direction = isBackNavigation ? "back" : "forward";
      this.applyTransition(direction);
      
      // Reset back flag
      isBackNavigation = false;
    });
  }

  testAnimation() {
    const body = document.body;
    body.classList.add("animate-slide-in-right");
    console.log("Test animation applied");
    
    setTimeout(() => {
      body.classList.remove("animate-slide-in-right");
      console.log("Test animation removed");
    }, 300);
  }

  applyTransition(direction) {
    const body = document.body;
    
    // Remove any existing animation classes
    body.classList.remove("animate-slide-in-left", "animate-slide-in-right");
    
    // Apply the appropriate animation
    if (direction === "forward") {
      body.classList.add("animate-slide-in-right");
      console.log("Applied forward transition (slide from right)");
    } else {
      body.classList.add("animate-slide-in-left");
      console.log("Applied back transition (slide from left)");
    }
    
    // Clean up after animation
    setTimeout(() => {
      body.classList.remove("animate-slide-in-left", "animate-slide-in-right");
      console.log("Transition cleanup completed");
    }, 300);
  }
}
