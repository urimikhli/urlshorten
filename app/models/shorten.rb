class Shorten < ApplicationRecord
    validates :slug, presence: true
    validates :slug, uniqueness: { case_sensitive: false }
end