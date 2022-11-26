class UserSerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers
  attributes :id, :username, :created_at, :avatar, :location, :upcoming_event, :blocked_bands, :instruments, :follows_count, :followed_users, :followed_artists, :blocked_users, :followed_songs, :followed_bands, :followed_albums, :followers_count, :name, :last_name, :email, :notification_token, :applauds
  attribute :avatar, if: -> {object.avatar.present?}
  attribute :bio, if: -> {object.bio}
  attribute :notification_token, if: -> {object.notification_token}
  has_many :notifications
  has_many :bands
  has_many :genres
  has_many :posts, serializer: ShortPostSerializer
  has_many :favoritesongs
  has_many :favoriteartists
  has_many :favoritealbums
  
  def notification_token
    return object.notification_token.token
    
  end
  
  def upcoming_event
      events = object.events.where("event_date >= ?", Time.now)
      return events.last
      # return EventSerializer.new(events.last)
  end
  def applauds
    object.applauds.map do |appl|
      appl.post_id
    end
    
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

  def followed_bands
    object.followedbands.map do |band|
      band.id
    end
    
  end

  def followed_albums
    object.followedalbums.map do |album|
      album.spotify_id
    end
    
  end

  def follows_count
    object.follows.size + object.followedbands.size + object.followedartists.size + object.followedsongs.size + object.followedalbums.size
  end

  def followed_users
    object.followeds.map do |user|
      user.id
    end
  end

  def blocked_users
    object.blocked_users.map do |user|
      user.id
    end
  end

  def blocked_bands
    object.blocked_bands.map do |band|
      band.id
    end
  end


  def followed_songs
    object.followedsongs.map do |song|
      song.spotify_id
    end
  end

  def followed_artists
      object.followedartists.map do |artist|
      artist.spotify_id
    end
  end
  
  def avatar
    return url_for(object.avatar)
  end
  def bio 
    return object.bio.description
  end
  
  
end
