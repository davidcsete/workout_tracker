import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = { target: String, behavior: String }

  connect() {
    // Only scroll if we have a target
    if (this.targetValue) {
      this.scroll()
    }
  }

  scroll() {
    console.log('Scroll controller connected, target:', this.targetValue)
    
    // Try multiple times with increasing delays to find the element
    this.attemptScroll(0)
  }
  
  attemptScroll(attempt) {
    const maxAttempts = 5
    const delay = attempt * 200 // 0, 200, 400, 600, 800ms
    
    setTimeout(() => {
      // Check if we're on mobile (screen width < 1024px, which is lg breakpoint in Tailwind)
      const isMobile = window.innerWidth < 1024
      console.log(`Attempt ${attempt + 1}: Is mobile:`, isMobile, 'Window width:', window.innerWidth)
      
      // Temporarily remove mobile check for debugging
      if (true) {
        let targetElement = document.getElementById(this.targetValue)
        console.log(`Attempt ${attempt + 1}: Target element found:`, !!targetElement, 'ID:', this.targetValue)
        
        // If specific target not found, fallback to tracking feed
        if (!targetElement) {
          targetElement = document.getElementById('tracking_feed')
          console.log(`Attempt ${attempt + 1}: Fallback to tracking_feed:`, !!targetElement)
        }
        
        if (targetElement) {
          console.log(`Attempt ${attempt + 1}: Scrolling to element:`, targetElement)
          // Scroll to the target element with smooth behavior
          targetElement.scrollIntoView({ 
            behavior: this.behaviorValue || 'smooth', 
            block: 'center' 
          })
          return // Success, stop trying
        } else {
          console.log(`Attempt ${attempt + 1}: No target element found`)
          
          // Try again if we haven't reached max attempts
          if (attempt < maxAttempts - 1) {
            this.attemptScroll(attempt + 1)
          }
        }
      }
    }, delay)
  }
}