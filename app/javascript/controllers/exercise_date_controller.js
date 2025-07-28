import { Controller } from "@hotwired/stimulus"

export default class ExerciseDateController extends Controller {
  static targets = ["dateDisplay", "dateLink", "dateInput"]

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
    
    this.updateDateInput(dateString)
    this.updateLinks(dateString)
    this.loadTurboFrame("tracking_feed", dateString)
  }

  updateDateInput(dateString) {
    if (this.hasDateInputTarget) {
      this.dateInputTarget.value = dateString
    }
  }

  updateDateDisplay() {
    const options = { year: 'numeric', month: 'long', day: 'numeric' }
    this.dateDisplayTarget.textContent = this.date.toLocaleDateString(undefined, options)
  }

  loadTurboFrame(frameId, date) {
    const workoutPlanId = this.element.dataset.workoutPlanId
    const exerciseId = this.element.dataset.exerciseId
    
    fetch(`/workout_plans/${workoutPlanId}/exercises/${exerciseId}/exercise_trackings/new?date=${date}`, {
      headers: { "Turbo-Frame": frameId }
    }).then(response => response.text())
      .then(html => {
        const parser = new DOMParser()
        const doc = parser.parseFromString(html, 'text/html')
        const newFrameContent = doc.querySelector(`#${frameId}`)
        
        if (newFrameContent) {
          const frame = document.getElementById(frameId)
          frame.innerHTML = newFrameContent.innerHTML
        }
      })
  }
}