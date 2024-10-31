import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["newTags"]

  addTag() {
    const newTagContainer = document.createElement("div"); 
    newTagContainer.classList.add("mt-2", "mb-2");

    const newTagLabel = document.createElement("label");
    newTagLabel.innerText = "Novo marcador";

    const newTagField = document.createElement("input");
    newTagField.setAttribute("id", "new_tags_fields");
    newTagField.setAttribute("type", "text");
    newTagField.setAttribute("name", "dish[tag_ids][]");
    newTagField.setAttribute("placeholder", "Ex: Sem glúten");
    newTagField.classList.add("mt-2", "mb-2");

    newTagContainer.appendChild(newTagLabel);
    newTagContainer.appendChild(newTagField);

    this.newTagsTarget.appendChild(newTagContainer);
  }
}