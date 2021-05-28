#frozen_literal_string: true

class ApplicationController < ActionController::API
    class AuthorizationError < StandardError; end
    rescue_from UserAuthenticator::AuthenticationError, with: :authentication_error
    rescue_from AuthorizationError, with: :authorization_error
    include JsonapiErrorsHandler
    before_action :authorize!

    # ErrorMapper.map_errors!(
    #     'ActiveRecord::RecordNotFound' =>
    #         'JsonapiErrorsHandler::errors::NotFound'
    # )
    # rescue_from ::StandardError, with: lambda { |e| handle_error(e) }

    def errors(error_hash)
      {
        errors: [{
          status: error_hash[:status],
          title: error_hash[:title],
          detail: error_hash[:detail],
          source: {
            pointer: error_hash[:pointer]
          }
        }]
      }
    end

    private

    def access_token
      provided_token = request.authorization&.gsub(/\ABearer\s/,'')
      @access_token = AccessToken.find_by(token: provided_token)
    end

    def current_user
      @current_user = access_token&.user
    end

    def authorize!
      raise AuthorizationError unless current_user
    end

    def authentication_error
        #render error json
        render json: errors(
                    status: 401,
                    title: "Authentication code is not valid",
                    detail: "Provide a valid code in order to login",
                    pointer: "/code") ,
                status: :unauthorized
    end

    def authorization_error
        #render error json
        render json: errors(
                    status: 403,
                    title: "Not Authorized",
                    detail: "User is not authorized to perform this action",
                    pointer: "/header/authorization") ,
                status: :forbidden
    end

    def render_unprocessable_errors(error)
      render json: errors(
        status: 422,
        title: error[:title],
        detail: error[:error_list],
        pointer: error[:pointer] ), status: :unprocessable_entity
    end
end
