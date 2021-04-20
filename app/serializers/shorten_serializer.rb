# frozen_string_literal: true

class ShortenSerializer 
    include JSONAPI::Serializer

    attributes :slug, :full_url
end
