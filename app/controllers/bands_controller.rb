class BandsController < ApplicationController

    def searching
        @bands = Band.where("name like?", "%#{params[:searching]}%")
        render json: {bands: ActiveModel::Serializer::CollectionSerializer.new(@bands, each_serializer: BandSerializer)}
    end
    def picture
        @band = Band.find(params[:band_id])
        @band.picture.attach(params[:picture])
        render json: {band: BandSerializer.new(@band)}
    end

    def show
        @band = Band.find(params[:id])
        render json: {band: BandSerializer.new(@band), members: ActiveModel::Serializer::CollectionSerializer.new(@band.members, each_serializer: UserSerializer)}
    end
    
    def create
        # create the band first with name description and picture

        @band = Band.create(name: params[:name])
        bio = Bandbio.create(description: params[:description], band_id: @band.id)
        @band.picture.attach(params[:picture])
        
        # create bandmember instance for each user
        members = JSON.parse params[:members]
        # byebug
        members.each do |id|
            Bandmember.create(user_id: id, band_id: @band.id)
        end

        # find location object
        location = Location.find(params[:location_id])

        # create bandlocation object
        Bandlocation.create(band_id: @band.id, location_id: location.id)

        render json: @band, serializer: BandSerializer

    end
end
