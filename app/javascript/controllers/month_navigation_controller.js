import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [ "previous", "next" ]

  params = new Proxy(new URLSearchParams(window.location.search), {
    get: (searchParams, prop) => searchParams.get(prop),
  });

  connect() {
    this.previousTarget.href = this.monthQuery(this.previous)
    this.nextTarget.href = this.monthQuery(this.next)
  }

  monthQuery(next) {
    return `?month=${this.monthString(next(this.useDate()))}`
  }

  previous(month) {
    return new Date(month.getFullYear(), month.getMonth(), 1);
  }

  next(month) {
    return new Date(month.getFullYear(), month.getMonth()+2, 1);
  }

  monthString(month) {
    return month.toISOString().split("T")[0]
  }

  useDate() {
    const providedDate = this.params.month;
    return providedDate ? new Date(providedDate) : new Date()
  }
}
