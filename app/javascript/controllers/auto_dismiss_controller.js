import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = { delay: Number }

  connect() {
    const delay = this.delayValue || 3000
    setTimeout(() => {
      this.dismiss()
    }, delay)
  }

  dismiss() {
    this.element.style.transition = "opacity 0.5s ease-out"
    this.element.style.opacity = "0"
    
    setTimeout(() => {
      if (this.element.parentNode) {
        this.element.remove()
      }
    }, 500)
  }
}