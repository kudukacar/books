## Run the program
1. In your terminal, navigate to the project folder
2. Type the following in the terminal: gem install bundler
3. Type the following in the terminal after the above executes: bundle install
4. You need to register for a google books API key to search for books.  Follow these steps:
    1. Visit: https://developers.google.com/books/docs/v1/using
    2. Follow the instructions for acquiring and using an API key (make sure you get the API key and not the OAuth 2.0 credentials)
    3. Copy the API key
    4. In the terminal window within the project folder execute: 
        export GOOGLE_BOOKS_KEY=value
       where value is the pasted API key, without any spaces immediately before or after the =.  
5. Type the following in the terminal to run the program: ruby lib/app.rb
6. Type the following in the terminal to run the tests: bundle exec rspec spec

## Design considerations
The structure composes four modules(API, Interface, ProcessData, and Output), and three classes(User, Search, App)

### User
The User class reads and validates the input from the user, and records the user's reading list.  Separating this class from the App class gives us the flexibility to add functionality without affecting the structure of the program.  We extend User, with minimal structural effect on the program. 

### API
The API module requests data from the Google Books API.  With a separate module, we can easily add functionality as needed (ex. other request types) with minimal impact on the program. 

### Interface
The Interface module manages the interface with the user - printing and getting information from the console.  Separating this module gives us the flexibility to change the interface (ex. from command line to web app) with minimal impact on the program.

### ProcessData
The ProcessData module converts the API response into a hash, and extracts the necessary information.  Again, a separate module gives us the flexibility to change processing with minimal impact on the program.

### Search
The Search class gets and processes the search results.  Separating this class ensures the App class has only a single responsibility,run the app, making the program more maintainable and easier to test.

### Output
The Output module prints the information to stdout.  Similarly, separating this method gives us the flexibility to change output (ex. output to a file, etc) without changing the structure of the program.

### App
The App class combines all modules and classes to run the program. This class forms the board or engine, and the modules and other classes form the pieces.  We can easily change or interchange the pieces to accommodate change, producing a maintainable code environment. 