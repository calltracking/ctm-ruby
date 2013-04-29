module CTM
  class Base
    include HTTParty
    base_uri ENV["CTM_URL"] || "api.calltrackingmetrics.com"

    attr_reader :token, :account_id


    def initialize(data, token=nil)
      @token = token || CTM::Auth.token
      @account_id = data['account_id']
      @list_token_type = self.class.to_s.sub(/CTM::/,'').underscore.pluralize
      if @account_id
        @list_type_path = "accounts/#{@account_id}/#{@list_token_type}"
      else
        @list_type_path = @list_token_type
      end
    end

    def save(options={})
      puts "save: #{options.inspect}"
      path_str = "/api/v1/#{@list_type_path}/#{@id}.json"
      res = self.class.put(path_str, :body => options.merge(:auth_token => @token))
    end

    def release!
      path_str = "/api/v1/#{@list_type_path}/#{@id}.json"
      res = self.class.delete(path_str, :body => {:auth_token => @token})
    end

    def self.create(options)
      list_type_path = options.delete(:list_type_path)
      list_token_type = options.delete(:list_token_type)
      account_id = options.delete(:account_id)
      token = options.delete(:token)
      path_str = "/api/v1/#{list_type_path}.json"
      puts "create: #{self} -> #{options.inspect}"
      res = self.post(path_str, :body => options.merge(:auth_token => token))
      puts "result: #{res.parsed_response.inspect}"
      puts "properties: #{list_type_path.inspect} -> #{list_token_type.inspect} -> #{account_id}"
      if res.parsed_response['status'] == 'error'
        raise CTM::Error::Create.new(res.parsed_response['reason'])
      else
        self.new(res.parsed_response[list_token_type.singularize], token)
      end
    end

  end
end
