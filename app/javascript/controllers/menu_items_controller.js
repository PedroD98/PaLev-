import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["dishesContainer", "dishTemplate", "beveragesContainer", "beverageTemplate"]

  addDish() {
    const newField = this.dishTemplateTarget.content.cloneNode(true);
    this.dishesContainerTarget.appendChild(newField);
  }

  addBeverage() {
    const newField = this.beverageTemplateTarget.content.cloneNode(true);
    this.beveragesContainerTarget.appendChild(newField);
  }
}