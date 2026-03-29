import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ['option', 'input'];

  connect() {
    this.updateSelectedState();
  }

  select(event) {
    const cardElement = event.currentTarget;
    const cardId = cardElement.dataset.cardId;

    this.optionTargets.forEach(el => el.classList.remove('selected'));
    cardElement.classList.add('selected');
    this.inputTarget.value = cardId;

    this.dispatch('card-selected', {
      detail: { cardId }
    });
  }

  updateSelectedState() {
    const selectedId = this.inputTarget.value;
    this.optionTargets.forEach(el => {
      if (el.dataset.cardId === selectedId) {
        el.classList.add('selected');
      }
    });
  }
}
