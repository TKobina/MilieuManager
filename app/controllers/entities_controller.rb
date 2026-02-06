class EntitiesController < ApplicationController
  def index
    @entities = current_user.entities.where.not(kind: "world").sort
  end

  def show
    @entity = current_user.entities.find(params[:id])
    @superiors, @superior_relations = [@entity.superiors, @entity.superior_relations]
    @inferiors, @inferior_relations = [@entity.inferiors, @entity.inferior_relations]
    @events = @entity.events
  end
end
