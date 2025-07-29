class Api::BaseController < ApplicationController
  # Skip CSRF protection for API requests
  skip_before_action :verify_authenticity_token

  # Set JSON as default format
  before_action :set_default_format

  # Handle Hotwire Native requests
  before_action :set_hotwire_native_headers

  private

  def set_default_format
    request.format = :json unless params[:format]
  end

  def set_hotwire_native_headers
    if hotwire_native_request?
      response.headers["Hotwire-Native"] = "true"
      response.headers["Access-Control-Allow-Origin"] = "*"
      response.headers["Access-Control-Allow-Methods"] = "GET, POST, PUT, PATCH, DELETE, OPTIONS"
      response.headers["Access-Control-Allow-Headers"] = "Content-Type, Authorization, X-Requested-With"
    end
  end

  def hotwire_native_request?
    request.user_agent&.include?("Hotwire Native") ||
    request.headers["HTTP_USER_AGENT"]&.include?("Hotwire Native")
  end
end
