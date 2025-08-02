import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["radio"]
  
  connect() {
    this.applyStoredTheme()
    this.updateRadioButtons()
  }

  change(event) {
    if (event.target.checked) {
      const theme = event.target.value
      this.setTheme(theme)
    }
  }

  setTheme(theme) {
    localStorage.setItem('theme', theme)
    this.applyTheme(theme)
  }

  applyTheme(theme = null) {
    const currentTheme = theme || this.getStoredTheme()
    
    document.documentElement.setAttribute('data-theme', currentTheme)
    if (document.body) {
      document.body.setAttribute('data-theme', currentTheme)
    }
    
    // Update class for additional CSS targeting
    document.documentElement.className = document.documentElement.className
      .replace(/theme-\w+/g, '') + ` theme-${currentTheme}`
  }

  applyStoredTheme() {
    this.applyTheme()
  }

  getStoredTheme() {
    return localStorage.getItem('theme') || 'default'
  }

  updateRadioButtons() {
    const currentTheme = this.getStoredTheme()
    this.radioTargets.forEach(radio => {
      radio.checked = (radio.value === currentTheme)
    })
  }
}