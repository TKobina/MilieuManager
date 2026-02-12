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

  private
end
