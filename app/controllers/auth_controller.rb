class AuthController < ApplicationController
    skip_before_action :authorized, only: [:create]

    def create
        @user = User.find_by(username: params[:username])
        if @user && @user.authenticate(params[:password])
            payload = {user_id: @user.id}
            token = encode(payload)
            @timeline = @user.timeline
            render json: {user: UserSerializer.new(@user), token: token, timeline: ActiveModel::Serializer::CollectionSerializer.new(@timeline, each_serializer: PostSerializer)}
        else 
            render json: {message: 'Invalid username or password.'}
        end
    end

    def check
        token = request.headers["Authorization"].split(' ')[1]
        @user = User.find(decode(token)["user_id"])
        @timeline = @user.timeline
        render json: {user: UserSerializer.new(@user), timeline: ActiveModel::Serializer::CollectionSerializer.new(@timeline, each_serializer: PostSerializer)}
    end

end
