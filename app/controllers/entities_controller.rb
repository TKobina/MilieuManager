class EntitiesController < ApplicationController
  def index
    @entities = current_user.entities
  end

  def show
    @entity = current_user.entities.find(params[:id])
  end
end
