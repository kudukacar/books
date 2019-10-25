require 'dotenv/load'
require_relative './api'
require_relative './process'

class App

    include API
    include ProcessData

end