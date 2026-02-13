class EntitiesController < ApplicationController
  def index
    @entities = filter_records(@milieu.entities).where.not(kind: "world").sort
  end

  def show
    @entity = @milieu.entities.find(params[:id])

    if (!@private && !@entity.public)
      redirect_to entities_path(current_milieu: @milieu), alert: "Not authorized or record not found."
    end

    @superiors, @superior_relations = filter_joint_records(@entity.superiors, @entity.superior_relations)
    @inferiors, @inferior_relations = filter_joint_records(@entity.inferiors, @entity.inferior_relations)
    @events = filter_records(@entity.events)

    @text_public = @entity.text["pub"]
    @text_private = @private ? @entity.text["pri"] : ""

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
