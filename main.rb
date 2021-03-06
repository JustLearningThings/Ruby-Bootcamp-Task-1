require 'rest-client'
require 'json'

require 'uri'
require 'cgi'

require_relative './authorization'
require_relative './spotify'

require_relative './Playlist'
require_relative './Track'


client_id = '86464fc5407f450bb57726f91ac91990'
client_secret = '66a6a0bedb31489bbb4e45d4bb6e9182'
redirect_uri = 'https://spotify.com/'
username = 'ildedgd6c4eslo2v78c0e9prg'
password = 'ruby_task_1' # normally kept in an environment variable !

# Authorizing

auth = SpotifyAuthorization.new(client_id, client_secret, redirect_uri, username, password)

CODE = auth.request_spotify_authorization
ACCESS_TOKEN, REFRESH_TOKEN = auth.request_tokens(CODE)

puts "Acess token: #{ACCESS_TOKEN}"
puts "Refresh token: #{REFRESH_TOKEN}"
puts "Tokens check: #{auth.check_tokens(t1=ACCESS_TOKEN, t2=REFRESH_TOKEN)}"


# Creating a playlist

api = Spotify.new(username)
playlist_id = api.create_playlist("My new playlist", auth)

# Adding some tracks to the created playlist

snapshot_id = api.add_track_to_playlist(playlist_id, auth, 
    api.get_track_id('numb', auth),
    api.get_track_id('where is my mind', auth),
    api.get_track_id('deutschland', auth)
)

# Place the first track at the end of the playlist

snapshot_id = api.reorder_track(0, 3, playlist_id, snapshot_id, auth)

# Delete the last track
last_track = api.get_nth_track_from_playlist(-1, playlist_id, auth)

snapshot_id = api.remove_track_from_playlist(playlist_id, snapshot_id, auth, last_track) if last_track

# Instanciating a Playlist
playlist = Playlist.new(playlist_id, auth)
playlist.info
puts playlist.json