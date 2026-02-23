class EventsController < ApplicationController
    before_action :check_owner, only: [:create, :edit, :update, :destroy]

  def index
    @dates = {}
    @milieu.ydates.each {|date| @dates[date.value] = filter_records(date.events) }
  end

  def show
    @event = @milieu.events.find(params[:id])
    
    if (!@private && !@event.public)
      redirect_to events_path(current_milieu: @milieu), alert: "Not authorized or record not found."
    end

    @instructions = ""    
    @event.instructions.each do |instruction|
      instruction.code.split("|").each do |part|
        if part.include?("-")
          name, eid = part.split("-")
          entity = @milieu.entities.where(eid: eid).first
          @instructions += entity.present? ? view_context.link_to(name, entity_path(entity.id, current_milieu: @milieu)) : part
        else
          @instructions << part
        end
        @instructions << " | "
      end
      @instructions << "\n"
    end
  end

  def new
    @event = Event.new(:text => {:pri => "", :pub => ""})
    @event.ydate = Ydate.random(@milieu)
    @eidnext = @milieu.entities.max_by{|ent| ent.eid.to_i}&.eid.to_s.to_i + 1
  end

  def create
    @event = Event.new(get_params)  
    if @event.save
      MilieuChronoprocJob.perform_now @milieu
      redirect_to event_path(@event, current_milieu: @milieu)
    else
      redirect_to new_event_path(current_milieu: @milieu), alert: "Event creation failed!"
    end
  end

  def edit
    @event = @milieu.events.find(params[:id])
    @eidnext = @milieu.entities.max_by{|ent| ent.eid.to_i}&.eid.to_s.to_i + 1
  end

  def update
    @event = @milieu.events.find(params[:id])
    if @event.update(get_params)
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

  def get_params
    eparams = {text: {pri: "", pub: ""}}
    eparams[:milieu] = @milieu
    datestring, eparams[:name], eparams[:code], details = event_params
    eparams[:ydate] = Ydate.from_string(@milieu, datestring)
    eparams[:text][:pri], eparams[:text][:pub], instructions = details.values
    
    eparams[:code] = "#{eparams[:code]}\n#{instructions.to_s}".split("\n").map{|x| x.strip}
    cproc, ckind, cpublic = eparams[:code]&.first&.split("|")
    eparams[:proc] = cproc == "proc"
    eparams[:kind] = ckind
    eparams[:public] = cpublic == "public"

    eparams
  end

  def event_params
    params.expect(:ydate, :name, :code, details: [:textpri, :textpub, :instructions])
  end
end
