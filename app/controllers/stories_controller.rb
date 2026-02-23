class StoriesController < ApplicationController
  before_action :check_owner, only: [:new, :create, :edit, :update, :destroy]
  def index
    @stories = filter_records(@milieu.stories).sort
  end

  def show
    @story = @milieu.stories.find(params[:id])
    check_public
    @text = @story.details
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
      redirect_to new_story_path(current_milieu: @milieu, language_id: @language.id), alert: "Story creation failed!"
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
      redirect_to edit_story_path(current_milieu: @milieu, language_id: @language.id), alert: "Story editing failed!"
    end
  end

  def destroy
    @story = @milieu.stories.find(params[:id])
    @story.destroy
    redirect_to stories_path(current_milieu: @milieu)
  end


  private
  def story_params
    params.expect(story: [ :chapter, :title, :details, :public ])
  end

  def check_public
    if (!@private && !@story.public)
      redirect_to stories_path(current_milieu: @milieu), alert: "Not authorized or record not found."
    end
  end

  def check_owner
    unless @owner
      redirect_to stories_path(current_milieu: @milieu, language_id: @language.id), alert: "Not authorized or record not found."
    end
  end

  def replace_tags(text)
    temp = text.gsub!(/\[\[(.*?)\]\]/) { |match| build_link($1) }
    temp.nil? ? text : temp
  end

  def build_link(tag)
    arr = tag.split("|")
    iden = arr[0].split("-")
    eid = iden[1]
    name = arr[1] || iden[0]
    
    entity = Entity.where(eid: eid)&.first
    return name unless entity.present?

    "[#{name}](#{request.base_url + entity_path(entity.id, current_milieu: @milieu)})"
  end
end
