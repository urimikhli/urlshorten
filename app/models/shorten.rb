class Shorten < ApplicationRecord
    validates :slug, :full_url, presence: true
    validates :slug, uniqueness: { case_sensitive: false }
end