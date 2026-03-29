import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ['price', 'installmentPrice', 'installments', 'quantity', 'total'];

  connect() {
    this.recalculate();
  }

  onPriceChange() {
    this.recalculate();
  }

  onQuantityChange() {
    this.recalculate();
  }

  onInstallmentsChange() {
    this.recalculate();
  }

  onInstallmentPriceChange() {
    const installments = this.numberOfInstallments();
    this.priceTarget.value = (this.installmentPriceTarget.value * installments).toFixed(2);
    this.updateTotal();
  }

  recalculate() {
    const price = parseFloat(this.priceTarget.value) || 0;
    const quantity = parseFloat(this.quantityTarget.value) || 1;
    const installments = parseInt(this.installmentsTarget.value) || 1;

    const total = price * quantity;
    const installmentPrice = installments > 0 ? total / installments : total;

    this.installmentPriceTarget.value = installmentPrice.toFixed(2);
    this.updateTotal();
  }

  updateTotal() {
    const price = parseFloat(this.priceTarget.value) || 0;
    const quantity = parseFloat(this.quantityTarget.value) || 1;
    const total = price * quantity;
    this.totalTarget.textContent = this.formatCurrency(total);
  }

  formatCurrency(value) {
    return new Intl.NumberFormat('pt-BR', {
      style: 'currency',
      currency: 'BRL'
    }).format(value);
  }

  numberOfInstallments() {
    return parseInt(this.installmentsTarget.value) || 1;
  }
}
