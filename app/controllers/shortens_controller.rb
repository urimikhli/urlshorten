class ShortensController < ApplicationController
  before_action :set_shorten, only: [:show, :update, :destroy]
  include ShortensHelper

  # GET /shortens
  #  Eventually will redirect to current User urlShortens list '/user/shortens/'.
  def index
    @shortens = Shorten.all

    render json: @shortens
  end

  # GET /shortens/slug
  def show
    if @shorten
      redirect_to generate_url(@shorten.full_url, request.query_parameters)
    else
      render json: "'#{params['slug']}' not found", status: :not_found
    end

    #render json: @shorten
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

  # PATCH/PUT /shortens/slug
  def update
    if @shorten
      @shorten.update(shorten_params)
      render json: @shorten
    else
      render json: " cant update, '#{params['slug']}' not found", status: :unprocessable_entity
    end
  end

  # DELETE /shortens/1
  def destroy
    @shorten.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_shorten
      @shorten = Shorten.find{|url| url.slug == params[:slug]}
    end

    # Only allow a list of trusted parameters through.
    def shorten_params
      params.require(:shorten).permit(:slug, :full_url)
    end
end
