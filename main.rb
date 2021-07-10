require 'rest-client'
require 'json'

require 'uri'
require 'cgi'

require_relative './authorization'

# Authorizing

# expecting: client_id, client_secret, redirect_uri, username, password
auth = SpotifyAuthorization.new('c13ac4db8a744bd9b6febb4bb4a7724e', '6cbbbeaea23c4f45b1c682cb02fc26eb', 'https://spotify.com/','ildedgd6c4eslo2v78c0e9prg', 'ruby_task_1')

CODE = auth.request_spotify_authorization
ACCESS_TOKEN, REFRESH_TOKEN = auth.request_tokens(CODE)

puts "Acess token: #{ACCESS_TOKEN}"
puts "Refresh token: #{REFRESH_TOKEN}"
puts "Tokens check: #{auth.check_tokens(t1=ACCESS_TOKEN, t2=REFRESH_TOKEN)}"


