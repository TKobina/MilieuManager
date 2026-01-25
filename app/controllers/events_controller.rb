class EventsController < ApplicationController
  def index
    @events = current_user.events
  end

  def show
    @event = current_user.events.find(params[:id])
  end
end
