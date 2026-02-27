class RelclassesController < ApplicationController
  before_action :check_owner 
  def index
    return unless @owner
    @relclasses = filter_records(@milieu.relclasses.order(:kind))
  end

  def show
    return unless @owner
    @relclass = @milieu.relclasses.find(params[:id])
  end

  def new
    #@reference = Reference.new(text: {pri: "", pub: ""})
  end

  def create
    # @reference = Reference.new(get_params)
    # @reference.milieu = @milieu
    # if @reference.save
    #   redirect_to reference_path(@reference, current_milieu: @milieu)
    # else
    #   redirect_to new_reference_path(current_milieu: @milieu), alert: "Reference creation failed!"
    # end
  end

  def edit
    return unless @owner
    @relclasses = @milieu.relclasses.find(params[:id])
  end

  def update   
    @relclass = @milieu.relclasses.find(params[:id])
    if @relclass.update(reference_params)
      redirect_to relclass_path(@relclass, current_milieu: @milieu)
    else
      redirect_to edit_relclass_path(current_milieu: @milieu), alert: "Relclass editing failed!"
    end
  end

  def destroy
  end

  private

  def reference_params
    params.expect(:kind, :bottomtop, :tobbottom)
  end

  def check_owner
    redirect_to milieu_path(@milieu, current_milieu: @milieu) if !@owner
  end
end
