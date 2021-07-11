require 'json'

require_relative "./Track.rb"

class Playlist
    attr_reader :id, :name, :description, :owner_name, :spotify_url, :tracks

    def initialize(playlist_id, auth)
        headers = { content_type: 'application/json' }
        auth.add_authorization_header(headers)

        url = "https://api.spotify.com/v1/playlists/#{playlist_id}?market=from_token"

        response = RestClient.get url, headers
        response = JSON.parse(response)

        # defining instance variables

        @id = response['id']
        @name = response['name']
        @description = response['description']
        @owner_name = response['owner']['id']
        @spotify_url = response['external_urls']['spotify']

        # creating instances of Tracks

        @tracks = []

        response['tracks']['items'].each { |track| 
            t = track['track']

            t = Track.new(t['id'],
                          t['name'],
                          t['artists'][0]['name'],
                          t['album']['name'],
                          t['external_urls']['spotify'])

            tracks.append(t)
        }
    end

    def info()
        puts "Playlist name: #{@name}"
        puts "Playlist ID: #{@id}"
        puts "Description: #{@description}"
        puts "Owner: #{@owner_name}"
        puts "URL: #{@spotify_url}"
        
        puts "Tracks:"
        @tracks.each { |track| puts track.name }
    end

    def json()
        playlist_hash = {
            name: @name,
            description: @description,
            owner_name: @owner_name,
            spotify_url: @spotify_url,
        }

        # format tracks and add them to the hash

        ts = @tracks.map { |track|
            track = {
                name: track.name,
                artist_name: track.artist_name,
                album_name: track.album_name,
                spotify_url: track.spotify_url,
                id: track.id
            }
        }

        playlist_hash['tracks'] = ts
        playlist_hash.to_json
    end
end