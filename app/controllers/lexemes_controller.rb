class LexemesController < ApplicationController
  before_action :set_language

  def index
    @lexemes = @language.lexemes.sort

    respond_to do |format|
      format.html
      format.csv { send_data @lexemes.to_csv, filename: "lexemes-#{Date.today}.csv" }
    end
  end

  def show
    @lexeme = Lexeme.find(params[:id])

    if (@lexeme.language.entity.milieu.owner != current_user && !@lexeme.language.entity.milieu.readers.include?(current_user))
      redirect_to lexemes_path(current_milieu: @milieu, language_id: @language.id), alert: "Not authorized or record not found."
    end

  end

  def new
    @lexeme = Lexeme.new
  end

  def create
    @lexeme = Lexeme.new(lexeme_params)
    @lexeme.language = @language
    if @lexeme.save
      @lexeme.procsubs(params[:sublexeme_eids])
      redirect_to lexeme_path(@lexeme,current_milieu: @milieu, language_id: @language.id)
    else
      redirect_to new_lexeme_path(current_milieu: @milieu, language_id: @language.id), alert: "Update failed!"
    end
  end

  def edit
    @lexeme = Lexeme.find(params[:id])

    if (@language.entity.milieu.owner != current_user)
      redirect_to lexemes_path(current_milieu: @milieu, language_id: @language.id), alert: "Not authorized or record not found."
    end
  end

  def update
    @lexeme = Lexeme.find(params[:id])
    if (@language.entity.milieu.owner != current_user)
      redirect_to lexemes_path(current_milieu: @milieu, language_id: @language.id), alert: "Not authorized or record not found."
    end

    if @lexeme.update(lexeme_params)
      @lexeme.procsubs(params[:sublexeme_eids])
      redirect_to lexeme_path(@lexeme,current_milieu: @milieu, language_id: @language.id)
    else
      redirect_to edit_lexeme_path(@lexeme, current_milieu: @milieu, language_id: @language.id), alert: "Update failed!"
    end
  end

  def destroy
      @lexeme = Lexeme.find(params[:id])

    if (@language.entity.milieu.owner != current_user)
      redirect_to lexemes_path(current_milieu: @milieu, language_id: @language.id), alert: "Not authorized or record not found."
    end

    @lexeme.destroy
    redirect_to lexemes_path(current_milieu: @milieu, language_id: @language.id)
  end


  private
  def lexeme_params
    params.expect(lexeme: [:language_id, :word, :kind, :meaning, :sublexeme_eids, :details ])
  end

  def set_language
        @language = current_user.milieus.find_by(params[:current_milieu])&.languages&.find_by(params[:language_id]) || current_user.readings.find_by(params[:current_milieu]).languages.find_by(params[:language_id])
  end
end