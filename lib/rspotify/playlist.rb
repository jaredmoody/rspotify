module RSpotify

  class Playlist < Base

    # Returns Playlist object with user_id and id provided
    #
    # @param user_id [String]
    # @param id [String]
    # @return [Playlist]
    #
    # @example
    #           playlist = RSpotify::Playlist.find('wizzler', '00wHcTN0zQiun4xri9pmvX')
    #           playlist.class #=> RSpotify::Playlist
    #           playlist.name  #=> "Movie Soundtrack Masterpieces"
    def self.find(user_id, id)
      json = RSpotify.auth_get("users/#{user_id}/playlists/#{id}")
      Playlist.new json
    end

    # Spotify does not support search for playlists. Prints warning and returns false
    def self.search(*args)
      warn 'Spotify API does not support search for playlists'
      false
    end

    def initialize(options = {})
      @collaborative = options['collaborative']
      @description   = options['description']
      @followers     = options['followers']
      @images        = options['images']
      @name          = options['name']
      @public        = options['public']

      @owner = if options['owner']
        User.new options['owner']
      end

      @tracks = if options['tracks'] && options['tracks']['items']
        options['tracks']['items'].map { |t| Track.new t['track'] }
      end

      super(options)
    end

    def complete!
      initialize RSpotify.auth_get("users/#{@owner.id}/playlists/#{@id}")
    end
  end
end
