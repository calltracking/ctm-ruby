module CTM
  class Auth
    include HTTParty
    base_uri ENV["CTM_URL"] || "api.calltrackingmetrics.com"

    def self.token=(token)
      @token = token
    end

    def self.token
      @token
    end

    def self.authenticate(token, secret)
      res = self.post("/api/v1/authentication", :body => {:token => token, :secret => secret})
      if res.parsed_response && res.parsed_response['success']
        CTM::Token.new(res.parsed_response)
      else
        raise CTM::Error::Auth.new("Failed to authenticate")
      end
    end

  end
end
