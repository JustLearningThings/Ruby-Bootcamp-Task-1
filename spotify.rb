require 'json'

class Spotify
    def initialize(user_id)
        @USER_ID = user_id
        @URL = "https://api.spotify.com/v1/users/#{@USER_ID}/playlists"
    end

    def create_playlist(auth)
        # constructing the request body and adding headers

        body = { name: 'My new playlist' }.to_json

        headers = { content_type: 'application/json' }
        auth.add_authorization_header(headers)
        
        response = RestClient.post @URL, body, headers
    end
end