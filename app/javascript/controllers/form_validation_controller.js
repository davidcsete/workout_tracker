import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["repsInput", "weightInput", "submitButton"]

  connect() {
    this.validateForm()
    this.repsInputTarget.addEventListener("input", () => this.validateForm())
    this.weightInputTarget.addEventListener("input", () => this.validateForm())
  }

  validateForm() {
    const reps = parseFloat(this.repsInputTarget.value) || 0
    const weight = parseFloat(this.weightInputTarget.value) || 0
    
    const isValid = reps > 0 && weight > 0
    
    this.submitButtonTarget.disabled = !isValid
    
    if (!isValid) {
      this.submitButtonTarget.classList.add("btn-disabled")
    } else {
      this.submitButtonTarget.classList.remove("btn-disabled")
    }
  }
}