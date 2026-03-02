class LanguagesController < ApplicationController
  before_action :get_milieu
  def index
    @languages = @milieu.languages
  end

  def show
    @language = @milieu.languages.find(params[:id])
  end
end

# <%= link_to "Statistics", controller: "dialects", action: "index", language_id: @language.id %>
