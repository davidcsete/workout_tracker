let lastNavigationDirection = "forward";

window.addEventListener("popstate", () => {
  lastNavigationDirection = "back";
});

document.addEventListener("turbo:click", () => {
  lastNavigationDirection = "forward";
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
