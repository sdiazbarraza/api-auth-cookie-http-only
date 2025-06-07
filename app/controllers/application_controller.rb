class ApplicationController < ActionController::API
    include ActionController::Cookies
    include JwtWebToken
  
    before_action :authorize_request
  
    private
  
    def authorize_request
      jwt = cookies.signed[:jwt]
      token = decode(jwt)
      render(json: { error: 'Unauthorized' }, status: 401) unless token
    end
end
