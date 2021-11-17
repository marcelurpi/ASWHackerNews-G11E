class Comment < ApplicationRecord
 belongs_to :commentable, polymorphic: true
 has_many :comments, as: :commentable
 has_many :commentlikes, dependent: :destroy
end
