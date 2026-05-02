import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    this.updatePanelFieldsVisibility()
    
    const foldTypeSelect = document.getElementById('greeting_card_fold_type')
    if (foldTypeSelect) {
      foldTypeSelect.addEventListener('change', () => this.updatePanelFieldsVisibility())
    }
  }

  updatePanelFieldsVisibility() {
    const foldTypeSelect = document.getElementById('greeting_card_fold_type')
    if (!foldTypeSelect) return

    const selectedFoldType = foldTypeSelect.value
    const panelFields = document.querySelectorAll('.panel-fields')

    panelFields.forEach(field => {
      const allowedTypes = field.dataset.foldTypes || ''
      if (allowedTypes.includes(selectedFoldType)) {
        field.style.display = ''
      } else {
        field.style.display = 'none'
      }
    })
  }
}