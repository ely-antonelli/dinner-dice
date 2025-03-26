import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["container"];

  addStep(event) {
    event.preventDefault();
    console.log("addStep");

    const index = Date.now(); // Un identifiant unique basé sur le timestamp
    const template = `
      <div class="step">
        <label for="recipe_step_${index}">Recipe step</label>
        <textarea name="recipe[steps][]" id="recipe_step_${index}"></textarea>
        <button type="button" class="remove-step" data-action="click->steps#removeStep">Delete</button>
      </div>
    `;

    this.containerTarget.insertAdjacentHTML("beforeend", template);
  }

}
