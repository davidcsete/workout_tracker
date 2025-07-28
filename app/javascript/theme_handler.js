// Apply theme from localStorage immediately (before DOM loads)
function applyThemeFromStorage() {
    const theme = localStorage.getItem('theme') || 'default';
    document.documentElement.setAttribute('data-theme', theme);
}

// Apply theme immediately
applyThemeFromStorage();

// Handle theme switching after DOM loads
document.addEventListener('DOMContentLoaded', () => {
    const themeRadios = document.querySelectorAll('input[name="theme-dropdown"]');
    if (!themeRadios.length) return;
  
    // Set the correct radio button as checked based on stored theme
    const storedTheme = localStorage.getItem('theme') || 'default';
    themeRadios.forEach(radio => {
        if (radio.value === storedTheme) {
            radio.checked = true;
        }
    });
  
    // Listen for theme changes
    themeRadios.forEach(radio => {
        radio.addEventListener('change', (e) => {
            if (e.target.checked) {
                const theme = e.target.value;
                document.documentElement.setAttribute('data-theme', theme);
                localStorage.setItem('theme', theme);
            }
        });
    });
});

// Also handle Turbo navigation (Rails 7 with Hotwire)
document.addEventListener('turbo:load', () => {
    applyThemeFromStorage();
    
    // Re-check the correct radio button after Turbo navigation
    const themeRadios = document.querySelectorAll('input[name="theme-dropdown"]');
    const storedTheme = localStorage.getItem('theme') || 'default';
    themeRadios.forEach(radio => {
        radio.checked = (radio.value === storedTheme);
    });
});
  