class Shorten < ApplicationRecord
    validates :slug, presence: true
end