class PostSerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers

  attributes :id, :user_id, :instrument_id, :song_id, :artist_id, :clip, :created_at, :username, :artist_name, :song_name, :instrument_name, :useravatar, :comment_count, :share_count, :thumbnail
  def clip
    url_for(object.clip)
  end
  def comment_count
    return object.comments.size
  end
  def share_count
    return object.shares.size
  end

  # def created_at
  #   object.created_at.to_date
  # end

  def username
    user = User.find(object.user_id)
    return user.username
  end
  def useravatar
    user = User.find(object.user_id)
    return url_for(user.avatar)
  end

  def artist_name
    artist = Artist.find(object.artist_id)
    return artist.name
  end 

  def song_name
    song = Song.find(object.song_id)
    return song.name
  end 


  def instrument_name
    instrument = Instrument.find(object.instrument_id)
    return instrument.name 
  end 

end
