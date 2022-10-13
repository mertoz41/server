class UseralbumsController < ApplicationController
    def create
        user = User.find(params[:user_id])
        artist = Artist.find_or_create_by(name: params[:artist_name], spotify_id: params[:artist_spotify_id])
        @album = Album.find_or_create_by(name: params[:name], artist_id: artist.id, spotify_id: params[:spotify_id])
        user_album = Useralbum.create(user_id: user.id, album_id: @album.id)
        render json: {album: AlbumSerializer.new(@album)}
    end


    def delete
        user = User.find(params[:user_id])
        album = Album.find(params[:album_id])
        user_album = Useralbum.find_by(user_id: user.id, album_id: album.id)
        user_album.destroy
        if album.songs.size == 0 && album.favoriteusers.size == 0
            album.destroy
        end
        render json: {message: 'users favorite album deleted.'}
    end




    def update
        user = User.find(params[:user_id])
        old_favorite = Useralbum.find_by(user_id: user.id, album_id: params[:oldAlbumId])
        old_favorite.destroy
        artist = Artist.find_or_create_by(name: params[:artist_name], spotify_id: params[:artistSpotifyId])
        album = Album.find_or_create_by(name: params[:name], artist_id: artist.id, spotify_id: params[:spotify_id])
        new_favorite = Useralbum.create(user_id: user.id, album_id: album.id)
        render json: {album_id: album.id}
    end
end
