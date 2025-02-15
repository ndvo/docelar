import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ['price', 'installmentPrice', 'installments']

  onPriceChange() {
    this.installmentPriceTarget.value = this.priceTarget.value / this.numberOfInstallments()
  }

  onInstallmentPriceChange() {
    this.priceTarget.value = this.installmentPriceTarget.value * this.numberOfInstallments()
  }

  numberOfInstallments() {
    return this.installmentsTarget.value || 1;
  }
}
