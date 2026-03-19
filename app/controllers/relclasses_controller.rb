class RelclassesController < ApplicationController
  before_action :get_milieu  
  before_action :check_owner 
  def index
    @relclasses = filter_records(@milieu.relclasses.order(:kind))
  end

  def show
    @relclass = @milieu.relclasses.find(params[:id])
  end

  def new
    @relclass = Relclass.new
  end

  def create
    @relclass = Relclass.new(relclass_params)
    @relclass.milieu = @milieu
    if @relclass.save
      redirect_to relclasses_path(current_milieu: @milieu)
    else
      redirect_to edit_relclass_path(@relclass.id, current_milieu: @milieu), alert: "Relclass editing failed!"
    end
  end

  def edit
    @relclass = @milieu.relclasses.find(params[:id])
  end

  def update   
    @relclass = @milieu.relclasses.find(params[:id])
    if @relclass.update!(relclass_params)
      redirect_to relclasses_path(current_milieu: @milieu)
    else
      redirect_to edit_relclass_path(@relclass.id, current_milieu: @milieu), alert: "Relclass editing failed!"
    end
  end

  def destroy
  end

  private

  def relclass_params
    params.expect(relclass: [:kind, :bottomtop, :topbottom])
  end

  def check_owner
    redirect_to milieu_path(@milieu, current_milieu: @milieu) if !@owner
  end
end
