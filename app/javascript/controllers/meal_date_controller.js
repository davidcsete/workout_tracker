import { Controller } from "@hotwired/stimulus"

export default class MealDateController extends Controller {
  static targets = ["dateDisplay", "dateLink"]

  connect() {
    this.date = new Date(this.dateDisplayTarget.textContent)
  }

  prev() {
    this.changeDate(-1)
  }

  next() {
    this.changeDate(1)
  }

  updateLinks(dateString) {
    this.dateLinkTargets.forEach(link => {
      const url = new URL(link.href)
      url.searchParams.set('date', dateString)
      link.href = url.toString()
    })
  }

  changeDate(delta) {
    this.date.setDate(this.date.getDate() + delta)
    this.updateDateDisplay()

    // Format date as yyyy-mm-dd
    const year = this.date.getFullYear();
    const month = String(this.date.getMonth() + 1).padStart(2, '0');
    const day = String(this.date.getDate()).padStart(2, '0');
    const dateString = `${year}-${month}-${day}`;
    this.updateLinks(dateString)
    // Fetch new content for both turbo frames
    this.loadTurboFrame("daily_totals", dateString)
    this.loadTurboFrame("daily_meals", dateString)
  }

  updateDateDisplay() {
    const options = { year: 'numeric', month: 'long', day: 'numeric' }
    this.dateDisplayTarget.textContent = this.date.toLocaleDateString(undefined, options)
  }

  loadTurboFrame(frameId, date) {
    fetch(`?date=${date}`, {
      headers: { "Turbo-Frame": frameId }
    }).then(response => response.text())
      .then(html => {
        const parser = new DOMParser()
        const doc = parser.parseFromString(html, 'text/html')
        const newFrameContent = doc.querySelector(`#${frameId}`)
        
        if (newFrameContent) {
          const frame = document.getElementById(frameId)
          // Replace only the inner content, not the frame itself
          frame.innerHTML = newFrameContent.innerHTML
        }
      })
  }
}
