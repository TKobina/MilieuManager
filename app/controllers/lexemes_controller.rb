class LexemesController < ApplicationController
  def index
    @lexemes = @milieu.languages.find(params[:language_id]).lexemes

    respond_to do |format|
      format.html
      format.csv { send_data @lexemes.to_csv, filename: "lexemes-#{Date.today}.csv" }
    end
  end

  private

  def check_user
    
  end
end
