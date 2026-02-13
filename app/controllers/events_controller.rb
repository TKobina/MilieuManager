class EventsController < ApplicationController
    before_action :check_owner, only: [:create, :edit, :update, :destroy]

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

  def new
    @event = Event.new
    @event.text = {"pri"=>"", "pub"=>""}
    @event.ydate = Ydate.from_days(@milieu, 0)
    @event.code = []
  end

  def create
    @event = Event.new(event_params)
    @event.public = false
    @event.milieu = @milieu
    @event.text["pri"] = params[:textpri]
    @event.text["pub"] = params[:textpub]
    @event.code = params[:textcode].split("\n")

    if @event.save
      redirect_to event_path(@event, current_milieu: @milieu)
    else
      redirect_to new_event_path(current_milieu: @milieu), alert: "Event creation failed!"
    end
  end


  def edit
    @event = @milieu.events.find(params[:id])
  end

  def update
    @event = @milieu.events.find(params[:id])
    @event.text["pri"] = params[:textpri]
    @event.text["pub"] = params[:textpub]
    @event.code = params[:textcode].split("\n")
    if @event.update(event_params)
      redirect_to event_path(@event, current_milieu: @milieu)
    else
      redirect_to new_event_path(current_milieu: @milieu), alert: "Entity edit failed!"
    end
  end

  def destroy
    @event = @milieu.events.find(params[:id])
    @event.destroy
    redirect_to events_path
  end

  private

  def check_public
    if (!@private && !@event.public)
      redirect_to events_path(current_milieu: @milieu), alert: "Not authorized or record not found."
    end
  end

  def check_owner
    unless @owner
      redirect_to events_path(current_milieu: @milieu), alert: "Not authorized or record not found."
    end
  end

  def event_params
    params.expect(event: [ :ydate_id, :kind, :name, :code, :text, :public ])
  end
end
