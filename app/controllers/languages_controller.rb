class LanguagesController < ApplicationController
  def index
    @languages = current_user.entities.includes(:language).where(kind: "Nation").map {|ent| ent.language }
  end
end

# <%= link_to "Statistics", controller: "dialects", action: "index", language_id: @language.id %>
