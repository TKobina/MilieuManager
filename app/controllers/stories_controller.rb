class StoriesController < ApplicationController
  def index
    @stories = filter_records(@milieu.stories).sort
  end

  def show
    @story = @milieu.stories.find(params[:id])

    if (!@private && !@story.public)
      redirect_to stories_path(current_milieu: @milieu), alert: "Not authorized or record not found."
    end
  end

  def new
    @story = Story.new
  end

  def create
    @story = Story.new(story_params)
    @story.public = false
    @story.milieu = @milieu
    if @story.save
      redirect_to story_path(@story, current_milieu: @milieu)
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @story = @milieu.stories.find(params[:id])
  end

  def update
    @story = @milieu.stories.find(params[:id])
    if @story.update(story_params)
      redirect_to story_path(@story, current_milieu: @milieu)
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @story = @milieu.stories.find(params[:id])
    if (!@private && !@story.public)
      redirect_to stories_path(current_milieu: @milieu), alert: "Not authorized or record not found."
    end
    @story.destroy
    redirect_to stories_path(current_milieu: @milieu)
  end


  private
    def story_params
      params.expect(story: [ :chapter, :title, :details, :public ])
    end

end
