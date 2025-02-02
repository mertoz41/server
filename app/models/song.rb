class Song < ApplicationRecord
    belongs_to :artist


    has_many :posts, dependent: :destroy
    has_many :postviews, through: :posts

    has_many :users, through: :posts

    has_many :bands, through: :posts

    has_many :usersongs, dependent: :destroy
    has_many :favoriteusers, through: :usersongs

    has_many :songfollows, dependent: :destroy
    has_many :followingusers, through: :songfollows
end
