class EventsController < ApplicationController
  def index
    set_privacy
    @events = filter_events(@milieu.events)
  end

  def show
    set_privacy
    @event = @milieu.events.find(params[:id])
    if (!@private && !@event.public)
      redirect_to events_path(current_milieu: @milieu), alert: "Not authorized or record not found."
    end

    @text_public = @event.text["pub"]
    @text_private = @private ? @event.text["pri"] : ""
  end

  private

  def set_privacy
    @private = true if @milieu.owner == current_user
    @private = @private ? true : @milieu.accesses.where(reader: current_user).first.private_rights
  end

  def filter_events(events)
    @private ? events : @milieu.events.where(public: true)
  end
end
