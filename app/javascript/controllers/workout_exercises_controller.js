import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["exerciseCard", "progressBar", "completionBadge"]
  static values = { 
    workoutPlanId: Number,
    totalExercises: Number,
    completedToday: Number
  }

  connect() {
    this.updateOverallProgress()
    this.initializeAnimations()
  }

  // Handle exercise completion
  markComplete(event) {
    const exerciseCard = event.currentTarget.closest('.card')
    const exerciseId = event.params.exerciseId
    
    // Add completion animation
    exerciseCard.classList.add('celebration-pulse')
    
    // Update completion badge
    const badge = exerciseCard.querySelector('.badge-success')
    if (!badge) {
      this.addCompletionBadge(exerciseCard)
    }
    
    // Update progress
    this.completedTodayValue += 1
    this.updateOverallProgress()
    
    // Remove animation class after animation completes
    setTimeout(() => {
      exerciseCard.classList.remove('celebration-pulse')
    }, 600)
  }

  // Add completion badge to exercise card
  addCompletionBadge(card) {
    const badge = document.createElement('div')
    badge.className = 'badge badge-success badge-sm absolute top-2 right-2'
    badge.innerHTML = `
      <svg class="w-3 h-3 mr-1" fill="none" stroke="currentColor" viewBox="0 0 24 24">
        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7"></path>
      </svg>
      Done Today
    `
    card.appendChild(badge)
  }

  // Update overall progress indicators
  updateOverallProgress() {
    const progressElements = document.querySelectorAll('.radial-progress')
    const percentage = Math.round((this.completedTodayValue / this.totalExercisesValue) * 100)
    
    progressElements.forEach(element => {
      if (element.closest('.stats')) {
        element.style.setProperty('--value', percentage)
        element.textContent = `${percentage}%`
      }
    })
  }

  // Initialize entrance animations
  initializeAnimations() {
    const cards = this.exerciseCardTargets
    cards.forEach((card, index) => {
      card.style.opacity = '0'
      card.style.transform = 'translateY(20px)'
      
      setTimeout(() => {
        card.style.transition = 'all 0.5s ease-out'
        card.style.opacity = '1'
        card.style.transform = 'translateY(0)'
      }, index * 100)
    })
  }

  // Handle quick track action
  quickTrack(event) {
    const button = event.currentTarget
    const originalText = button.innerHTML
    
    // Show loading state
    button.innerHTML = `
      <span class="loading loading-spinner loading-xs"></span>
      Tracking...
    `
    button.disabled = true
    
    // Reset after a delay (this would normally be handled by the server response)
    setTimeout(() => {
      button.innerHTML = originalText
      button.disabled = false
    }, 2000)
  }

  // Filter exercises by day
  filterByDay(event) {
    const selectedDay = event.target.value
    const dayCards = document.querySelectorAll('[data-day]')
    
    dayCards.forEach(card => {
      if (selectedDay === 'all' || card.dataset.day === selectedDay) {
        card.style.display = 'block'
        card.style.animation = 'fadeIn 0.3s ease-in'
      } else {
        card.style.display = 'none'
      }
    })
  }

  // Search exercises
  searchExercises(event) {
    const query = event.target.value.toLowerCase()
    const exerciseCards = this.exerciseCardTargets
    
    exerciseCards.forEach(card => {
      const exerciseName = card.querySelector('h3').textContent.toLowerCase()
      const exerciseDescription = card.querySelector('p')?.textContent.toLowerCase() || ''
      
      if (exerciseName.includes(query) || exerciseDescription.includes(query)) {
        card.closest('.card').style.display = 'block'
        card.closest('.card').style.animation = 'fadeIn 0.3s ease-in'
      } else {
        card.closest('.card').style.display = 'none'
      }
    })
  }

  // Show exercise details modal
  showDetails(event) {
    const exerciseId = event.params.exerciseId
    const modal = document.getElementById('exercise-details-modal')
    
    // Fetch exercise details and populate modal
    // This would typically make an AJAX request
    if (modal) {
      modal.showModal()
    }
  }

  // Handle drag and drop for exercise reordering
  startDrag(event) {
    event.dataTransfer.setData('text/plain', event.target.dataset.exerciseId)
    event.target.style.opacity = '0.5'
  }

  endDrag(event) {
    event.target.style.opacity = '1'
  }

  allowDrop(event) {
    event.preventDefault()
  }

  drop(event) {
    event.preventDefault()
    const draggedId = event.dataTransfer.getData('text/plain')
    const targetId = event.target.closest('[data-exercise-id]')?.dataset.exerciseId
    
    if (draggedId && targetId && draggedId !== targetId) {
      // Handle reordering logic here
      console.log(`Reorder exercise ${draggedId} to position of ${targetId}`)
    }
  }
}