import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = [
    "dailyCalories",
    "weightChange",
    "proteinPercentage",
    "carbPercentage",
    "fatPercentage",
    "proteinGrams",
    "carbGrams",
    "fatGrams",
    "percentageIndicator",
    "calorieSuggestion",
  ];

  connect() {
    this.isUpdating = false;
    this.previousWeightChange = null;
    // Small delay to ensure all targets are available
    setTimeout(() => {
      this.updateMacroGrams();
      this.updatePercentageIndicator();
      // Store initial weight change value
      this.previousWeightChange = parseFloat(this.weightChangeTarget.value) || 0;
    }, 100);
  }

  // Called when weight change goal is modified
  weightChangeChanged() {
    this.suggestCalorieAdjustment();
  }

  // Called when daily calories are modified
  caloriesChanged() {
    this.updateMacroGrams();
  }

  // Called when any macro percentage is modified
  macroChanged(event) {
    if (this.isUpdating) return;

    const changedMacro = event.target.dataset.macro;
    this.handleMacroChange(changedMacro, event);
  }

  handleMacroChange(changedMacro, event) {
    this.isUpdating = true;

    const protein = parseFloat(this.proteinPercentageTarget.value) || 0;
    const carbs = parseFloat(this.carbPercentageTarget.value) || 0;
    const fat = parseFloat(this.fatPercentageTarget.value) || 0;

    const total = protein + carbs + fat;

    if (total > 100) {
      // Auto-adjust other macros proportionally
      const changedValue = parseFloat(event.target.value) || 0;
      const remaining = 100 - changedValue;
      const otherTotal = total - changedValue;

      if (otherTotal > 0) {
        const ratio = remaining / otherTotal;

        if (changedMacro !== "protein") {
          this.proteinPercentageTarget.value =
            Math.round(protein * ratio * 10) / 10;
        }
        if (changedMacro !== "carbs") {
          this.carbPercentageTarget.value = Math.round(carbs * ratio * 10) / 10;
        }
        if (changedMacro !== "fat") {
          this.fatPercentageTarget.value = Math.round(fat * ratio * 10) / 10;
        }
      }
    }

    this.updateMacroGrams();
    this.updatePercentageIndicator();
    this.isUpdating = false;
  }

  updateMacroGrams() {
    const calories = parseFloat(this.dailyCaloriesTarget.value) || 0;
    const protein = parseFloat(this.proteinPercentageTarget.value) || 0;
    const carbs = parseFloat(this.carbPercentageTarget.value) || 0;
    const fat = parseFloat(this.fatPercentageTarget.value) || 0;

    // Calculate grams: (calories * percentage / 100) / calories_per_gram
    // Protein & Carbs = 4 cal/g, Fat = 9 cal/g
    const proteinCalories = calories * protein / 100;
    const carbCalories = calories * carbs / 100;
    const fatCalories = calories * fat / 100;
    
    const proteinGrams = Math.round((proteinCalories / 4) * 10) / 10;
    const carbGrams = Math.round((carbCalories / 4) * 10) / 10;
    const fatGrams = Math.round((fatCalories / 9) * 10) / 10;

    this.proteinGramsTarget.innerHTML = `<span class="font-semibold">${proteinGrams}g</span>`;
    this.carbGramsTarget.innerHTML = `<span class="font-semibold">${carbGrams}g</span>`;
    this.fatGramsTarget.innerHTML = `<span class="font-semibold">${fatGrams}g</span>`;
  }

  updatePercentageIndicator() {
    const protein = parseFloat(this.proteinPercentageTarget.value) || 0;
    const carbs = parseFloat(this.carbPercentageTarget.value) || 0;
    const fat = parseFloat(this.fatPercentageTarget.value) || 0;
    const total = protein + carbs + fat;

    if (total === 100) {
      this.percentageIndicatorTarget.className = "alert alert-success mt-2";
      this.percentageIndicatorTarget.innerHTML =
        '<div class="text-sm">✓ Perfect! Macros add up to 100%</div>';
    } else if (total < 100) {
      this.percentageIndicatorTarget.className = "alert alert-warning mt-2";
      this.percentageIndicatorTarget.innerHTML = `<div class="text-sm">⚠ Total: ${total}% (${
        100 - total
      }% remaining)</div>`;
    } else {
      this.percentageIndicatorTarget.className = "alert alert-error mt-2";
      this.percentageIndicatorTarget.innerHTML = `<div class="text-sm">⚠ Total: ${total}% (${
        total - 100
      }% over limit)</div>`;
    }
  }

  suggestCalorieAdjustment() {
    const weightChange = parseFloat(this.weightChangeTarget.value) || 0;
    const currentCalories = parseFloat(this.dailyCaloriesTarget.value) || 2000;

    if (Math.abs(weightChange) > 0.05) {
      // Calculate the change in weight goal if we have a previous value
      if (this.previousWeightChange !== null) {
        const weightChangeAdjustment = weightChange - this.previousWeightChange;
        const calorieAdjustment = (weightChangeAdjustment * 7700) / 7;
        const suggestedCalories = Math.round(currentCalories + calorieAdjustment);
        
        console.log('Previous weight change:', this.previousWeightChange);
        console.log('New weight change:', weightChange);
        console.log('Weight change adjustment:', weightChangeAdjustment);
        console.log('Calorie adjustment:', calorieAdjustment);
        console.log('Suggested calories:', suggestedCalories);

        // Only show suggestion if there's a meaningful change
        if (Math.abs(calorieAdjustment) > 50) {
          this.calorieSuggestionTarget.className = "alert alert-info mt-2";
          this.calorieSuggestionTarget.innerHTML = `
            <div class="text-sm">
              <strong>💡 Suggestion:</strong> For ${
                weightChange > 0 ? "gaining" : "losing"
              } ${Math.abs(weightChange)}kg/week, 
              consider ${suggestedCalories} calories/day 
              <small class="block text-xs opacity-70 mt-1">
                Current: ${currentCalories} ${calorieAdjustment > 0 ? '+' : ''}${Math.round(calorieAdjustment)} = ${suggestedCalories}
              </small>
              <button type="button" class="btn btn-xs btn-primary ml-2" data-action="click->diet-goal-calculator#applyCalorieSuggestion" data-calories="${suggestedCalories}">
                Apply
              </button>
            </div>
          `;
          this.calorieSuggestionTarget.style.display = "block";
        } else {
          this.calorieSuggestionTarget.style.display = "none";
        }
      } else {
        // First time calculation - use absolute method
        const dailyAdjustment = (weightChange * 7700) / 7;
        const estimatedMaintenance = 2000; // Could be improved with user data
        const suggestedCalories = Math.round(estimatedMaintenance + dailyAdjustment);
        
        if (Math.abs(suggestedCalories - currentCalories) > 50) {
          this.calorieSuggestionTarget.className = "alert alert-info mt-2";
          this.calorieSuggestionTarget.innerHTML = `
            <div class="text-sm">
              <strong>💡 Suggestion:</strong> For ${
                weightChange > 0 ? "gaining" : "losing"
              } ${Math.abs(weightChange)}kg/week, 
              consider ${suggestedCalories} calories/day 
              <button type="button" class="btn btn-xs btn-primary ml-2" data-action="click->diet-goal-calculator#applyCalorieSuggestion" data-calories="${suggestedCalories}">
                Apply
              </button>
            </div>
          `;
          this.calorieSuggestionTarget.style.display = "block";
        } else {
          this.calorieSuggestionTarget.style.display = "none";
        }
      }
      
      // Update the previous weight change for next calculation
      this.previousWeightChange = weightChange;
    } else {
      this.calorieSuggestionTarget.style.display = "none";
    }
  }

  applyCalorieSuggestion(event) {
    const calories = event.target.dataset.calories;
    this.dailyCaloriesTarget.value = calories;
    this.updateMacroGrams();
    this.calorieSuggestionTarget.style.display = "none";
  }

  // Preset macro combinations
  applyPreset(event) {
    const preset = event.target.dataset.preset;
    let protein, carbs, fat;

    switch (preset) {
      case "weight-loss":
        [protein, carbs, fat] = [30, 40, 30];
        break;
      case "muscle-gain":
        [protein, carbs, fat] = [25, 45, 30];
        break;
      case "balanced":
        [protein, carbs, fat] = [20, 50, 30];
        break;
      case "performance":
        [protein, carbs, fat] = [25, 50, 25];
        break;
      case "keto":
        [protein, carbs, fat] = [15, 20, 65];
        break;
      default:
        return;
    }

    this.proteinPercentageTarget.value = protein;
    this.carbPercentageTarget.value = carbs;
    this.fatPercentageTarget.value = fat;
    this.updateMacroGrams();
    this.updatePercentageIndicator();
  }
}
