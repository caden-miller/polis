// app/javascript/controllers/posts_controller.js

import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  submitForm(event) {
    // Find the closest form and submit it
    event.target.closest('form').submit()
  }
}
