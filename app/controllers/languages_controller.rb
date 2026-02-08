class LanguagesController < ApplicationController
  def index
    @languages = current_user.languages
  end

  def show
    @language = current_user.languages.find(params[:id])
  end
end

# <%= link_to "Statistics", controller: "dialects", action: "index", language_id: @language.id %>
