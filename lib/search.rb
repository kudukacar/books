require "dotenv/load"
require_relative "./api"
require_relative "./process"

class Search
  include API 
  include ProcessData

  def initialize(max_results, query)
    @max_results = max_results
    @query = query
  end

  def search_results
    data = get_books(search_params)
    process_books(data)
  end

  private
  def search_params
    api_key = ENV["GOOGLE_BOOKS_KEY"]
    params = { 
      "q" => @query, 
      "maxResults" => @max_results, 
      "key" => api_key 
    }
  end
end