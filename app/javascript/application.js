// app/javascript/application.js
// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"
import "@popperjs/core"
import "bootstrap"

document.addEventListener("DOMContentLoaded", () => {
  if (typeof Turbo !== "undefined") {
    console.log("Turbo chargé, enabled:", Turbo.session.enabled);
  } else {
    console.error("Turbo non défini");
  }
});

document.addEventListener("turbo:load", () => {
  console.log("Événement turbo:load déclenché");
});

document.addEventListener("turbo:before-stream-render", (event) => {
  console.log("Turbo stream rendering:", event.target.action, event.target.target);
});

document.addEventListener("turbo:stream-render", (event) => {
  console.log("Turbo stream rendu:", event.detail);
});
