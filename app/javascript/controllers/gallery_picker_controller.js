import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["select", "grid", "preview"]

  connect() {
    console.log('GalleryPicker connected')
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
      const response = await fetch(`/galleries/${galleryId}/photos.json`)
      const data = await response.json()
      this.renderPhotos(data.photos)
    } catch (error) {
      console.error('Error:', error)
      this.gridTarget.innerHTML = '<p class="error">Erro: ' + error.message + '</p>'
    }
  }

  renderPhotos(photos) {
    if (!photos || photos.length === 0) {
      this.gridTarget.innerHTML = '<p class="help">Nenhuma foto nesta galeria</p>'
      return
    }

    const currentPhotoId = document.getElementById('selected_photo_id')?.value
    const self = this
    
    let html = '<div class="photo-grid">'
    for (const photo of photos) {
      const isSelected = photo.id == currentPhotoId
      html += `<div class="photo-item${isSelected ? ' selected' : ''}" data-photo-id="${photo.id}" data-url-large="${photo.url_large}">
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
    
    const hiddenField = document.getElementById('selected_photo_id')
    if (hiddenField) hiddenField.value = photoId
    
    const debugInfo = document.getElementById('debug-info')
    if (debugInfo) debugInfo.textContent = `Selected: ${photoId}`
    
    this.showPreview(urlLarge)
  }

  showPreview(urlLarge) {
    const previewContainer = document.getElementById('photo_preview_container')
    
    if (previewContainer && urlLarge) {
      previewContainer.innerHTML = '<img src="' + urlLarge + '" alt="Preview" class="preview-image" style="max-width: 300px;" />'
    } else if (previewContainer) {
      previewContainer.innerHTML = '<p class="help">No URL</p>'
    }
  }
}