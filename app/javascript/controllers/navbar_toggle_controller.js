import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["menu", "toggler"]

  connect() {
    this._beforeVisit = () => this.close()
    document.addEventListener("turbo:before-visit", this._beforeVisit)
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
  }
}
