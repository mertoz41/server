class PostSerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers
  attributes :id, :user_id, :clip, :created_at, :comment_count, :genre_id, :genre, :instruments, :view_count, :description, :applaud_count, :applauded
  attribute :user_id, if: -> {object.user.present?}
  attribute :username, if: -> {object.user.present?}
  attribute :useravatar, if: -> {object.user.avatar.attached?}
  attribute :band_id, if: -> {object.band.present?}
  attribute :bandname, if: -> {object.band.present?}
  attribute :bandpicture, if: -> {object.band.present?}
  attribute :current_state, if: -> {object.user.present?}
  attribute :artist_id, if: -> {object.artist.present?}
  attribute :song_id, if: -> {object.song.present?}
  attribute :artist_name, if: -> {object.artist.present?}
  attribute :song_name, if: -> {object.song.present?}
  attribute :songSpotifyId, if: -> {object.song.present?}
  attribute :artistSpotifyId, if: -> {object.artist.present?}
  attribute :albumSpotifyId, if: -> {object.song.present?}

  def clip
    url_for(object.clip)
  end

  def albumSpotifyId
    return object.song.album.spotify_id
  end

  def instruments
    object.instruments.map do |instrument|
      instrument.id
    end
  end

  def view_count
    object.postviews.size
  end

  def applauded
    found = Applaud.find_by(user_id: logged_in_user.id, post_id: object.id)
    if found
      return true 
    end
    return false
  end
  
  def genre
    return object.genre.name
  end
  def comment_count
    return object.comments.size
  end
  def applaud_count
    return object.applauds.size
  end
  def current_state
    return object.user.location.city.split()[1]
  end

  def bandname
    return object.band.name
  end

  def bandpicture
    return url_for(object.band.picture)
  end

  def username
    return object.user.username
  end

  def useravatar
    return url_for(object.user.avatar)
  end

  def artist_name
    return object.artist.name
  end 

  def song_name
    return object.song.name
  end 

  def songSpotifyId
    return object.song.spotify_id
  end

  def artistSpotifyId
    return object.artist.spotify_id
  end


  def logged_in_user
    scope
  end


  

end
