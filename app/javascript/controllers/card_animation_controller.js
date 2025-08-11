import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["card"]
  static values = { 
    stagger: { type: Boolean, default: false },
    delay: { type: Number, default: 0 }
  }

  connect() {
    this.observer = new IntersectionObserver(
      (entries) => this.handleIntersection(entries),
      {
        threshold: 0.1,
        rootMargin: "0px 0px -50px 0px"
      }
    )

    // Observe all cards
    this.cardTargets.forEach(card => {
      this.observer.observe(card)
    })

    // If no specific card targets, observe the element itself
    if (this.cardTargets.length === 0) {
      this.observer.observe(this.element)
    }
  }

  disconnect() {
    if (this.observer) {
      this.observer.disconnect()
    }
  }

  handleIntersection(entries) {
    entries.forEach(entry => {
      if (entry.isIntersecting) {
        this.animateCard(entry.target)
        this.observer.unobserve(entry.target)
      }
    })
  }

  animateCard(card) {
    // Add a small delay if specified
    setTimeout(() => {
      if (this.staggerValue) {
        card.classList.add("card-animate-stagger")
      } else {
        card.classList.add("card-animate")
      }
    }, this.delayValue)
  }
}