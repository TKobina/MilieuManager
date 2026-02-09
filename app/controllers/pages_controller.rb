class PagesController < ApplicationController
  before_action :get_milieu
  def index
  end

  private

  def get_milieu
    current_milieu(current_user.milieus.first) if current_user.milieus.count == 1
  end
end
