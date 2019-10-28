## Run the program
1. In your terminal, navigate to the project folder
2. Type the following in the terminal: gem install bundler
3. Type the following in the terminal after the above executes: bundle install
4. Type the following in the terminal to run the program: ruby lib/app.rb
5. Type the following in the terminal to run the tests: bundle exec rspec spec

## Design considerations
The structure composes three modules(API, ProcessData, and Output), and two classes(User, App)

### User
The User class reads and validates the input from the user, and records the user's reading list.  Separating this method from the App class gives us the flexibility to add functionality without affecting the structure of the program.  We extend User, with minimal structural effect on the program. 

### API
The API module requests data from the Google Books API.  With a separate module, we can easy add functionality as needed (ex. other request types) with minimal impact on the program.   

### ProcessData
The ProcessData module converts the response into a hash, and extracts the necessary information.  Again, a separate module gives us the flexibility to change processing with minimal impact on the program.

### Output
The Output module prints the information to stdout.  Similarly, separating this method gives us the flexibility to change output (ex. output to a file, etc) without changing the structure of the program.

### App
The App class combines all modules and classes to run the program. This class forms the board, and the modules and other class form the pieces.  We can easily change or interchange the pieces to accommodate change, producing a maintainable code environment. 