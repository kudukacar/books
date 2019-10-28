require "rest-client"

module API
  def get_books(params)
    url = "https://www.googleapis.com/books/v1/volumes"
    RestClient.get(url, params: params) rescue false
  end
end