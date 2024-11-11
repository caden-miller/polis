// app/javascript/controllers/tabs_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["tab", "content"]

  connect() {
    // Default to the first tab
    this.showTab(this.tabTargets[0].dataset.tab)
  }

  change(event) {
    this.showTab(event.target.dataset.tab)
  }

  showTab(tab) {
    this.tabTargets.forEach(target => {
      target.classList.toggle("border-b-4", target.dataset.tab === tab)
    })
    this.contentTargets.forEach(content => {
      content.classList.toggle("hidden", content.dataset.tab !== tab)
    })
  }
}
