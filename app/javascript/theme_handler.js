// Apply theme from localStorage immediately (before DOM loads)
function applyThemeFromStorage() {
    const theme = localStorage.getItem('theme') || 'default';
    document.documentElement.setAttribute('data-theme', theme);
    // Also set it on the body as a fallback
    if (document.body) {
        document.body.setAttribute('data-theme', theme);
    }
}

// Apply theme immediately - run as soon as script loads
applyThemeFromStorage();

// Also apply on script load to catch early execution
if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', applyThemeFromStorage);
} else {
    applyThemeFromStorage();
}

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
                if (document.body) {
                    document.body.setAttribute('data-theme', theme);
                }
                localStorage.setItem('theme', theme);
                console.log('Theme changed to:', theme); // Debug log
            }
        });
    });
});

// Also handle Turbo navigation (Rails 7 with Hotwire)
document.addEventListener('turbo:load', () => {
    applyThemeFromStorage();
    
    // Re-check the correct radio button after Turbo navigation
    setTimeout(() => {
        const themeRadios = document.querySelectorAll('input[name="theme-dropdown"]');
        const storedTheme = localStorage.getItem('theme') || 'default';
        themeRadios.forEach(radio => {
            radio.checked = (radio.value === storedTheme);
        });
        console.log('Theme restored on turbo:load:', storedTheme); // Debug log
    }, 10); // Small delay to ensure DOM is ready
});

// Handle turbo:before-cache to preserve theme
document.addEventListener('turbo:before-cache', () => {
    applyThemeFromStorage();
});
  