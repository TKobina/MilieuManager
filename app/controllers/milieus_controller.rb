class MilieusController < ApplicationController
  def index
    @milieus = current_user.milieus.sort
    @editings = current_user.accesses.where(edit_rights: true).map{|acc| acc.milieu }
    @readings = current_user.accesses.where(edit_rights: false).map{|acc| acc.milieu }
  end

  def show
    @milieu = current_user.milieus.find(params[:current_milieu])
  end

  
  def new
    @milieu = Milieu.new
  end

  def create
    @milieu = Milieu.new(get_params)
    @milieu.owner = current_user  
    if @milieu.save
      redirect_to milieu_path(@milieu, current_milieu: @milieu)
    else
      redirect_to new_milieu_path, alert: "Milieu creation failed!"
    end
  end

  def edit
    @milieu = current_user.milieus.find(params[:id])
  end

  def update
    @milieu = current_user.milieus.find(params[:id])
    if @milieu.update(get_params)
      redirect_to milieu_path(@milieu, current_milieu: @milieu)
    else
      redirect_to edit_milieu_path(params[:id]), alert: "Milieu update failed!"
    end
  end

  def destroy
    @milieu = current_user.milieus.find(params[:id])
    @milieu.destroy!
    redirect_to milieus_path
  end

  private

  def get_params
    params.expect(milieu: [:name, :details])
  end
end
