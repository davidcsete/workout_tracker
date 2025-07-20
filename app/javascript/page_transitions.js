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

document.addEventListener("turbo:click", (event) => {
  if (event.target.textContent.includes("Back")) {
    lastNavigationDirection = "back";
  } else {
    lastNavigationDirection = "forward";
  }
});

document.addEventListener("turbo:before-render", (event) => {
  const newPage = event.detail.newBody;

  if (lastNavigationDirection === "forward") {
    newPage.classList.remove("animate-slide-in-left");
    newPage.classList.add("animate-slide-in-right");
  } else {
    newPage.classList.remove("animate-slide-in-right");
    newPage.classList.add("animate-slide-in-left");
  }

  // Optional: reset after render
  lastNavigationDirection = "forward";
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