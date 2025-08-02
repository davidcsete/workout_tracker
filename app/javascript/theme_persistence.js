// Global theme persistence handler
// This ensures theme persists across all navigation types

(function() {
  'use strict';
  
  const THEME_KEY = 'theme';
  const DEFAULT_THEME = 'default';
  
  function getStoredTheme() {
    return localStorage.getItem(THEME_KEY) || DEFAULT_THEME;
  }
  
  function applyTheme(theme = null) {
    const currentTheme = theme || getStoredTheme();
    
    // Apply to document element (DaisyUI primary method)
    document.documentElement.setAttribute('data-theme', currentTheme);
    
    // Apply to body as fallback
    if (document.body) {
      document.body.setAttribute('data-theme', currentTheme);
    }
    
    // Add theme class for additional CSS targeting
    document.documentElement.className = document.documentElement.className
      .replace(/theme-\w+/g, '') + ` theme-${currentTheme}`;
  }
  
  // Apply theme immediately
  applyTheme();
  
  // Handle various page load states
  if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', applyTheme);
  }
  
  // Handle Turbo events
  document.addEventListener('turbo:load', applyTheme);
  document.addEventListener('turbo:render', applyTheme);
  document.addEventListener('turbo:before-cache', applyTheme);
  
  // Handle page visibility changes
  document.addEventListener('visibilitychange', function() {
    if (!document.hidden) {
      applyTheme();
    }
  });
  
  // Export for global access if needed
  window.ThemePersistence = {
    apply: applyTheme,
    get: getStoredTheme,
    set: function(theme) {
      localStorage.setItem(THEME_KEY, theme);
      applyTheme(theme);
    }
  };
})();