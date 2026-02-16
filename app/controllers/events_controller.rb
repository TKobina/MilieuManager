class EventsController < ApplicationController
    before_action :check_owner, only: [:create, :edit, :update, :destroy]

  def index
    @dates = {}
    @milieu.ydates.sort.each {|date| @dates[date.value] = filter_records(date.events) }
  end

  def show
    @event = @milieu.events.find(params[:id])
    if (!@private && !@event.public)
      redirect_to events_path(current_milieu: @milieu), alert: "Not authorized or record not found."
    end
  end

  def new
    @event = Event.new
    @event.text = {pri: "", pub: ""}
    @event.ydate = Ydate.random(@milieu)

    @eidnext = @milieu.entities.max_by{|ent| ent.eid.to_i}.eid.to_i + 1
  end

  def create
    @event = Event.new(event_params)
    @event.public = false
    @event.milieu = @milieu
    @event.text[:pri] = params[:textpri]
    @event.text[:pub] = params[:textpub]
    @event.code = (params[:code] + "\n" + params[:instructions]).split("\n")
    @event.ydate = Ydate.from_string(@milieu, params[:ydate])
    
    if @event.save
      @event.update_event
      redirect_to event_path(@event, current_milieu: @milieu)
    else
      redirect_to new_event_path(current_milieu: @milieu), alert: "Event creation failed!"
    end
  end

  def edit

    @event = @milieu.events.find(params[:id])
    @eidnext = @milieu.entities.max_by{|ent| ent.eid.to_i}.eid.to_i + 1
  end

  def update
    @event = @milieu.events.find(params[:id])
    @event.text["pri"] = params[:textpri]
    @event.text["pub"] = params[:textpub]
    @event.code = (params[:code] + "\n" + params[:instructions]).split("\n")
    @event.ydate = Ydate.from_string(@milieu, params[:ydate])

    if @event.update(event_params)
      @event.update_event
      redirect_to event_path(@event, current_milieu: @milieu)
    else
      redirect_to new_event_path(current_milieu: @milieu), alert: "Entity edit failed!"
    end
  end

  def destroy
    @event = @milieu.events.find(params[:id])
    @event.destroy
    @milieu.proc_chronology
    redirect_to events_path
  end

  def proc
    @milieu.proc_chronology
    redirect_to events_path(current_milieu: @milieu)
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
    params.expect(event: [ :ydate_id, :kind, :name, :code, :inststring, :text, :public,
      instructions_attributes: [:id, :event_id, :i, :kind, :code, :description, :_destroy] ])
  end
end
