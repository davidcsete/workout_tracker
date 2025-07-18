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
    newPage.classList.add("animate-slide-in-right");
  } else {
    newPage.classList.add("animate-slide-in-left");
  }

  // Optional: reset after render
  lastNavigationDirection = "forward";
});
