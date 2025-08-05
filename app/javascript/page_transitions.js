(function () {
  "use strict";

  // Prevent multiple initialization
  if (window.pageTransitionsInitialized) return;
  window.pageTransitionsInitialized = true;

  let lastNavigationDirection = "forward";
  let navStack = JSON.parse(sessionStorage.getItem("navStack")) || [];
  let currentIndex = sessionStorage.getItem("currentIndex");

  if (currentIndex === null) {
    currentIndex = 0;
    sessionStorage.setItem("currentIndex", currentIndex);
    navStack.push(location.pathname);
    sessionStorage.setItem("navStack", JSON.stringify(navStack));
  }

  window.addEventListener("popstate", (_event) => {
    let prevIndex = parseInt(sessionStorage.getItem("currentIndex"));
    let newIndex = navStack.findIndex((path) => path === location.pathname);

    if (newIndex > prevIndex) {
      lastNavigationDirection = "forward";
    } else if (newIndex < prevIndex) {
      lastNavigationDirection = "back";
    } else {
      // Same page or reload - default to forward
      lastNavigationDirection = "forward";
    }
    sessionStorage.setItem("currentIndex", newIndex);
  });

  let lastVisitTime = 0;
  let lastVisitUrl = "";

  document.addEventListener("turbo:before-visit", (event) => {
    const now = Date.now();
    const targetUrl = event.detail.url;

    // Prevent rapid duplicate visits to the same URL
    if (now - lastVisitTime < 300 && targetUrl === lastVisitUrl) {
      event.preventDefault();
      return;
    }

    lastVisitTime = now;
    lastVisitUrl = targetUrl;

    // Check if this is a back navigation by looking at the URL
    const currentPath = location.pathname;
    const targetPath = new URL(targetUrl).pathname;

    const currentIndex = navStack.indexOf(currentPath);
    const targetIndex = navStack.indexOf(targetPath);

    if (targetIndex !== -1 && targetIndex < currentIndex) {
      lastNavigationDirection = "back";
    } else {
      lastNavigationDirection = "forward";
      // Add new path to stack if it's not already there
      if (targetIndex === -1) {
        navStack.push(targetPath);
        sessionStorage.setItem("navStack", JSON.stringify(navStack));
      }
    }
  });

  let lastTransitionTime = 0;
  let lastTransitionUrl = "";
  let isTransitioning = false;

  document.addEventListener("turbo:render", (event) => {
    const now = Date.now();
    const currentUrl = window.location.href;

    // Prevent multiple transitions from running simultaneously
    if (isTransitioning) {
      return;
    }

    // Debounce: only apply transition if it's been more than 200ms since last transition
    // OR if it's a different URL
    if (now - lastTransitionTime < 200 && currentUrl === lastTransitionUrl) {
      return;
    }

    isTransitioning = true;
    lastTransitionTime = now;
    lastTransitionUrl = currentUrl;

    // Apply animation to the current body (after render)
    const currentBody = document.body;

    // Clear any existing animation classes
    currentBody.classList.remove(
      "animate-slide-in-left",
      "animate-slide-in-right"
    );

    // Apply the appropriate animation
    if (lastNavigationDirection === "forward") {
      currentBody.classList.add("animate-slide-in-right");
    } else {
      currentBody.classList.add("animate-slide-in-left");
    }

    // Remove animation class after animation completes
    setTimeout(() => {
      currentBody.classList.remove(
        "animate-slide-in-left",
        "animate-slide-in-right"
      );
      isTransitioning = false; // Reset the flag
    }, 400); // Slightly longer timeout to ensure animation completes
  });

  document.addEventListener("turbo:before-stream-render", (event) => {
    const stream = event.target;
    if (stream.action === "remove") {
      const element = document.getElementById(stream.target);
      if (element) {
        element.classList.add("opacity-0", "translate-x-4");
        element.classList.remove("transition-none");
        setTimeout(() => element.remove(), 300); // Match Tailwind duration
        event.preventDefault();
      }
    }
  });
})();
