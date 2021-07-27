class BandpostsController < ApplicationController
    def create
        band_id = params[:band_id].to_i
        artist_name = params[:artist_name]
        artist_spotify_id = params[:artist_spotify_id]
        song_spotify_id = params[:song_spotify_id]
        song_name = params[:song_name]
        album_name = params[:album_name]
        album_spotify_id = params[:album_spotify_id]
        instruments = JSON.parse params[:instruments]
        artist = Artist.find_or_create_by(name: artist_name, spotify_id: artist_spotify_id)
        album = Album.find_or_create_by(name: album_name, artist_id: artist.id, spotify_id: album_spotify_id)
        song = Song.find_or_create_by(name: song_name, artist_id: artist.id, album_id: album.id, spotify_id: song_spotify_id)
        genre = Genre.find_or_create_by(name: params[:genre])
        @bandpost = Bandpost.create(band_id: band_id, artist_id: artist.id, song_id: song.id, genre_id: genre.id)
        instruments.each do |instrument| 
            inst = Instrument.find_or_create_by(name: instrument)
            Bandpostinstrument.create(bandpost_id: @bandpost.id, instrument_id: inst.id)
        end
       
        @bandpost.clip.attach(params[:clip])
        @bandpost.thumbnail.attach(params[:thumbnail])
        render json: @bandpost, serializer: BandpostSerializer
    end

    def createview
        # byebug
        user = User.find(params[:user_id])
        post = Bandpost.find(params[:bandpost_id])
        Bandpostview.create(user_id: user.id, bandpost_id: post.id)
        render json: {message: 'view counted'}
    end

    def share
        # byebug
        @nu_share = Bandpostshare.create(user_id: params[:user_id].to_i, bandpost_id: params[:bandpost_id].to_i)
        render json: {nu_share: BandpostshareSerializer.new(@nu_share)}
        # findbandpost and user
        # create instance

    end
    def unshare
        share = Bandpostshare.find(params[:id])
        share.destroy
        render json: {message: 'post unshared.'}
    end
    def destroy
        post = Bandpost.find(params[:id])
        # when bandpost is deleted, songs bandpost will be deleted, but song instance will still exist.
        # check if song instance has other bandposts or posts
        # if it doesnt, delete the song. 
        song = Song.find(post.song_id)
        post.destroy
        if song.bandposts.length == 0 && song.posts.length == 0
            song.destroy
        end
        render json: {message: 'bandpost deleted.'}
    end
end
