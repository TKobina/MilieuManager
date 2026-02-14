// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"
import RailsNestedForm from '@stimulus-components/rails-nested-form'

application.register('nested-form', RailsNestedForm)