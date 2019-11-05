require "json"

module ProcessData
  def process_books(data)
    return data if !data

    total = JSON.parse(data)["totalItems"]
    return [] if total == 0

    books = JSON.parse(data)["items"]
    books.map do |book|
      {
        "title" => book["volumeInfo"]["title"],
        "authors" => book["volumeInfo"]["authors"],
        "publisher" => book["volumeInfo"]["publisher"]
      }
    end
  end
end