require 'dotenv/load'
require_relative './api'
require_relative './process'
require_relative './output'

class App
    include API
    include ProcessData
    include Output
end