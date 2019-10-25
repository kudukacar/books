require 'json'

module ProcessData

    def process_books(data)
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