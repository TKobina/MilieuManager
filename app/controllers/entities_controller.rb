class EntitiesController < ApplicationController
  def index
    milieu = Milieu.includes(:user)
    @entities = Entity.includes(:milieu)
  end

  def show
    @entity = Entity.find(params[:id])
  end
end
