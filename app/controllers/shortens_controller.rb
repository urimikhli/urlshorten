class ShortensController < ApplicationController
  before_action :set_shorten, only: [:show, :update, :destroy]

  # GET /shortens
  def index
    @shortens = Shorten.all

    render json: @shortens
  end

  # GET /shortens/1
  def show
    render json: @shorten
  end

  # POST /shortens
  def create
    @shorten = Shorten.new(shorten_params)

    if @shorten.save
      render json: @shorten, status: :created, location: @shorten
    else
      render json: @shorten.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /shortens/1
  def update
    if @shorten.update(shorten_params)
      render json: @shorten
    else
      render json: @shorten.errors, status: :unprocessable_entity
    end
  end

  # DELETE /shortens/1
  def destroy
    @shorten.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_shorten
      @shorten = Shorten.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def shorten_params
      params.require(:shorten).permit(:slug, :full_url)
    end
end
