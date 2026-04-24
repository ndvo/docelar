import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["select", "grid"]

  connect() {
    this.loadPhotos()
  }

  async loadPhotos(event) {
    let galleryId
    if (event && event.target) {
      galleryId = event.target.value
    } else if (event && typeof event === 'string') {
      galleryId = event
    } else {
      galleryId = this.selectTarget?.value
    }
    
    if (!galleryId) {
      this.gridTarget.innerHTML = '<p class="help">Selecione uma galeria primeiro</p>'
      return
    }

    try {
      const url = this.element.dataset.galleryPickerPhotosUrl || `/galleries/${galleryId}/photos.json`
      const response = await fetch(url)
      const data = await response.json()
      this.renderPhotos(data.photos)
    } catch (error) {
      this.gridTarget.innerHTML = '<p class="error">Erro ao carregar fotos</p>'
    }
  }

  renderPhotos(photos) {
    if (!photos || photos.length === 0) {
      this.gridTarget.innerHTML = '<p class="help">Nenhuma foto nesta galeria</p>'
      return
    }

    const self = this
    const hiddenFieldId = this.element.dataset.galleryPickerHiddenFieldId || 'selected_photo_id'
    const selectedId = this.element.dataset.galleryPickerSelectedId || document.getElementById(hiddenFieldId)?.value
    
    let html = '<div class="photo-grid">'
    for (const photo of photos) {
      const isSelected = photo.id == selectedId
      html += `<div class="photo-item${isSelected ? ' selected' : ''}" 
                   data-photo-id="${photo.id}" 
                   data-url-large="${photo.url_large || photo.url_thumb}">
        <img src="${photo.url_thumb}" alt="" loading="lazy" />
      </div>`
    }
    html += '</div>'
    this.gridTarget.innerHTML = html

    this.gridTarget.querySelectorAll('.photo-item').forEach(function(item) {
      item.addEventListener('click', function() {
        self.selectPhoto(item, item.dataset.photoId, item.dataset.urlLarge)
      })
    })
  }

  selectPhoto(element, photoId, urlLarge) {
    this.gridTarget.querySelectorAll('.photo-item').forEach(item => {
      item.classList.remove('selected')
    })
    element.classList.add('selected')
    
    const hiddenFieldId = this.element.dataset.galleryPickerHiddenFieldId || 'selected_photo_id'
    const hiddenField = document.getElementById(hiddenFieldId)
    if (hiddenField) hiddenField.value = photoId
    
    const containerId = this.element.dataset.galleryPickerPreviewContainerId || 'photo_preview_container'
    const container = document.getElementById(containerId)
    if (container) {
      container.innerHTML = '<img src="' + urlLarge + '" alt="Preview" style="max-width: 250px;" />'
    } else {
      alert('Container not found: ' + containerId)
    }
    
    this.dispatch('photo:selected', { detail: { photoId, urlLarge } })
  }

  showPreview(urlLarge) {
  }
}