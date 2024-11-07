// app/javascript/controllers/word_count_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["textarea", "count"]

  connect() {
    this.updateWordCount() // initialize the word count on load
  }

  updateWordCount() {
    const text = this.textareaTarget.value.trim()
    const wordCount = text.length > 0 ? text.split(/\s+/).length : 0
    this.countTarget.textContent = wordCount
  }
}
