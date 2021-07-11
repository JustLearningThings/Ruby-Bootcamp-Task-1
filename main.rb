require 'rest-client'
require 'json'

require 'uri'
require 'cgi'

require_relative './authorization'
require_relative './spotify'


client_id = 'c40a305bf91f49e6a53c9256dead2be0'
client_secret = '3897ea5cb4fb4b358281c7e65aed4da7'
redirect_uri = 'https://spotify.com/'
username = 'ildedgd6c4eslo2v78c0e9prg'
password = 'ruby_task_1'

# Authorizing

auth = SpotifyAuthorization.new(client_id, client_secret, redirect_uri, username, password)

CODE = auth.request_spotify_authorization
ACCESS_TOKEN, REFRESH_TOKEN = auth.request_tokens(CODE)

puts "Acess token: #{ACCESS_TOKEN}"
puts "Refresh token: #{REFRESH_TOKEN}"
puts "Tokens check: #{auth.check_tokens(t1=ACCESS_TOKEN, t2=REFRESH_TOKEN)}"


# Creating a playlist

api = Spotify.new(username)
api.create_playlist(auth)