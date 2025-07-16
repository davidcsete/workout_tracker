import { Controller } from "@hotwired/stimulus"

export default class FlashController extends Controller {
  close() {
    this.element.classList.add("opacity-0", "transition-opacity", "duration-500")
    setTimeout(() => this.element.remove(), 500)
  }
}
