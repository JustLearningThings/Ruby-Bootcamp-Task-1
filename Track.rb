class Track
    attr_reader :id, :name, :artist_name, :album_name, :spotify_url

    def initialize(id, name, artist_name, album_name, spotify_url)
        @id = id
        @name = name
        @artist_name = artist_name
        @album_name = album_name
        @spotify_url = spotify_url
    end
end