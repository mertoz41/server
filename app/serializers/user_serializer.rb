class UserSerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers
  attributes :id, :username, :created_at, :avatar, :bio, :upcoming_event, :instruments, :follows_count, :blocked_account_count, :followers_count, :name, :email, :notification_token
  attribute :avatar, if: -> {object.avatar.present?}
  attribute :notification_token, if: -> {object.notification_token}
  has_many :notifications
  has_many :bands
  has_many :genres
  has_one :location
  has_many :posts, serializer: ShortPostSerializer
  has_many :favoritesongs
  has_many :favoriteartists
  has_many :favoritealbums
  
  def notification_token
    return object.notification_token.token
  end
  
  def upcoming_event
      events = object.events.where("event_date <= ?", Time.now)
      return events.first
  end


  def created_at
    object.created_at.to_date
  end

  def instruments
    object.instruments.map do |inst|
      {id: inst.id, name: inst.name}
    end
  end

  def followers_count
    object.followers.size
  end

  def follows_count
    object.follows.size + object.followedbands.size + object.followedartists.size + object.followedsongs.size + object.followedalbums.size
  end

  def blocked_account_count
    count = object.blocked_users.size + object.blocked_bands.size
  end

  def avatar
    return url_for(object.avatar)
  end
  
end
