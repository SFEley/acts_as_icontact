module ActsAsIcontact
  # Returns an instance of RestClient::Resource with iContact authentication headers. All other
  # resource classes build from this method. Throws an ActsAsIcontact::ConfigError if the username
  # or password are missing from configuration.
  #
  # (Author's Note: I'm not especially thrilled with this name, since it implies some sort of keepalive
  # or other persistent state.  I'd rather call this 'client' -- but that's already a bit overloaded 
  # within iContact's nomenclature.  And calling it 'server' got _me_ confused.  This is the best of a 
  # motley array of possibilities.)
  def self.connection
    @connection or begin
      raise ConfigError, "Username is required" unless Config.username
      raise ConfigError, "Password is required" unless Config.password
      @connection = RestClient::Resource.new(Config.url, :headers => {
        :accept => Config.content_type,
        :content_type => Config.content_type,
        :api_version => Config.api_version,
        :api_appid => Config.app_id,
        :api_username => Config.username,
        :api_password => Config.password
      })
    end
  end
  
  # Clears the connection object from memory.  This will force a reload the next time it's accessed.
  # Because nothing is directly cached within the client, the only likely reason to do this is if
  # the username and password are changed.  Also resets the account subresource.
  def self.reset_connection!
    reset_account!
    @connection = nil
  end
end
