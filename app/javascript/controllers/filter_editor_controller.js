import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["filterList", "previewContainer", "statusMessage", "applyBtn", "resetBtn"]

  static values = {
    filters: { type: Array, default: [] }
  }

  connect() {
    this.loadFilters()
  }

  async loadFilters() {
    const id = this.element.dataset.filterEditorLetterBackgroundIdValue
    try {
      this.setLoading(true)
      const response = await fetch(`/letter_backgrounds/${id}.json`)
      const data = await response.json()
      this.filtersValue = data.filters || []
      this.renderFilterList()
    } catch (e) {
      this.showError("Erro ao carregar filtros")
    } finally {
      this.setLoading(false)
    }
  }

  async addFilterDirect(type, params = {}) {
    const id = this.element.dataset.filterEditorLetterBackgroundIdValue
    try {
      this.setLoading(true)
      const response = await fetch(`/letter_backgrounds/${id}/add_filter`, {
        method: "POST",
        headers: { "Content-Type": "application/json", "X-CSRF-Token": this.csrfToken },
        body: JSON.stringify({ filter_type: type, filter_params: params })
      })

      if (response.ok) {
        this.showSuccess("Filtro adicionado")
        this.loadFilters()
        this.updatePreview()
      } else {
        this.showError("Erro ao adicionar filtro")
      }
    } catch (e) {
      this.showError("Erro ao adicionar filtro")
    }
  }

  addBlur() { this.addFilterDirect("blur", { sigma: 5 }) }
  addGrayscale() { this.addFilterDirect("grayscale", {}) }
  addContrast() { this.addFilterDirect("contrast", { contrast: 1.5 }) }
  addBlack() { this.addFilterDirect("black", {}) }

  async resetFilters() {
    if (!confirm("Limpar todos os filtros?")) return

    const id = this.element.dataset.filterEditorLetterBackgroundIdValue
    try {
      this.setLoading(true)
      const response = await fetch(`/letter_backgrounds/${id}/reset_filters`, {
        method: "POST",
        headers: { "X-CSRF-Token": this.csrfToken }
      })

      if (response.ok) {
        this.filtersValue = []
        this.renderFilterList()
        this.showSuccess("Filtros removidos")
        this.updatePreview()
      }
    } catch (e) {
      this.showError("Erro ao limpar filtros")
    }
  }

  applySelectedFilters() {
    this.updatePreview()
    this.showSuccess("Preview atualizado")
  }

  updatePreview() {
    const id = this.element.dataset.filterEditorLetterBackgroundIdValue
    const preview = document.querySelector("#background_preview")
    if (preview) {
      const timestamp = new Date().getTime()
      const newSrc = `/letter_backgrounds/${id}/preview?t=${timestamp}`
      console.log("Updating preview to:", newSrc)
      preview.src = newSrc
    }
  }

  renderFilterList() {
    const listEl = this.filterListTarget
    if (!listEl) return

    if (this.filtersValue.length === 0) {
      listEl.innerHTML = '<div class="filter-list-header">Nenhum filtro aplicado</div>'
      return
    }

    const filterLabels = {
      blur: "💧 Blur",
      grayscale: "⬛ P&B",
      sepia: "🟤 Sépia",
      contrast: "◐ Contraste",
      black: "⬛ Preto",
      brightness: "☀ Brilho",
      vintage: "📷 Vintage",
      negate: "🔄 Inverter"
    }

    let html = '<div class="filter-list-header">Filtros selecionados:</div>'
    for (let i = 0; i < this.filtersValue.length; i++) {
      const f = this.filtersValue[i]
      const label = filterLabels[f.type] || f.type
      html += `
        <div class="filter-item">
          <span class="filter-item-name">${label}</span>
          <button type="button" class="btn btn-sm" data-action="filter-editor#removeFilter" data-index="${i}">×</button>
        </div>
      `
    }
    listEl.innerHTML = html
  }

  async removeFilter(event) {
    const index = parseInt(event.target.dataset.index)
    if (isNaN(index)) return

    const id = this.element.dataset.filterEditorLetterBackgroundIdValue
    const filterId = this.filtersValue[index]?.id
    if (!filterId) return

    try {
      this.setLoading(true)
      const response = await fetch(`/letter_backgrounds/${id}/remove_filter?filter_id=${filterId}`, {
        method: "DELETE",
        headers: { "X-CSRF-Token": this.csrfToken }
      })

      if (response.ok) {
        this.showSuccess("Filtro removido")
        this.loadFilters()
        this.updatePreview()
      }
    } catch (e) {
      this.showError("Erro ao remover filtro")
    }
  }

  setLoading(loading) {
    if (loading) {
      this.element.classList.add("loading")
      if (this.applyBtnTarget) this.applyBtnTarget.disabled = true
      if (this.resetBtnTarget) this.resetBtnTarget.disabled = true
    } else {
      this.element.classList.remove("loading")
      if (this.applyBtnTarget) this.applyBtnTarget.disabled = false
      if (this.resetBtnTarget) this.resetBtnTarget.disabled = false
    }
  }

  showSuccess(message) {
    if (this.statusMessageTarget) {
      this.statusMessageTarget.textContent = message
      this.statusMessageTarget.className = "filter-status-message success"
    }
  }

  showError(message) {
    if (this.statusMessageTarget) {
      this.statusMessageTarget.textContent = message
      this.statusMessageTarget.className = "filter-status-message error"
    }
  }

  get csrfToken() {
    return document.querySelector("meta[name='csrf-token']")?.content || ""
  }
}