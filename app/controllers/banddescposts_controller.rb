class BanddescpostsController < ApplicationController
    def create
        band_id = params[:band_id].to_i
        description = params[:description]
        genre = Genre.find_or_create_by(name: params[:genre])
        instruments = JSON.parse params[:instruments]
        @new_post = Banddescpost.create(band_id: band_id, description: description, genre_id: genre.id)
        instruments.each do |instrument|
            inst = Instrument.find_or_create_by(name: instrument)
            Banddescpostinstrument.create(banddescpost_id: @new_post.id, instrument_id: inst.id)
        end
        @new_post.clip.attach(params[:clip])
        @new_post.thumbnail.attach(params[:thumbnail])
        render json: @new_post, serializer: BanddescpostSerializer
    end 

    def share
        post = Banddescpost.find(params[:banddescpost_id])
        user = User.find(params[:user_id])
        @nu_share = Banddescpostshare.create(banddescpost_id: post.id, user_id: user.id)
        render json: {nu_share: BanddescpostshareSerializer.new(@nu_share)}
        # byebug
        # findbanddescpost and user
        # create instance
    end
    def createview
        user = User.find(params[:user_id])
        post = Banddescpost.find(params[:banddescpost_id])
        Banddescpostview.create(user_id: user.id, banddescpost_id: post.id)
        render json: {message: 'view counted'}
    end

    def unshare
        share = Banddescpostshare.find(params[:id])
        share.destroy
        render json: {message: 'post unshared.'}
    end
    def destroy
        banddescpost = Banddescpost.find(params[:id])
        banddescpost.destroy
        render json: {message: 'banddescpost deleted.'}
    end
end
