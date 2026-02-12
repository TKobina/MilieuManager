class EventsController < ApplicationController
  def index
    @events = filter_records(@milieu.events)
  end

  def show
    @event = @milieu.events.find(params[:id])
    if (!@private && !@event.public)
      redirect_to events_path(current_milieu: @milieu), alert: "Not authorized or record not found."
    end

    @text_public = @event.text["pub"]
    @text_private = @private ? @event.text["pri"] : ""
  end

  private
end
