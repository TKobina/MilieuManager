class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  # Changes to the importmap will invalidate the etag for HTML responses
  stale_when_importmap_changes

  include Currency
  
  before_action :authenticate_user!
  before_action :get_milieu


  def get_milieu
    @milieu = current_user.milieus.find_by(params[:current_milieu]) || current_user.readings.find_by(params[:current_milieu])
  end

end
