module CTM
  class Token
    attr_reader :token, :expires

    def initialize(data)
      @token = data['token']
      @expires = data['expires']
    end

    def accounts(options={})
      CTM::List.new('Account', options, @token)
    end

  end
end
