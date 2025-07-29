import { Controller } from "@hotwired/stimulus"

export default class StepsController extends Controller {
  static targets = ["stepPane"]

  connect() {
    console.log ('StepsController connected');
    this.currentStep = 1
    this.updateSteps()
  }

  next() {
    if (this.currentStep < 4) {
      this.currentStep++
      this.updateSteps()
    }
  }

  prev() {
    if (this.currentStep > 1) {
      this.currentStep--
      this.updateSteps()
    }
  }

  updateSteps() {
    this.stepPanes.forEach((el, index) => {
      el.classList.toggle("hidden", index + 1 !== this.currentStep)
    })

    document.querySelectorAll("[data-step]").forEach((stepEl, index) => {
      stepEl.classList.toggle("step-primary", index + 1 <= this.currentStep)
    })
  }

  get stepPanes() {
    return this.element.querySelectorAll("[data-step-pane]")
  }
}
