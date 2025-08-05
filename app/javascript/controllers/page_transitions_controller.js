import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = [];

  connect() {
    // Controller is inactive - all logic handled by page_transitions.js
    // Removed console.log to prevent spam
  }
}
