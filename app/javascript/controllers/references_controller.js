// app/javascript/controllers/references_controller.js

import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["references", "template"]

  addReference(event) {
    event.preventDefault()
    const content = this.templateTarget.innerHTML.replace(/NEW_RECORD/g, new Date().getTime())
    this.referencesTarget.insertAdjacentHTML('beforeend', content)
  }
}
