class GamesController < ApplicationController
  before_action :set_and_authorize_game, only: [:edit, :edit_score, :update, :update_score, :destroy]
  before_action :set_game, only: [:show, :notes, :widget]
  before_action :load_teams, only: [:new, :edit]

  before_action :load_teams, only: [:new, :edit]

  skip_before_action :force_https, only: :widget

  # GET /games
  # GET /games.json
  def index
    @show_jumbo = true if request.path == '/'
    @games = Game.relevant.order(updated_at: :desc )
  end

  # GET /games/1
  # GET /games/1.json
  def show
    @notes = @game.notes.recent
  end

  def widget
    @theme = widget_params[:theme] || :default
    render 'widget', layout: 'widget'
  end

  # GET /games/1
  # GET /games/1.json
  def notes
    if request.xhr?
      render partial: 'game_notes', locals: { game: @game, notes: @game.notes.recent }
    else
      redirect_to game_path(@game)
    end
  end

  # GET /games/new
  def new
    @game = Game.new
    @game.game_day = Date.today
    @game.game_time = '15:00'
  end

  # GET /games/1/edit
  def edit
  end

  # GET /games/1/edit_score
  def edit_score
    @period_options = []
    Game::PERIODS.each do |key|
      @period_options << [ t("activerecord.values.game.period.#{key}"), key ]
    end
  end

  # POST /games
  # POST /games.json
  def create
    @game = Game.new(game_params)
    @game.user = current_user
    respond_to do |format|
      if @game.save
        format.html { redirect_to @game, notice: 'Game was successfully created.' }
        format.json { render :show, status: :created, location: @game }
      else
        format.html { render :new }
        format.json { render json: @game.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /games/1
  # PATCH/PUT /games/1.json
  def update
    respond_to do |format|
      if @game.update(game_params)
        format.html { redirect_to @game, notice: 'Game was successfully updated.' }
        format.json { render :show, status: :ok, location: @game }
      else
        format.html { render :edit }
        format.json { render json: @game.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /games/1
  # DELETE /games/1.json
  def destroy
    @game.destroy
    respond_to do |format|
      format.html { redirect_to games_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_game
      @game = Game.find(params[:id])
    end

    def set_and_authorize_game
      set_game
      authorize! action_name.to_sym, @game
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def game_params
      params.require(:game).permit(
        :home_team_id,
        :away_team_id,
        :home_quarter_1, :home_quarter_2, :home_quarter_3, :home_quarter_4,
        :away_quarter_1, :away_quarter_2, :away_quarter_3, :away_quarter_4,
        :period, :possession,
        :location,
        :game_day, :game_time
      )
    end

    def widget_params
      params.permit(:theme)
    end

    def load_teams
      @teams = Team.all.order(:name)
    end
end
