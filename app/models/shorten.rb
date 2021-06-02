class Shorten < ApplicationRecord
    validates :slug, :full_url, presence: true
    validates :slug, uniqueness: { case_sensitive: false }
    belongs_to :user

    scope :recent, -> { order(created_at: :desc)}
end