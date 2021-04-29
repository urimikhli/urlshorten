class Shorten < ApplicationRecord
    validates :slug, :full_url, presence: true
    validates :slug, uniqueness: { case_sensitive: false }

    scope :recent, -> { order(created_at: :desc)}
end