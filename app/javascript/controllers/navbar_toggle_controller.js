import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["menu", "toggler", "label"]

  connect() {
    this._beforeVisit = () => this.close()
    document.addEventListener("turbo:before-visit", this._beforeVisit)
    this._syncAria()
  }

  disconnect() {
    document.removeEventListener("turbo:before-visit", this._beforeVisit)
  }

  toggle() {
    this.menuTarget.classList.toggle("show")
    this._syncAria()
  }

  close() {
    this.menuTarget.classList.remove("show")
    this._syncAria()
  }

  _syncAria() {
    if (!this.hasTogglerTarget) return
    const open = this.menuTarget.classList.contains("show")
    this.togglerTarget.setAttribute("aria-expanded", open ? "true" : "false")
    this.togglerTarget.setAttribute("aria-label", open ? "メニューを閉じる" : "メニューを開く")

    if (this.hasLabelTarget) {
      this.labelTarget.textContent = open ? "閉じる" : "メニュー"
    }
  }
}
