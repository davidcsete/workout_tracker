import { Controller } from "@hotwired/stimulus"
import { Chart, BarElement, BarController, CategoryScale, LinearScale, Title, Tooltip } from "chart.js/auto"
export default class WorkoutChartController extends Controller {
  static outputTarget = ["output"]
  static values = {
    url: String
  }


  async fetchData() {    
    try {
    await fetch(`${window.location.protocol}//${window.location.host}` + "/api/exercise_trackings")
      .then(response => {
        if (!response.ok) throw new Error('Network response was not ok');
        return response.json(); // return JSON
      })
      .then(data => {
        this.outputTarget = data;        
      })
    } catch (error) {
      console.error('There has been a problem with your fetch operation:', error);
    }
  }

  async connect() {
    if (!(this.element instanceof HTMLCanvasElement)) {
      console.error("The element is not a canvas element.");
      return;
    }
    await this.fetchData()

    Chart.register(BarElement, BarController, CategoryScale, LinearScale, Title, Tooltip);

    const ctx = document.getElementById('myChart');

    new Chart(ctx, {
      type: "bar",
      data: {
        labels: ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"],
        datasets: [{
          label: "Workout Duration (min)",
          data: [this.outputTarget["Mon"], this.outputTarget["Tue"], this.outputTarget["Wed"], this.outputTarget["Thu"],  this.outputTarget["Fri"], this.outputTarget["Sat"], this.outputTarget["Sun"]],
          backgroundColor: "rgba(59, 130, 246, 0.5)",
          borderColor: "rgba(59, 130, 246, 1)",
          borderWidth: 1,
        }],
      },
      options: {
        responsive: true,
        scales: {
          y: {
            beginAtZero: true,
          },
        },
      },
    });

  }
}
