class UrlController < ApplicationController
  def encoded
    url = "#{request.base_url}/#{UrlShortenerService.call(params[:url])}"
    render json: { url: url }, status: :created
  end
end
