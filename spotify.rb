require 'json'

class Spotify
    def initialize(user_id)
        @USER_ID = user_id
        @CREATE_PLAYLIST_URL = "https://api.spotify.com/v1/users/#{@USER_ID}/playlists"
    end

    # returns the created playlist's id
    def create_playlist(name, auth)
        # constructing the request body and adding headers

        body = { name: name }.to_json

        headers = { content_type: 'application/json' }
        auth.add_authorization_header(headers)
        
        response = RestClient.post @CREATE_PLAYLIST_URL, body, headers

        #returning the playlist id

        response = JSON.parse(response)
        response['id']
    end

    # searches for a track by its name and returns its id
    def get_track_id(name, auth)
        # adding headers

        headers = { content_type: 'application/json' }
        auth.add_authorization_header(headers)

        url = "https://api.spotify.com/v1/search?q=#{name}&type=track&limit=1"

        response = RestClient.get url, headers

        # returning the track id

        response = JSON.parse(response)
        tracks = response['tracks']['items']

        return tracks.empty? ? false : tracks[0]['id']
    end

    # returns the playlist's new snapshot id
    def add_track_to_playlist(playlist_id, auth, *items)
        # constructing the request body and adding headers

        items.map! { |uri| uri.prepend("spotify:track:") }
        body = { uris: items }.to_json

        headers = { content_type: 'application/json' }
        auth.add_authorization_header(headers)

        url = "https://api.spotify.com/v1/playlists/#{playlist_id}/tracks"

        response = RestClient.post url, body, headers
        
        response = JSON.parse(response)
        response['snapshot_id']
    end

    def reorder_track(range_start, insert_before, playlist_id, snapshot_id, auth)
        # constructing the request body and adding headers

        body = { range_start: range_start, insert_before: insert_before }.to_json

        headers = { content_type: 'application/json' }
        auth.add_authorization_header(headers)

        url = "https://api.spotify.com/v1/playlists/#{playlist_id}/tracks"

        response = RestClient.put url, body, headers
        
        response = JSON.parse(response)
        response['snapshot_id']
    end
end