class ShortensController < ApplicationController
  before_action :set_shorten, only: [:show, :update, :destroy]

  # GET /shortens
  # no route, Eventually will redirect to current User urlShortens list.
  def index
    @shortens = Shorten.all

    render json: @shortens
  end

  # GET /shortens/slug
  def show
    redirect_to @shorten.full_url
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
      short = Shorten.select{|url| url.slug == params[:slug]}
      @shorten = short.last ? short.last : Shorten.new(full_url:'/notfound')
    end

    # Only allow a list of trusted parameters through.
    def shorten_params
      params.require(:shorten).permit(:slug, :full_url)
    end
end
