class MilieusController < ApplicationController
  def index
    @milieus = current_user.milieus
    @editings = current_user.accesses.where(edit_rights: true).map{|acc| acc.milieu }
    @readings = current_user.accesses.where(edit_rights: false).map{|acc| acc.milieu }
  end

  def show
    @milieu = Milieu.first
  end
end
