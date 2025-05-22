import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input", "hidden", "list"]

  connect() {
    console.log("IngredientAutocompleteController connected");

    this.url = this.inputTarget.dataset.autocompleteUrl
  }

  search() {
    const query = this.inputTarget.value
    console.log("Requête :", query) // 👈 pour vérifier
    if (query.length < 2) {
      this.listTarget.innerHTML = ""
      return
    }


    fetch(`${this.url}?q=${encodeURIComponent(query)}`)
      .then(response => response.json())
      .then(data => {
        this.listTarget.innerHTML = ""
        data.forEach(item => {
          const option = document.createElement("li")
          option.textContent = item.name
          option.dataset.id = item.id
          option.addEventListener("click", () => this.select(item))
          this.listTarget.appendChild(option)
        })
      })
  }

  select(item) {
    this.inputTarget.value = item.name
    this.hiddenTarget.value = item.id
    this.listTarget.innerHTML = ""
  }
}
