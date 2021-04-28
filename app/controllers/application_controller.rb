#frozen_literal_string: true

class ApplicationController < ActionController::API
    include JsonapiErrorsHandler

    ErrorMapper.map_errors!(
        'ActiveRecord::RecordNotFound' =>
            'JsonapiErrorsHandler::errors::NotFound'
    )
    rescue_from ::StandardError, with: lambda { |e| handle_error(e) }

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
end
