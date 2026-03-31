import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ['toggle', 'form', 'select'];

  connect() {
    this.updateToggleState(false);
  }

  toggle() {
    const isHidden = this.formTarget.hidden;
    this.formTarget.hidden = !isHidden;
    this.updateToggleState(!isHidden);
  }

  onProductChange() {
    if (this.selectTarget.value) {
      this.hideForm();
    }
  }

  hideForm() {
    this.formTarget.hidden = true;
    this.updateToggleState(false);
  }

  updateToggleState(isActive) {
    if (isActive) {
      this.toggleTarget.classList.add('active');
      this.toggleTarget.setAttribute('aria-expanded', 'true');
      this.toggleTarget.setAttribute('aria-controls', 'product-form-fields');
    } else {
      this.toggleTarget.classList.remove('active');
      this.toggleTarget.setAttribute('aria-expanded', 'false');
      this.toggleTarget.removeAttribute('aria-controls');
    }
  }
}
