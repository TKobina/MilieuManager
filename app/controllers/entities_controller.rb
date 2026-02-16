class EntitiesController < ApplicationController
  before_action :check_owner, only: [:create, :edit, :update, :destroy]

  def index
    @entities = cache_records(current_user.id.to_s + "Entity",filter_records(@milieu.entities).where.not(kind: "world"))
    
    #@entities.sort
    @eidnext = @entities.max_by{|ent| ent.eid.to_i}.eid.to_i + 1
  end

  def show
    @entity = @milieu.entities.find(params[:id])
    
    check_public

    @superiors, @superior_relations = filter_joint_records(@entity.superiors, @entity.superior_relations)
    @inferiors, @inferior_relations = filter_joint_records(@entity.inferiors, @entity.inferior_relations)
    @events = filter_records(@entity.events)
  end

  def create
    @entity = Entity.new(entity_params)
    @entity.public = false
    @entity.milieu = @milieu

    if @entity.save
      redirect_to entity_path(@entity, current_milieu: @milieu)
    else
      redirect_to new_entity_path(current_milieu: @milieu), alert: "Entity creation failed!"
    end
  end

  def edit
    @entity = @milieu.entities.find(params[:id])
  end

  def update
    @entity = @milieu.entities.find(params[:id])
    @entity.text[:pri] = params[:textpri]
    @entity.text[:pub] = params[:textpub]
    if @entity.update(entity_params)
      redirect_to @entity
    else
      redirect_to new_entity_path(current_milieu: @milieu), alert: "Entity edit failed!"
    end
  end

  def destroy
    #@story = @milieu.stories.find(params[:id])
    #@story.destroy
    #redirect_to stories_path
  end


  private

  def check_public
    if (!@private && !@entity.public)
      redirect_to entities_path(current_milieu: @milieu), alert: "Not authorized or record not found."
    end
  end

  def check_owner
    unless @owner
      redirect_to entities_path(current_milieu: @milieu), alert: "Not authorized or record not found."
    end
  end

  def entity_params
    params.expect(entity: [ :eid, :kind, :name, :text, :public ])
  end
end
