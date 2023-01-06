class UrlController < ApplicationController
  def encoded
    url = UrlShortenerService.call(params[:url])
    if url.errors.empty?
      render json: { url: url_encoded(url) }, status: :created
    else
      render json: { error: url.errors.as_json }, status: :bad_request
    end
  end

  def decoded
    shortened_url = URI.parse(params[:url])
    url = Url.find_by(shortened: shortened_url.path[1..])
    if url.present? && shortened_url.to_s == url_encoded(url)
      render json: { url: url.original_url }, status: :ok
    else
      render status: :not_found
    end
  end

  private

  def url_encoded(url)
    "#{request.base_url}/#{url.shortened}"
  end
end
