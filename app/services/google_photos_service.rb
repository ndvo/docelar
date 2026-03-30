# frozen_string_literal: true

class GooglePhotosService
  API_BASE = "https://photoslibrary.googleapis.com/v1".freeze

  def initialize(access_token)
    @access_token = access_token
  end

  def list_albums(page_size: 50)
    response = http_get("/albums", pageSize: page_size)
    JSON.parse(response.body).fetch("albums", [])
  end

  def list_photos(album_id:, page_size: 100, page_token: nil)
    body = {
      albumId: album_id,
      pageSize: page_size,
      fields: "mediaItems(id,baseUrl,mimeType,filename,mediaMetadata(width,height,creationTime))"
    }
    body[:pageToken] = page_token if page_token

    response = http_post("/albums/#{album_id}/mediaItems:search", body)
    JSON.parse(response.body)
  end

  def get_photo(media_item_id)
    response = http_get("/mediaItems/#{media_item_id}")
    JSON.parse(response.body)
  end

  def download_url(media_item)
    base_url = media_item["baseUrl"]
    mime_type = media_item["mimeType"]

    if mime_type.start_with?("image/")
      "#{base_url}=d"
    else
      base_url
    end
  end

  private

  def http_get(path, params = {})
    url = "#{API_BASE}#{path}"
    url += "?#{params.to_query}" if params.any?

    HTTP.get(url, headers: auth_headers)
  end

  def http_post(path, body = {})
    HTTP.post("#{API_BASE}#{path}", json: body, headers: auth_headers)
  end

  def auth_headers
    { "Authorization" => "Bearer #{@access_token}" }
  end
end
