// app/javascript/controllers/tooltip_controller.js
import { Controller } from "@hotwired/stimulus";
import { computePosition, offset, flip, shift, arrow, autoUpdate } from "@floating-ui/dom";

export default class extends Controller {
  static values = { content: String, placement: { type: String, default: "top" } };
  static targets = ["tooltip"];

  connect() {
    this.element.addEventListener("mouseenter", this.show.bind(this));
    this.element.addEventListener("mouseleave", this.hide.bind(this));
    this.element.addEventListener("focusin", this.show.bind(this));
    this.element.addEventListener("focusout", this.hide.bind(this));
    this.tooltip = document.createElement("div");
    this.tooltip.innerHTML = this.contentValue;
    this.tooltip.setAttribute("role", "tooltip");
    this.tooltip.classList.add("rails-tooltip"); // Add a CSS class for styling
    this.tooltip.setAttribute("hidden", true);
    document.body.appendChild(this.tooltip);
  }

  disconnect() {
    if (this.tooltip) {
      this.tooltip.remove();
    }
  }

  show() {
    this.tooltip.removeAttribute("hidden");
    computePosition(this.element, this.tooltip, {
      placement: this.placementValue,
      middleware: [offset(8), flip(), shift({ padding: 5 })],
    }).then(({ x, y }) => {
      Object.assign(this.tooltip.style, {
        left: `${x}px`,
        top: `${y}px`,
      });
    });
  }

  hide() {
    this.tooltip.setAttribute("hidden", true);
  }
}
