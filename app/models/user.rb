class User < ApplicationRecord
    validates :login, presence: true, uniqueness: true
    validates :provider, presence: true

    has_one :access_token, dependent: :destroy
    has_many :shortens, dependent: :destroy
end
