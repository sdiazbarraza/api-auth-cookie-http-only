module Api
    module V1
      class AuthController < ApplicationController
        include JwtWebToken
        skip_before_action :authorize_request

        def logout
            cookies.delete(:jwt, domain: "localhost")
            render(json: { message: "succesfully logged out" }, status: :ok)
        end

        def login
            user = User.find_by_email(params[:email])
            # Bcrypt method
            checked = user&.authenticate(params[:password])
            return render(json: { error: "Not found" }, status: 404) unless checked

            jwt = set_cookie(user.id, user.email)
            render(json: { message: "Welcome back!", jwt: }, status: :ok)
        end

        def signup
            user_params = params.permit(:email, :name, :password)
            user = User.create!(user_params)

            jwt = set_cookie(user.id, user.email)
            render(json: { message: "Welcome", user: user.email, jwt: }, status: :ok)
            rescue ActiveRecord::RecordInvalid => e
            render(json: { error: e.record.errors }, status: 422)
        end

        def set_cookie(id, email)
            jwt = encode({ id:, email: })
            cookies.signed[:jwt] = {
                value: jwt,
                httponly: true,
                expires: 30.minute.from_now,
                same_site: :lax,
                domain: "localhost"
            }
            jwt
        end
      end
    end
end
