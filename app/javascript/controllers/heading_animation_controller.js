import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["heading"]
  static values = { 
    stagger: { type: Boolean, default: false },
    delay: { type: Number, default: 0 }
  }

  connect() {
    this.observer = new IntersectionObserver(
      (entries) => this.handleIntersection(entries),
      {
        threshold: 0.2,
        rootMargin: "0px 0px -30px 0px"
      }
    )

    // Find and observe all h1 and h2 elements
    this.findAndObserveHeadings()
  }

  disconnect() {
    if (this.observer) {
      this.observer.disconnect()
    }
  }

  findAndObserveHeadings() {
    // If specific heading targets are defined, use those
    if (this.headingTargets.length > 0) {
      this.headingTargets.forEach(heading => {
        this.observer.observe(heading)
      })
    } else {
      // Otherwise, find all h1 and h2 elements within this controller's scope
      const headings = this.element.querySelectorAll('h1, h2')
      headings.forEach(heading => {
        this.observer.observe(heading)
      })
    }
  }

  handleIntersection(entries) {
    entries.forEach(entry => {
      if (entry.isIntersecting) {
        this.animateHeading(entry.target)
        this.observer.unobserve(entry.target)
      }
    })
  }

  animateHeading(heading) {
    // Add a small delay if specified
    setTimeout(() => {
      const isLargeHeading = heading.tagName === 'H1'
      
      if (this.staggerValue) {
        heading.classList.add("heading-animate-stagger")
      } else if (isLargeHeading) {
        heading.classList.add("heading-animate-large")
      } else {
        heading.classList.add("heading-animate")
      }
    }, this.delayValue)
  }
}