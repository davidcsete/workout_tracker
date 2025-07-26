# Pin npm packages by running ./bin/importmap

pin "application"
pin "@hotwired/turbo-rails", to: "turbo.min.js"
pin "@hotwired/stimulus", to: "stimulus.min.js"
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js"
pin_all_from "app/javascript/controllers", under: "controllers"
pin "page_transitions", to: "page_transitions.js"
pin "theme_handler", to: "theme_handler.js"

pin "@rails/ujs", to: "rails-ujs.js"
pin "steps_controller", to: "controllers/steps_controller.js"



pin "chart.js/auto", to: "https://ga.jspm.io/npm:chart.js@4.4.1/dist/chart.js" # or latest
pin "@kurkle/color", to: "@kurkle--color.js" # @0.3.4
