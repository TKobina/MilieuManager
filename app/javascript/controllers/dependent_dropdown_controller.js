import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="dependent-dropdown"
export default class extends Controller {
  static targets = ["sublexeme"]
  static values = {
    provincesUrl: String,
    citiesUrl: String,
    selectedProvinceId: Number,
    selectedCityId: Number
  }

  connect() {
    // Initialize province dropdown if country is already selected
    if (this.countryTarget.value) {
      this.loadProvinces()
    }

    // Initialize city dropdown if province is already selected
    if (this.provinceTarget.value && this.hasSelectedProvinceIdValue) {
      this.loadCities()
    }
  }

  countryChanged() {
    this.clearProvince()
    this.clearCity()

    if (this.countryTarget.value) {
      this.loadProvinces()
    }
  }

  provinceChanged() {
    this.clearCity()

    if (this.provinceTarget.value) {
      this.loadCities()
    }
  }

  async loadProvinces() {
    const countryId = this.countryTarget.value
    if (!countryId) return

    try {
      const url = this.provincesUrlValue.replace(':country_id', countryId)
      const response = await fetch(url)
      const provinces = await response.json()

      this.populateSelect(this.provinceTarget, provinces, "Select Province...")
      this.provinceTarget.disabled = false

      // Auto-select if we have a selected province ID
      if (this.hasSelectedProvinceIdValue) {
        this.provinceTarget.value = this.selectedProvinceIdValue
        this.loadCities()
      }
    } catch (error) {
      console.error('Error loading provinces:', error)
    }
  }

  async loadCities() {
    const provinceId = this.provinceTarget.value
    if (!provinceId) return

    try {
      const url = this.citiesUrlValue.replace(':province_id', provinceId)
      const response = await fetch(url)
      const cities = await response.json()

      this.populateSelect(this.cityTarget, cities, "Select City...")
      this.cityTarget.disabled = false

      // Auto-select if we have a selected city ID
      if (this.hasSelectedCityIdValue) {
        this.cityTarget.value = this.selectedCityIdValue
      }
    } catch (error) {
      console.error('Error loading cities:', error)
    }
  }

  populateSelect(selectElement, options, placeholder) {
    // Clear existing options except the first placeholder
    selectElement.innerHTML = `<option value="">${placeholder}</option>`

    // Add new options
    options.forEach(option => {
      const optionElement = document.createElement('option')
      optionElement.value = option.id
      optionElement.textContent = option.name
      selectElement.appendChild(optionElement)
    })
  }

  clearProvince() {
    this.provinceTarget.innerHTML = '<option value="">Select Province...</option>'
    this.provinceTarget.disabled = true
  }

  clearCity() {
    this.cityTarget.innerHTML = '<option value="">Select City...</option>'
    this.cityTarget.disabled = true
  }
}