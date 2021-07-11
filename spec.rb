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


client_id = 'c40a305bf91f49e6a53c9256dead2be0'
client_secret = '3897ea5cb4fb4b358281c7e65aed4da7'
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