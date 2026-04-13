import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["dropzone", "dragover", "progress", "progressBar"];
  static values = { url: String, goto: String };

  connect() {
    this.dropzoneTarget.addEventListener("click", () => this.selectFile());
    this.dropzoneTarget.addEventListener("dragover", (e) => this.dragOver(e));
    this.dropzoneTarget.addEventListener("dragleave", (e) => this.dragLeave(e));
    this.dropzoneTarget.addEventListener("drop", (e) => this.drop(e));
  }

  dragOver(event) {
    event.preventDefault();
    event.stopPropagation();
    this.dropzoneTarget.classList.add("dragover");
    this.dragoverTarget.classList.remove("hidden");
  }

  dragLeave(event) {
    event.preventDefault();
    event.stopPropagation();
    this.dropzoneTarget.classList.remove("dragover");
    this.dragoverTarget.classList.add("hidden");
  }

  drop(event) {
    event.preventDefault();
    event.stopPropagation();
    this.dropzoneTarget.classList.remove("dragover");
    this.dragoverTarget.classList.add("hidden");

    const files = event.dataTransfer.files;
    if (files.length > 0) {
      this.upload(files[0]);
    }
  }

  selectFile() {
    document.getElementById("file-input").click();
  }

  fileSelected(event) {
    const file = event.target.files[0];
    if (file) {
      this.upload(file);
    }
  }

  upload(file) {
    if (!this.validateFile(file)) return;

    const formData = new FormData();
    formData.append("file", file);

    this.progressTarget.classList.remove("hidden");
    this.dropzoneTarget.classList.add("hidden");

    this.animateProgress();

    fetch(this.urlValue, {
      method: "POST",
      body: formData,
      headers: {
        "X-CSRF-Token": this.getCSRFToken(),
      },
    })
      .then((response) => {
        if (response.redirected) {
          window.location.href = response.url;
        } else {
          window.location.href = this.gotoValue;
        }
      })
      .catch((error) => {
        console.error("Upload failed:", error);
        window.location.href = this.gotoValue;
      });
  }

  validateFile(file) {
    const maxSize = 5 * 1024 * 1024 * 1024; // 5GB
    const allowedExtensions = [".zip", ".tar.gz", ".tgz"];
    const ext = file.name.toLowerCase().slice(file.name.lastIndexOf("."));

    if (file.size > maxSize) {
      alert("Arquivo muito grande. O tamanho máximo é 5GB.");
      return false;
    }

    if (!allowedExtensions.includes(ext)) {
      alert("Formato não suportado. Use .zip, .tar.gz ou .tgz");
      return false;
    }

    return true;
  }

  animateProgress() {
    let progress = 0;
    const interval = setInterval(() => {
      progress += Math.random() * 15;
      if (progress > 90) {
        clearInterval(interval);
        this.progressBarTarget.style.width = "90%";
      } else {
        this.progressBarTarget.style.width = progress + "%";
      }
    }, 300);
  }

  getCSRFToken() {
    return document
      .querySelector('meta[name="csrf-token"]')
      .getAttribute("content");
  }
}
