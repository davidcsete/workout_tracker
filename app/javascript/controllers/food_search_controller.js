// app/javascript/controllers/food_search_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input", "results", "grams", "calories", "protein", "carbs", "fats"]
  static values = { 
    url: String,
    minLength: { type: Number, default: 2 },
    debounce: { type: Number, default: 300 }
  }

  connect() {
    console.log("Food search controller connected")
    this.timeout = null
    this.abortController = null
  }

  disconnect() {
    this.clearTimeout()
    this.abortRequest()
  }

  search() {
    console.log("Search method called", this.inputTarget.value)
    this.clearTimeout()
    
    const query = this.inputTarget.value.trim()
    
    if (query.length < this.minLengthValue) {
      this.hideResults()
      return
    }

    this.timeout = setTimeout(() => {
      this.performSearch(query)
    }, this.debounceValue)
  }

  async performSearch(query) {
    this.abortRequest()
    
    this.abortController = new AbortController()
    
    try {
      const params = new URLSearchParams({ q: query })
      const response = await fetch(`${this.urlValue}?${params}`, {
        signal: this.abortController.signal,
        headers: {
          'Accept': 'text/html',
          'X-Requested-With': 'XMLHttpRequest'
        }
      })
      
      if (response.ok) {
        const html = await response.text()
        this.displayResults(html)
      }
    } catch (error) {
      if (error.name !== 'AbortError') {
        console.error('Search failed:', error)
      }
    }
  }

  selectFood(event) {
    console.log("selectFood called")
    const foodData = {
      id: event.currentTarget.dataset.foodId,
      name: event.currentTarget.dataset.foodName,
      calories: event.currentTarget.dataset.foodCalories,
      protein: event.currentTarget.dataset.foodProtein,
      carbs: event.currentTarget.dataset.foodCarbs,
      fats: event.currentTarget.dataset.foodFats
    }
    
    console.log("Food data:", foodData)
    console.log("Available targets:", {
      hasGrams: this.hasGramsTarget,
      hasCalories: this.hasCaloriesTarget,
      hasProtein: this.hasProteinTarget,
      hasCarbs: this.hasCarbsTarget,
      hasFats: this.hasFatsTarget
    })
    
    // Set the food name in the input
    this.inputTarget.value = foodData.name
    
    // Set default grams to 100
    if (this.hasGramsTarget) {
      console.log("Setting grams to 100")
      this.gramsTarget.value = 100
    } else {
      console.log("Grams target not found")
    }
    
    // Fill in all nutritional values
    if (this.hasCaloriesTarget) {
      console.log("Setting calories to", foodData.calories)
      this.caloriesTarget.value = foodData.calories || 0
    } else {
      console.log("Calories target not found")
    }
    
    if (this.hasProteinTarget) {
      console.log("Setting protein to", foodData.protein)
      this.proteinTarget.value = foodData.protein || 0
    } else {
      console.log("Protein target not found")
    }
    
    if (this.hasCarbsTarget) {
      console.log("Setting carbs to", foodData.carbs)
      this.carbsTarget.value = foodData.carbs || 0
    } else {
      console.log("Carbs target not found")
    }
    
    if (this.hasFatsTarget) {
      console.log("Setting fats to", foodData.fats)
      this.fatsTarget.value = foodData.fats || 0
    } else {
      console.log("Fats target not found")
    }
    
    // Store base values for recalculation when grams change
    this.element.dataset.baseCalories = foodData.calories || 0
    this.element.dataset.baseProtein = foodData.protein || 0
    this.element.dataset.baseCarbs = foodData.carbs || 0
    this.element.dataset.baseFats = foodData.fats || 0
    
    // Hide results
    this.hideResults()
  }

  // Update nutritional values when grams change
  updateNutrition() {
    console.log(`here: ${this.hasGramsTarget}`)
    if (!this.hasGramsTarget) return
    
    const grams = parseFloat(this.gramsTarget.value) || 0
    const multiplier = grams / 100
    
    // Get base values (per 100g) from data attributes
    const baseCalories = parseFloat(this.element.dataset.baseCalories) || 0
    const baseProtein = parseFloat(this.element.dataset.baseProtein) || 0
    const baseCarbs = parseFloat(this.element.dataset.baseCarbs) || 0
    const baseFats = parseFloat(this.element.dataset.baseFats) || 0
    
    // Update fields with calculated values
    if (this.hasCaloriesTarget) {
      this.caloriesTarget.value = Math.round(baseCalories * multiplier)
    }
    
    if (this.hasProteinTarget) {
      this.proteinTarget.value = (baseProtein * multiplier).toFixed(1)
    }
    
    if (this.hasCarbsTarget) {
      this.carbsTarget.value = (baseCarbs * multiplier).toFixed(1)
    }
    
    if (this.hasFatsTarget) {
      this.fatsTarget.value = (baseFats * multiplier).toFixed(1)
    }
  }

  displayResults(html) {
    this.resultsTarget.innerHTML = html
    this.showResults()
  }

  showResults() {
    this.resultsTarget.classList.remove('hidden')
  }

  hideResults() {
    this.resultsTarget.classList.add('hidden')
  }

  clearTimeout() {
    if (this.timeout) {
      clearTimeout(this.timeout)
      this.timeout = null
    }
  }

  abortRequest() {
    if (this.abortController) {
      this.abortController.abort()
      this.abortController = null
    }
  }

  // Hide results when clicking outside
  clickOutside(event) {
    if (!this.element.contains(event.target)) {
      this.hideResults()
    }
  }
}