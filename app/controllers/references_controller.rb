class ReferencesController < ApplicationController
  before_action :check_owner 
  def index
    @references = cache_records(current_user.id.to_s + "Reference", filter_records(@milieu.references.order(:eid)))
    
  end

  def show
    return unless @owner
    @reference = @milieu.references.find(params[:id])
  end

  def new
    @reference = Reference.new(text: {pri: "", pub: ""})
  end

  def create
    @reference = Reference.new(get_params)
    @reference.milieu = @milieu
    if @reference.save
      redirect_to reference_path(@reference, current_milieu: @milieu)
    else
      redirect_to new_reference_path(current_milieu: @milieu), alert: "Reference creation failed!"
    end
  end

  def edit
    @reference = @milieu.references.find(params[:id])
  end

  def update   
    @reference = @milieu.references.find(params[:id])
    if @reference.update(get_params)
      redirect_to reference_path(@reference, current_milieu: @milieu)
    else
      redirect_to edit_reference_path(current_milieu: @milieu), alert: "Reference editing failed!"
    end
  end

  def destroy
  end

  private
  def get_params
    eparams = {text: {pri: "", pub: ""}}
    eparams[:milieu] = @milieu
    eparams[:name], eparams[:eid], text = reference_params
    eparams[:text][:pri], eparams[:text][:pub] = text.values
    eparams
  end

  def reference_params
    params.expect(:name, :eid, text: [:pri, :pub])
  end

  def check_owner
    redirect_to milieu_path(@milieu, current_milieu: @milieu) if !@owner
  end
end