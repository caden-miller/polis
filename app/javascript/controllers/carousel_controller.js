// app/javascript/controllers/carousel_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["slide"]

  initialize() {
    this.currentIndex = 0
  }

  connect() {
    console.log("Connected!")
    this.showCurrentSlide()
  }

  next() {
    this.currentIndex++
    if (this.currentIndex >= this.slideTargets.length) {
      this.currentIndex = 0
    }
    this.showCurrentSlide()
  }

  previous() {
    this.currentIndex--
    if (this.currentIndex < 0) {
      this.currentIndex = this.slideTargets.length - 1
    }
    this.showCurrentSlide()
  }

  showCurrentSlide() {
    this.slideTargets.forEach((element, index) => {
      element.classList.toggle("hidden", index !== this.currentIndex)
    })
  }
}
