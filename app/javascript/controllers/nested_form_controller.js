import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["template", "list"];
  static outlets = [];

  connect() {
    this.wrapperClass = "pharmacotherapy-fields";
  }

  addPharmacotherapy(event) {
    event.preventDefault();
    const content = this.templateTarget.innerHTML.replace(/\[NEW_RECORD\]/g, new Date().getTime());
    this.listTarget.insertAdjacentHTML("beforeend", content);
  }

  removePharmacotherapy(event) {
    event.preventDefault();
    const wrapper = event.target.closest(`.${this.wrapperClass}`);
    if (wrapper.dataset.newRecord === "true") {
      wrapper.remove();
    } else {
      wrapper.querySelector("input[name*='_destroy']").value = "1";
      wrapper.hidden = true;
    }
  }
}
