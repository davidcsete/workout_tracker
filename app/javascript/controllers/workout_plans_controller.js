import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["searchInput", "planCard", "filterButton", "section"]
  static values = { 
    currentFilter: String 
  }

  connect() {
    this.currentFilterValue = "all-plans"
    this.updateFilterButtons()
  }

  search(event) {
    const searchTerm = event.target.value.toLowerCase()
    
    this.planCardTargets.forEach(card => {
      const planName = card.dataset.planName?.toLowerCase() || ""
      const planAuthor = card.dataset.planAuthor?.toLowerCase() || ""
      const shouldShow = planName.includes(searchTerm) || planAuthor.includes(searchTerm)
      
      card.style.display = shouldShow ? "block" : "none"
    })

    // Update empty states
    this.updateEmptyStates()
  }

  filter(event) {
    const filter = event.currentTarget.dataset.filter
    this.currentFilterValue = filter
    
    this.updateFilterButtons()
    this.updateSectionVisibility()
    this.updateEmptyStates()
  }

  updateFilterButtons() {
    this.filterButtonTargets.forEach(button => {
      if (button.dataset.filter === this.currentFilterValue) {
        button.classList.add("btn-active")
      } else {
        button.classList.remove("btn-active")
      }
    })
  }

  updateSectionVisibility() {
    this.sectionTargets.forEach(section => {
      if (this.currentFilterValue === "all-plans") {
        section.style.display = "block"
      } else if (this.currentFilterValue === "my-plans") {
        section.style.display = section.dataset.section === "my-plans" ? "block" : "none"
      }
    })
  }

  updateEmptyStates() {
    // This could be enhanced to show/hide empty state messages
    // based on visible cards after filtering/searching
  }

  quickTrack(event) {
    // Add loading state to the button
    const button = event.currentTarget
    const originalText = button.innerHTML
    
    button.innerHTML = `
      <span class="loading loading-spinner loading-sm"></span>
      Tracking...
    `
    button.disabled = true
    
    // The actual navigation will happen via the link
    // This just provides visual feedback
    setTimeout(() => {
      button.innerHTML = originalText
      button.disabled = false
    }, 2000)
  }
}