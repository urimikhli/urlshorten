class ShortensController <  ApplicationController #JSONAPI::ResourceController #
  #skip_before_action :verify_authenticity_token
  before_action :set_shorten, only: [:show]
  include ShortensHelper

  # GET /shortens
  #  Eventually will redirect to current User urlShortens list '/user/shortens/'.
  def index
    shorten = Shorten.recent

    render json: serializer.new(shorten), status: :ok
  end

  def serializer
    ShortenSerializer
  end

  # GET /shortens/slug
  #this is the redirect
  def show
    if @shorten
      redirect_to generate_url(@shorten.full_url, request.query_parameters)
    else
      render json: "'#{params['slug']}' not found", status: :not_found
    end

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

  # PATCH/PUT /shortens/id
  def update
    if @shorten
      @shorten.update(shorten_params)
      render json: @shorten
    else
      render json: " cant update, '#{params['id']}' not found", status: :unprocessable_entity
    end
  end

  # DELETE /shortens/1
  def destroy
    @shorten.destroy
  end

  private
    #needed for SHOW action.
    def set_shorten
      @shorten = Shorten.find{|url| url.slug == params[:slug]}
    end

    # Only allow a list of trusted parameters through.
    def shorten_params
      params.require(:shorten).permit(:slug, :full_url)
    end
end
