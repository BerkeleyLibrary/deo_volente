import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="dataloads"
export default class extends Controller {
  static values = { id: Number, doi: String }

  confirm(event) {
    if (!confirm(`Are you sure you wish to archive data load ${this.idValue} for dataset ${this.doiValue}?`)) {
      event.preventDefault()
    }
  }
}
