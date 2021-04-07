class ShortenResource < JSONAPI::Resource
    attributes :slug, :full_url
end
