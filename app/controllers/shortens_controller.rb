class ShortensController < JSONAPI::ResourceController # ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :set_shorten, only: [:show]
  include ShortensHelper

  # GET /shortens
  #  Eventually will redirect to current User urlShortens list '/user/shortens/'.
  # def index
  #   let jsonapi manage it
  # end


  # GET /shortens/slug
  #this is the redirect
  def show
    if @shorten
      redirect_to generate_url(@shorten.full_url, request.query_parameters)
    else
      render json: "'#{params['slug']}' not found", status: :not_found
    end

  end

  # # POST /shortens
  # def create
  #   let jsonapi manage it
  # end

  # # PATCH/PUT /shortens/slug
  #  def update
  #   let jsonapi manage it
  #  end

  # # DELETE /shortens/1
  # def destroy
  #   let jsonapi manage it
  # end

  private
    #needed for SHOW action.
    def set_shorten
      @shorten = Shorten.find{|url| url.slug == params[:slug]}
    end

    # # Only allow a list of trusted parameters through.
    # def shorten_params
    #   let jsonapi manage it
    # end
end
