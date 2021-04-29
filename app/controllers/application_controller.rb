#frozen_literal_string: true

class ApplicationController < ActionController::API
    rescue_from UserAuthenticator::AuthenticationError, with: :authentication_error
    include JsonapiErrorsHandler

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

    def authentication_error
        #render error json
        render json: errors(
                    status: 401,
                    title: "Authentication code is not valid",
                    detail: "Provide a valid code in order to login",
                    pointer: "/code") ,
                status: :unauthorized
    end
end
