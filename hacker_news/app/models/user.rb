class User < ApplicationRecord
    has_many :likes, dependent: :destroy
    has_many :commentlikes, dependent: :destroy
end
