import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = {
    baseServiceFee: Number,
    minimumBookableTime: Number,
    animals: Array
  }

  connect() {
    this.form = this.element.closest("form")
    if (!this.form) return

    this.petTypeInput = this.form.querySelector('[name="booking[pet_type]"]')
    this.timeSpanInput = this.form.querySelector('[name="booking[time_span]"]')
    this.displayTarget = this.element.querySelector("[data-expected-fee-target=display]")

    if (this.petTypeInput) {
      this.petTypeInput.addEventListener("change", this.updateFee.bind(this))
    }
    if (this.timeSpanInput) {
      this.timeSpanInput.addEventListener("input", this.updateFee.bind(this))
      this.timeSpanInput.addEventListener("change", this.updateFee.bind(this))
    }

    this.updateFee()
  }

  updateFee() {
    if (!this.displayTarget) return

    const animalId = this.petTypeInput?.value ? parseInt(this.petTypeInput.value, 10) : null
    const timeSpan = this.timeSpanInput?.value ? parseInt(this.timeSpanInput.value, 10) : 0

    if (!animalId || !timeSpan) {
      this.displayTarget.textContent = this.baseServiceFeeValue ? new Intl.NumberFormat("en-US", {
        style: "currency",
        currency: "USD"
      }).format(this.baseServiceFeeValue) : "—"
      return
    }

    const animals = this.animalsValue || []
    const animal = animals.find(a => a.id === animalId)
    if (!animal) {
      this.displayTarget.textContent = "—"
      return
    }

    const additionalHours = Math.max(0, timeSpan - this.minimumBookableTimeValue)

    const fee = this.baseServiceFeeValue + (animal.additional_hour_fee * additionalHours)
    this.displayTarget.textContent = new Intl.NumberFormat("en-US", {
      style: "currency",
      currency: "USD"
    }).format(fee)
  }
}
