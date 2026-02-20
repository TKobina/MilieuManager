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
    @event = Event.new(:text => {:pri => "", :pub => ""})
    @event.ydate = Ydate.random(@milieu)
    @eidnext = @milieu.entities.max_by{|ent| ent.eid.to_i}&.eid.to_s.to_i + 1
  end

  def create
    @event = Event.new(EventParamsService.call(@milieu, event_params))  
    if @event.save
      MilieuChronoprocJob.perform_now @milieu
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
    if @event.update(EventParamsService.call(@milieu, event_params))
      MilieuChronoprocJob.perform_now @milieu
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
    params.expect(:ydate, :name, :code, details: [:textpri, :textpub, :instructions])
  end
end
