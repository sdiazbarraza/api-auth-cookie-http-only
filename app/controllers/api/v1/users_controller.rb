module Api
    module V1
      class UsersController < ApplicationController
        skip_before_action :authorize_request, only: :create
        before_action :set_user, only: %i[show destroy]
  
        include JwtWebToken
  
        def index
          users = User.all
          render(json: { users: users }, status: :ok)
        end
  
        def create
          User.create!(user_params)
        end
  
        def current
          jwt = decode(cookies.signed[:jwt])
          render(json: { jwt: jwt }, status: :ok)
        end
  
        def show
          unless @user
            render(json: { error: "not found" }, status: 404) and return
          end
  
          render(json: { user: @user }, status: :ok)
        end
  
        private
  
        def user_params
          params.permit(:name, :email, :password)
        end
  
        def set_user
          @user = User.find_by(id: params[:id])
        end
      end
    end
  end