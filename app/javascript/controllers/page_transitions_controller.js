import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = [];

  connect() {
    console.log("Page transitions controller connected - delegating to page_transitions.js");
    // This controller is now inactive - all transition logic handled by page_transitions.js
  }
}
