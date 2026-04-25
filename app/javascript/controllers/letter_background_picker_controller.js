import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["grid", "hidden", "preview"]

  connect() {
    this.loadBackgrounds()
  }

  async loadBackgrounds() {
    try {
      const url = this.element.dataset.letterBackgroundPickerUrl || "/letter_backgrounds.json"
      const response = await fetch(url)
      const data = await response.json()
      this.renderBackgrounds(Array.isArray(data) ? data : data.letter_backgrounds)
    } catch (error) {
      this.gridTarget.innerHTML = '<p class="error">Erro ao carregar fundos</p>'
    }
  }

  renderBackgrounds(backgrounds) {
    if (!backgrounds || backgrounds.length === 0) {
      this.gridTarget.innerHTML = '<p class="help">Nenhum fondo disponível</p>'
      return
    }

    const self = this
    const hiddenFieldId = this.element.dataset.letterBackgroundPickerHiddenFieldId || 'greeting_card_letter_background_id'
    const selectedId = this.element.dataset.letterBackgroundPickerSelectedId || document.getElementById(hiddenFieldId)?.value

    let html = '<div class="letter-background-picker-grid">'
    
    // No background option
    const isNoneSelected = selectedId === '' || selectedId === null || selectedId === undefined
    html += `<div class="letter-background-picker-item${isNoneSelected ? ' selected' : ''}" 
                 data-id="">
      <div class="no-bg-label">Sem fundo</div>
    </div>`
    
    for (const bg of backgrounds) {
      const isSelected = bg.id == selectedId
      html += `<div class="letter-background-picker-item${isSelected ? ' selected' : ''}" 
                   data-id="${bg.id}" 
                   data-preview-url="${bg.preview_url}">
        <img src="${bg.image_url}" alt="${bg.name}" loading="lazy" />
      </div>`
    }
    html += '</div>'
    this.gridTarget.innerHTML = html

    this.gridTarget.querySelectorAll('.letter-background-picker-item').forEach(function(item) {
      item.addEventListener('click', function() {
        self.selectBackground(item, item.dataset.id, item.dataset.previewUrl)
      })
    })

    // Show initial preview if selected
    if (selectedId) {
      const selectedItem = this.gridTarget.querySelector('.letter-background-picker-item.selected')
      if (selectedItem && selectedItem.dataset.previewUrl) {
        this.showPreview(selectedItem.dataset.previewUrl)
      }
    }
  }

  selectBackground(element, id, previewUrl) {
    this.gridTarget.querySelectorAll('.letter-background-picker-item').forEach(item => {
      item.classList.remove('selected')
    })
    element.classList.add('selected')
    
    const hiddenFieldId = this.element.dataset.letterBackgroundPickerHiddenFieldId || 'greeting_card_letter_background_id'
    const hiddenField = document.getElementById(hiddenFieldId)
    if (hiddenField) hiddenField.value = id
    
    this.showPreview(previewUrl)
    
    this.dispatch('background:selected', { detail: { id, previewUrl } })
  }

  showPreview(previewUrl) {
    if (!previewUrl || previewUrl === 'undefined') {
      this.previewTarget.innerHTML = ''
      return
    }
    this.previewTarget.innerHTML = `<img src="${previewUrl}" alt="Preview" />`
  }
}