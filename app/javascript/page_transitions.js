(function() {
  'use strict';
  
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
    let newIndex = navStack.findIndex(path => path === location.pathname);
    lastNavigationDirection = "back";
    if (newIndex > prevIndex) {
      lastNavigationDirection = "forward";
    } else if (newIndex < prevIndex) {
      lastNavigationDirection = "back";
    } else {
      console.log("Reload or same page");
    }
    sessionStorage.setItem("currentIndex", newIndex);
  });

  document.addEventListener("turbo:before-visit", (event) => {
    // Check if this is a back navigation by looking at the URL
    const currentPath = location.pathname;
    const targetPath = new URL(event.detail.url).pathname;
    
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
  let lastTransitionUrl = '';
  
  document.addEventListener("turbo:render", (event) => {
    const now = Date.now();
    const currentUrl = window.location.href;
    
    // Debounce: only apply transition if it's been more than 100ms since last transition
    // OR if it's a different URL
    if (now - lastTransitionTime < 100 && currentUrl === lastTransitionUrl) {
      console.log("Skipping duplicate transition");
      return;
    }
    
    lastTransitionTime = now;
    lastTransitionUrl = currentUrl;
    
    console.log("Transition applied:", lastNavigationDirection);
    
    // Apply animation to the current body (after render)
    const currentBody = document.body;
    
    // Clear any existing animation classes
    currentBody.classList.remove("animate-slide-in-left", "animate-slide-in-right");
    
    // Apply the appropriate animation
    if (lastNavigationDirection === "forward") {
      currentBody.classList.add("animate-slide-in-right");
    } else {
      currentBody.classList.add("animate-slide-in-left");
    }
    
    // Remove animation class after animation completes
    setTimeout(() => {
      currentBody.classList.remove("animate-slide-in-left", "animate-slide-in-right");
    }, 300);
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