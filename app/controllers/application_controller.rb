#frozen_literal_string: true

class ApplicationController < ActionController::API
    include JsonapiErrorsHandler

    ErrorMapper.map_errors!(
        'ActiveRecord::RecordNotFound' =>
            'JsonapiErrorsHandler::errors::NotFound'
    )
    rescue_from ::StandardError, with: lambda { |e| handle_error(e) }
end
