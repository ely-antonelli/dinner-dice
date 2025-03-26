import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="recipe-form"
export default class extends Controller {
  static targets = [ "form" ];
  connect() {
    console.log("Stimulus RecipeFormController connected")
  }

  toggleForm(event) {
    event.preventDefault()
    this.formTarget.classList.toggle("hidden")
  }

}
