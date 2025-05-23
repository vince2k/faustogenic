// import { Controller } from "@hotwired/stimulus"

// export default class extends Controller {
//   static targets = ["input", "hidden", "list"]

//   connect() {
//     console.log("IngredientAutocompleteController connected");

//     this.url = this.inputTarget.dataset.autocompleteUrl
//   }

//   search() {
//     const query = this.inputTarget.value
//     console.log("Requête :", query) // 👈 pour vérifier
//     if (query.length < 2) {
//       this.listTarget.innerHTML = ""
//       return
//     }


//     fetch(`${this.url}?q=${encodeURIComponent(query)}`)
//       .then(response => response.json())
//       .then(data => {
//         this.listTarget.innerHTML = ""
//         data.forEach(item => {
//           const option = document.createElement("li")
//           option.textContent = item.name
//           option.dataset.id = item.id
//           option.addEventListener("click", () => this.select(item))
//           this.listTarget.appendChild(option)
//         })
//       })
//   }

//   select(item) {
//     this.inputTarget.value = item.name
//     this.hiddenTarget.value = item.id
//     this.listTarget.innerHTML = ""
//   }
// }
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input", "hidden", "list"]

  connect() {
    this.index = -1 // Pour la navigation clavier
    this.url = this.inputTarget.dataset.autocompleteUrl
  }

  search() {
    const query = this.inputTarget.value.trim()

    if (query.length < 2) {
      this.listTarget.innerHTML = ""
      return
    }

    fetch(`${this.url}?q=${encodeURIComponent(query)}`)
      .then((res) => res.json())
      .then((data) => {
        this.listTarget.innerHTML = ""
        data.forEach((item, idx) => {
          const li = document.createElement("li")
          li.textContent = item.name
          li.dataset.id = item.id
          li.dataset.index = idx
          li.classList.add("cursor-pointer", "px-2", "py-1", "hover:bg-blue-100")

          li.addEventListener("click", () => this.select(item))
          this.listTarget.appendChild(li)
        })
        this.index = -1
      })
  }

  keydown(event) {
    const items = this.listTarget.querySelectorAll("li")

    if (event.key === "ArrowDown") {
      event.preventDefault()
      this.index = Math.min(this.index + 1, items.length - 1)
      this.highlight(items)
    }

    if (event.key === "ArrowUp") {
      event.preventDefault()
      this.index = Math.max(this.index - 1, 0)
      this.highlight(items)
    }

    if (event.key === "Enter") {
      event.preventDefault()
      if (this.index >= 0 && items[this.index]) {
        const li = items[this.index]
        this.select({ id: li.dataset.id, name: li.textContent })
      }
    }
  }

  highlight(items) {
    items.forEach((el, idx) => {
      el.classList.toggle("bg-blue-200", idx == this.index)
    })
  }

  select(item) {
    this.inputTarget.value = item.name
    this.hiddenTarget.value = item.id
    this.listTarget.innerHTML = ""
  }

  reset() {
    this.inputTarget.value = ""
    this.hiddenTarget.value = ""
    this.listTarget.innerHTML = ""
    this.index = -1
  }
}
