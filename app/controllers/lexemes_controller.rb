class LexemesController < ApplicationController
  #before_action :check_user#, only: [:show, :edit, :update, :destroy]

  # def index
  #   language = Language.find(params[:language_id])
  #   @lexemes = language.lexemes.sort if current_user.languages.include?(language) 
  # end

  # def show
  #   #@lexeme = Lexeme.find(params[:lexeme_id])
  #   @lexeme = Lexeme.find(params[:id])
  #   #@lexeme = lexeme if lexeme.language.entity.milieu.user == current_user
  # end

  def index
    @lexemes = Lexeme.all

    respond_to do |format|
      format.html
      format.csv { send_data @lexemes.to_csv, filename: "lexemes-#{Date.today}.csv" }
    end
  end

  private

  def check_user
    
  end
end
