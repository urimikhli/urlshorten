class ShortensController <  ApplicationController #JSONAPI::ResourceController #
  #skip_before_action :verify_authenticity_token
  before_action :set_shorten, only: [ :update, :destroy ]
  before_action :set_shorten_PUBLIC, only: [ :show ]
  skip_before_action :authorize!, only: [:show]
  include ShortensHelper
  include Paginable

  # GET /shortens
  #  Eventually will redirect to current User urlShortens list '/user/shortens/'.
  def index
    paginated = paginate( Shorten.recent )
    render_paginated_collection(paginated)
  end

  # GET /shortens/slug
  #this is the redirect
  def show
    if @shorten
      redirect_to generate_url(@shorten.full_url, request.query_parameters)
    else
      render json: errors(status: 404,
        title: "Record Not found",
        detail: "Could not find record",
        pointer: "/request/url/:id" ), status: :not_found
    end

  end

  # POST /shortens
  def create
    @shorten = current_user.shortens.build(shorten_params)
    if @shorten.valid?
      if @shorten.save
        render json: serializer.new(@shorten), status: :created, location: @shorten
      else #unable to save
        render_unprocessable_errors({
            title: "Unable to Create record",
            error_list: @shorten.errors,
            pointer: "/shortens/:create"
        })
      end
    else #invalid attributes
      render_unprocessable_errors({
          title: "Unable to process, Invalid attributes",
          error_list: @shorten.errors,
          pointer: "/data/attributes/"
      })
    end
  end

  # PATCH/PUT /shortens/id
  def update
    if @shorten.update(shorten_params)
      render json: serializer.new(@shorten), status: :ok, location: @shorten
    else
      render_unprocessable_errors({
          title: "Unable to process update",
          error_list: @shorten.errors,
          pointer: "/data/attributes/"
      })
    end
  end

  # DELETE /shortens/1
  def destroy
    @shorten.destroy
    head :no_content
  end

  private
    def serializer
      ShortenSerializer
    end

    #needed for UPDATE, DESTROY actions.
    def set_shorten
      @shorten = current_user.shortens.find{|x|x.slug == params[:slug]}
      raise ActiveRecord::RecordNotFound unless @shorten
    rescue  ActiveRecord::RecordNotFound
      authorization_error
    end

    #SHOW ACTION NEEDS TO REMAIN PUBLIC
    def set_shorten_PUBLIC
      @shorten = Shorten.find{|x| x.slug == params[:slug]}
    end

    # Only allow a list of trusted parameters through.
    def shorten_params
      params.require(:shorten).permit(:slug, :full_url) || ActionController::Parameters.new
    end
end
