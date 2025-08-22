(function () {
  "use strict";

  // Prevent multiple initialization
  if (window.pageTransitionsInitialized) return;
  window.pageTransitionsInitialized = true;

  let isBackNavigation = false;
  let navigationDirection = "forward";
  let navigationHistory = JSON.parse(
    sessionStorage.getItem("pageTransitionHistory") || "[]"
  );
  let currentHistoryIndex = parseInt(
    sessionStorage.getItem("pageTransitionIndex") || "0"
  );

  console.log("Page transitions initialized");
  console.log("Current history:", navigationHistory);
  console.log("Current index:", currentHistoryIndex);

  // Method 1: Track navigation direction via popstate (browser back/forward)
  window.addEventListener("popstate", () => {
    isBackNavigation = true;
    navigationDirection = "back";
    console.log("Back navigation detected via popstate");
  });

  // Method 2: Detect back navigation by comparing URLs and history
  function detectNavigationDirection(targetUrl) {
    const targetPath = new URL(targetUrl).pathname;
    const currentPath = window.location.pathname;

    console.log("Detecting direction:", {
      currentPath,
      targetPath,
      history: navigationHistory,
      index: currentHistoryIndex,
    });

    // Check if target URL exists in our history before current position
    const targetIndex = navigationHistory.indexOf(targetPath);

    if (targetIndex !== -1 && targetIndex < currentHistoryIndex) {
      console.log(
        "Back navigation detected: target URL found earlier in history"
      );
      return "back";
    }

    // Check if we're going to a parent route (shorter path)
    if (
      targetPath.length < currentPath.length &&
      currentPath.startsWith(targetPath)
    ) {
      console.log("Back navigation detected: going to parent route");
      return "back";
    }

    // Check for common back navigation patterns
    const backPatterns = [
      /\/\d+$/, // from /items/123 to /items
      /\/edit$/, // from /items/edit to /items
      /\/new$/, // from /items/new to /items
      /\/show$/, // from /items/show to /items
    ];

    for (const pattern of backPatterns) {
      if (pattern.test(currentPath) && !pattern.test(targetPath)) {
        console.log("Back navigation detected: pattern match");
        return "back";
      }
    }

    return "forward";
  }

  // Method 3: Track navigation history manually
  function updateNavigationHistory(url) {
    const path = new URL(url).pathname;

    if (navigationDirection === "back") {
      // Going back - update index but don't modify history
      const targetIndex = navigationHistory.indexOf(path);
      if (targetIndex !== -1) {
        currentHistoryIndex = targetIndex;
      }
    } else {
      // Going forward - add to history or update index
      const existingIndex = navigationHistory.indexOf(path);
      if (existingIndex !== -1) {
        currentHistoryIndex = existingIndex;
      } else {
        // New page - add to history
        navigationHistory = navigationHistory.slice(0, currentHistoryIndex + 1);
        navigationHistory.push(path);
        currentHistoryIndex = navigationHistory.length - 1;
      }
    }

    // Save to session storage
    sessionStorage.setItem(
      "pageTransitionHistory",
      JSON.stringify(navigationHistory)
    );
    sessionStorage.setItem(
      "pageTransitionIndex",
      currentHistoryIndex.toString()
    );

    console.log("Updated history:", {
      history: navigationHistory,
      index: currentHistoryIndex,
    });
  }

  // Reset back navigation flag on new visits and determine direction
  document.addEventListener("turbo:before-visit", (event) => {
    const targetUrl = event.detail.url;

    console.log(
      "turbo:before-visit fired, isBackNavigation:",
      isBackNavigation
    );
    console.log("Target URL:", targetUrl);

    if (!isBackNavigation) {
      // Use URL analysis to detect back navigation
      navigationDirection = detectNavigationDirection(targetUrl);
      console.log("Navigation direction determined:", navigationDirection);
    } else {
      console.log("Confirmed back navigation via popstate");
    }

    // Update our navigation history
    updateNavigationHistory(targetUrl);
  });

  // Apply transition immediately when page starts loading
  document.addEventListener("turbo:before-render", (event) => {
    console.log(
      "turbo:before-render - applying transition, direction:",
      navigationDirection
    );

    const newBody = event.detail.newBody;
    const mainContent =
      newBody.querySelector("#main-content") || newBody.querySelector("main");

    if (mainContent) {
      // Set initial state for animation based on direction
      if (navigationDirection === "back") {
        mainContent.style.transform = "translateX(-100%)";
        mainContent.style.opacity = "0.8";
        console.log("Set initial state for BACK navigation (slide from left)");
      } else {
        mainContent.style.transform = "translateX(100%)";
        mainContent.style.opacity = "0.8";
        console.log(
          "Set initial state for FORWARD navigation (slide from right)"
        );
      }
      mainContent.style.transition =
        "transform 0.4s cubic-bezier(0.4, 0, 0.2, 1), opacity 0.4s ease";
    }
  });

  // Animate in after render
  document.addEventListener("turbo:render", () => {
    console.log(
      "turbo:render - animating in, direction was:",
      navigationDirection
    );

    const mainContent =
      document.querySelector("#main-content") || document.querySelector("main");

    if (mainContent) {
      // Trigger animation to final position
      requestAnimationFrame(() => {
        mainContent.style.transform = "translateX(0)";
        mainContent.style.opacity = "1";
        console.log(
          "Animated to final position for",
          navigationDirection,
          "navigation"
        );

        // Clean up after animation
        setTimeout(() => {
          mainContent.style.transition = "";
          mainContent.style.transform = "";
          mainContent.style.opacity = "";

          // Reset flags after animation completes
          isBackNavigation = false;
          navigationDirection = "forward";
          console.log("Cleaned up transition styles and reset flags");
        }, 450);
      });
    }
  });

  // Handle Turbo Stream removals with animation
  document.addEventListener("turbo:before-stream-render", (event) => {
    const stream = event.target;
    if (stream.action === "remove") {
      const element = document.getElementById(stream.target);
      if (element) {
        element.style.transition = "all 0.3s ease-out";
        element.style.opacity = "0";
        element.style.transform = "translateX(20px)";
        setTimeout(() => element.remove(), 300);
        event.preventDefault();
      }
    }
  });
})();
