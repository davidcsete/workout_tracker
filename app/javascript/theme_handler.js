// Simplified theme handler - works with Stimulus controller
function applyThemeFromStorage() {
    const theme = localStorage.getItem('theme') || 'default';
    document.documentElement.setAttribute('data-theme', theme);
    
    if (document.body) {
        document.body.setAttribute('data-theme', theme);
    }
    
    // Add theme class for additional CSS targeting
    document.documentElement.className = document.documentElement.className
        .replace(/theme-\w+/g, '') + ` theme-${theme}`;
}

// Apply theme immediately
applyThemeFromStorage();

// Handle DOM ready state
if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', applyThemeFromStorage);
}

// Handle Turbo navigation events
document.addEventListener('turbo:load', applyThemeFromStorage);
document.addEventListener('turbo:render', applyThemeFromStorage);
document.addEventListener('turbo:before-cache', applyThemeFromStorage);

// Handle page visibility changes
document.addEventListener('visibilitychange', function() {
    if (!document.hidden) {
        applyThemeFromStorage();
    }
});

// Export for global access
window.applyThemeFromStorage = applyThemeFromStorage;
  