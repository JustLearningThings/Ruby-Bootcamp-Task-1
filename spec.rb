# Testing

require 'rspec'

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
password = 'ruby_task_1'

RSpec.describe SpotifyAuthorization do
    context 'spotify authorization class'
        it 'returns an authorization code' do
            auth = SpotifyAuthorization.new(client_id, client_secret, redirect_uri, username, password)
            CODE = auth.request_spotify_authorization

            expect(CODE.length()).to be > 0
        end

        it 'returns an access token and a refresh token' do
            auth = SpotifyAuthorization.new(client_id, client_secret, redirect_uri, username, password)
            CODE = auth.request_spotify_authorization

            ACCESS_TOKEN, REFRESH_TOKEN = auth.request_tokens(CODE)

            expect(auth.check_tokens(ACCESS_TOKEN, REFRESH_TOKEN)).to be true
            expect(ACCESS_TOKEN.length()).to be > 0
            expect(REFRESH_TOKEN.length()).to be > 0
        end
end

RSpec.describe Spotify do
    it 'creates a playlist and returns its id' do
        auth = SpotifyAuthorization.new(client_id, client_secret, redirect_uri, username, password)
        CODE = auth.request_spotify_authorization
        ACCESS_TOKEN, REFRESH_TOKEN = auth.request_tokens(CODE)

        api = Spotify.new(username)
        playlist_id = api.create_playlist("My playlist for tests", auth)

        expect(playlist_id.length()).to be > 0
    end

    it 'gets the id of certain tracks' do
        auth = SpotifyAuthorization.new(client_id, client_secret, redirect_uri, username, password)
        CODE = auth.request_spotify_authorization
        ACCESS_TOKEN, REFRESH_TOKEN = auth.request_tokens(CODE)

        api = Spotify.new(username)

        expect(api.get_track_id('numb', auth).length()).to be > 0
    end

    # ...

    it 'outputs correct json from the Playlist class' do
        auth = SpotifyAuthorization.new(client_id, client_secret, redirect_uri, username, password)
        CODE = auth.request_spotify_authorization
        ACCESS_TOKEN, REFRESH_TOKEN = auth.request_tokens(CODE)

        api = Spotify.new(username)

        playlist_id = api.create_playlist("My playlist for tests 2", auth)

        snapshot_id = api.add_track_to_playlist(playlist_id, auth, 
            api.get_track_id('numb', auth),
            api.get_track_id('where is my mind', auth),
            api.get_track_id('deutschland', auth)
        )

        snapshot_id = api.reorder_track(0, 3, playlist_id, snapshot_id, auth)
        last_track = api.get_nth_track_from_playlist(-1, playlist_id, auth)
        snapshot_id = api.remove_track_from_playlist(playlist_id, snapshot_id, auth, last_track) if last_track

        playlist = Playlist.new(playlist_id, auth)
        output = playlist.json

        expected_json = {:name=>"My playlist for tests 2", :description=>"", :owner_name=>"ildedgd6c4eslo2v78c0e9prg", :spotify_url=>JSON.parse(output)['spotify_url'] }

        ts = playlist.tracks.map { |track|
            track = {
                name: track.name,
                artist_name: track.artist_name,
                album_name: track.album_name,
                spotify_url: track.spotify_url,
                id: track.id
            }
        }

        expected_json['tracks'] = ts
        expected_json = expected_json.to_json
        
        expect(output).to eq(expected_json)
    end
end