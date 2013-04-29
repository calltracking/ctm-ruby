module CTM
  class ReceivingNumberList < List
    def initialize(options={}, token=nil)
      super('ReceivingNumber', options, token)
      @account_id = options[:account_id]
      @number_id  = options[:number_id]
      if @number_id && @account_id
        @list_type_path = "accounts/#{@account_id}/numbers/#{@number_id}/#{@list_token_type}"
      elsif @account_id
        @list_type_path = "accounts/#{@account_id}/#{@list_token_type}"
      else
        @list_type_path = @list_token_type
      end
    end

    def add(receiving_number)
      path_str = "/api/v1/#{@list_type_path}/#{receiving_number.id}/add.json"
      res = self.class.post(path_str, :body => {}.merge(:auth_token => @token))
      if res && res['status'] == 'success'
        CTM::Number.new(res['receiving_number'], @token)
      else
        puts res.inspect
        raise CTM::Error::Add.new(res["reason"])
      end
    end

    def rem(receiving_number)
      path_str = "/api/v1/#{@list_type_path}/#{receiving_number.id}/rem.json"
      res = self.class.delete(path_str, :body => {}.merge(:auth_token => @token))
      if res && res['status'] == 'success'
        CTM::Number.new(res['receiving_number'], @token)
      else
        puts res.inspect
        raise CTM::Error::Add.new(res["reason"])
      end
    end

  end
end
