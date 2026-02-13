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

  def new
    #@story = Story.new
  end

  def create
    #@story = Story.new(story_params)
    #@story.public = false
    #@story.milieu = @milieu
    #if @story.save
    #  redirect_to @story
    #else
    #  render :new, status: :unprocessable_entity
    #end
  end

  def edit
    #@story = @milieu.stories.find(params[:id])
  end

  def update
    #@story = @milieu.stories.find(params[:id])
    #if @story.update(story_params)
    #  redirect_to @story
    #else
    #  render :edit, status: :unprocessable_entity
    #end
  end

  def destroy
    #@story = @milieu.stories.find(params[:id])
    #@story.destroy
    #redirect_to stories_path
  end


  private
    #def story_params
    #  params.expect(story: [ :chapter, :title, :details ])
    #end
end
