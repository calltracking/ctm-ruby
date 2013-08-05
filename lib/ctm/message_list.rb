module CTM
  class MessageList < List
    def initialize(options={}, token=nil)
      super('Message', options, token)
      @list_type_path = "accounts/#{@account_id}/sms"
    end

    def send_message(to, from, message)
      options = {:to => to, :from => from, :msg => message}
      path_str = "/api/v1/#{@list_type_path}.json"
      res = self.class.post(path_str, :body => options.merge(:auth_token => @token))
      data = res.parsed_response
      puts data.inspect
      (data["status"] == "processing")
    end

  end
end
