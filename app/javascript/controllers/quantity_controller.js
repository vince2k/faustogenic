// app/javascript/controllers/quantity_controller.js
// import { Controller } from "@hotwired/stimulus"

// export default class extends Controller {
//   static values = { dishIngredientId: Number }

//   update(event) {
//   const quantity = event.target.value
//   console.log("Updating quantity to", quantity)

//   fetch(`/dish_ingredients/${this.dishIngredientIdValue}`, {
//     method: "PATCH",
//     headers: {
//       "Content-Type": "application/json",
//       "Accept": "text/vnd.turbo-stream.html",
//       "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]').content
//     },
//     body: JSON.stringify({ dish_ingredient: { quantity: quantity } })
//   })
// }

// }

// app/javascript/controllers/quantity_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = { dishIngredientId: Number }

  async update(event) {
    const quantity = event.target.value
    console.log("Updating quantity for dish_ingredient_id:", this.dishIngredientIdValue, "to", quantity)

    try {
      const response = await fetch(`/dish_ingredients/${this.dishIngredientIdValue}`, {
        method: "PATCH",
        headers: {
          "Content-Type": "application/json",
          "Accept": "text/vnd.turbo-stream.html",
          "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]').content
        },
        body: JSON.stringify({ dish_ingredient: { quantity: quantity } })
      })

      console.log("Response status:", response.status, "Content-Type:", response.headers.get("Content-Type"))
      if (!response.ok) {
        throw new Error(`HTTP error! status: ${response.status}`)
      }

      const html = await response.text()
      console.log("Réponse Turbo Stream reçue:", html)

      // Injecter manuellement les turbo-streams
      const tempDiv = document.createElement("div")
      tempDiv.innerHTML = html
      const streams = tempDiv.querySelectorAll("turbo-stream")
      streams.forEach(stream => {
        const action = stream.getAttribute("action")
        const target = stream.getAttribute("target")
        const template = stream.querySelector("template").innerHTML
        const targetElement = document.getElementById(target)

        if (targetElement) {
          if (action === "replace") {
            targetElement.outerHTML = template
          } else {
            console.warn(`Action Turbo Stream non gérée: ${action}`)
          }
        } else {
          console.error(`Cible Turbo Stream introuvable: ${target}`)
        }
      })
    } catch (error) {
      console.error("Erreur AJAX:", error)
    }
  }
}
