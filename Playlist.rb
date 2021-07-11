class playlist
    def initialize(id, name, description, owner_name, spotify_url, *tracks)
        @id = id
        @name = name
        @description = description
        @owner_name = owner_name
        @spotify_url = spotify_url
        @tracks = tracks
    end
end