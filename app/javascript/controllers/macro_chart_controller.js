import { Controller } from "@hotwired/stimulus"
import { Chart, DoughnutController, ArcElement, Tooltip, Legend } from "chart.js/auto"

export default class extends Controller {
  static values = {
    protein: Number,
    carbs: Number,
    fats: Number
  }

  connect() {
    console.log("MacroChartController connected")

    // Register necessary chart components:
    Chart.register(DoughnutController, ArcElement, Tooltip, Legend)

    const ctx = this.element.getContext("2d")
    console.log("Canvas context:", ctx);
    new Chart(ctx, {
      type: "doughnut",
      data: {
        labels: ["Protein", "Carbs", "Fats"],
        datasets: [{
          label: "Macros (g)",
          data: [this.proteinValue, this.carbsValue, this.fatsValue],
          backgroundColor: ["#60a5fa", "#facc15", "#f87171"],
          borderColor: ["#3b82f6", "#eab308", "#ef4444"],
          borderWidth: 1
        }]
      },
      options: {
        plugins: {
          legend: {
            position: "bottom"
          },
          tooltip: {
            enabled: true
          }
        }
      }
    })
  }
}
