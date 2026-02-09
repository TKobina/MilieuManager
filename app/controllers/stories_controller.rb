class StoriesController < ApplicationController
  def index
    @stories = current_user.milieus.first.stories
  end

  def show
    @story = current_user.milieus.first.stories.find(params[:id])
  end

  def new
    @story = Story.new
  end

  def create
    @story = Story.new(story_params)
    @story.public = false
    @story.milieu = current_user.milieus.first
    if @story.save
      redirect_to @story
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @story = current_user.milieus.first.stories.find(params[:id])
  end

  def update
    @story = current_user.milieus.first.stories.find(params[:id])
    if @story.update(story_params)
      redirect_to @story
    else
      render :edit, status: :unprocessable_entity
    end
  end


  private
    def story_params
      params.expect(story: [ :chapter, :title, :details ])
    end

end
