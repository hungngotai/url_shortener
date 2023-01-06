class UrlController < ApplicationController
  def encoded
    url = UrlShortenerService.call(params[:url])
    if url.errors.empty?
      render json: { url: url_encoded(url) }, status: :created
    else
      render json: { error: url.errors.as_json }, status: :bad_request
    end
  end

  private

  def url_encoded(url)
    "#{request.base_url}/#{url.shortened}"
  end
end
