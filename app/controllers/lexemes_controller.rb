class LexemesController < ApplicationController
  def index
    @lexemes = @milieu.languages.find(params[:language_id]).lexemes.sort

    respond_to do |format|
      format.html
      format.csv { send_data @lexemes.to_csv, filename: "lexemes-#{Date.today}.csv" }
    end
  end

  def show
    @lexeme = Lexeme.find(params[:id])

    if (@lexeme.language.entity.milieu.owner != current_user && !@lexeme.language.entity.milieu.readers.include?(current_user))
      redirect_to lexemes_path(current_milieu: @milieu), alert: "Not authorized or record not found."
    end

  end

  private
end

    # @event = @milieu.events.find(params[:id])
    # if (!@private && !@event.public)
    #   redirect_to events_path(current_milieu: @milieu), alert: "Not authorized or record not found."
    # end