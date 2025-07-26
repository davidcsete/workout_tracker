// theme-handler.js
document.addEventListener('DOMContentLoaded', () => {
    const themeSwitcher = document.getElementById('theme-switcher');
    if (!themeSwitcher) return;
  
    // Set dropdown value to current theme
    const storedTheme = localStorage.getItem('theme');
    if (storedTheme) {
      themeSwitcher.value = storedTheme;
    }
  
    themeSwitcher.addEventListener('change', (e) => {
      const theme = e.target.value;
      document.documentElement.setAttribute('data-theme', theme);
      localStorage.setItem('theme', theme);
    });
  });

function applyThemeFromStorage() {
    const theme = localStorage.getItem('theme');
    if (theme) {
        document.documentElement.setAttribute('data-theme', theme);
    }
    console.log(theme)
}
  