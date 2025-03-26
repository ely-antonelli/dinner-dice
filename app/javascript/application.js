// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"
import "@popperjs/core"
import "bootstrap"

document.addEventListener("DOMContentLoaded", function () {
  const rollButton = document.getElementById("roll-button");

  if (rollButton) {
    rollButton.addEventListener("click", function (event) {
      event.preventDefault(); // Empêche le rechargement de la page

      fetch("/recipes/random", {
        method: "GET",
        headers: {
          "X-Requested-With": "XMLHttpRequest", // Important pour Rails
          "Accept": "text/javascript", // Demande une réponse en JS
        },
      })
      .then(response => response.text()) // Convertir en texte
      .then(jsCode => eval(jsCode)) // Exécuter le JS renvoyé par Rails
      .catch(error => console.error("Erreur AJAX:", error));
    });
  }
});
