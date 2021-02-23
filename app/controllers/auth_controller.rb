class AuthController < ApplicationController
    def create
        @user = User.find_by(username: params[:username])
        if @user && @user.authenticate(params[:password])
            payload = {user_id: @user.id}
            token = encode(payload)
            @timeline = []
            @user.posts.each do |post|
                @timeline.push(post)
            end 
            render json: {user: UserSerializer.new(@user), token: token, timeline: ActiveModel::Serializer::CollectionSerializer.new(@timeline, each_serializer: PostSerializer)}
        else 
            render json: {message: 'Invalid username or password.'}
        end
    end

    def check
        @user = User.find(decode(params[:token])["user_id"])
        @timeline = []
            @user.posts.each do |post|
                @timeline.push(post)
            end 
        render json: {user: UserSerializer.new(@user), timeline: ActiveModel::Serializer::CollectionSerializer.new(@timeline, each_serializer: PostSerializer)}
    end

end
