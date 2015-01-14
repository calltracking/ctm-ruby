module CTM
  class NumberList < List
    def initialize(options={}, token=nil)
      super('Number', options, token)
      @source_id = options[:source_id]
      if @source_id && @account_id
        @list_type_path = "accounts/#{@account_id}/sources/#{@source_id}/#{@list_token_type}"
      elsif @account_id
        @list_type_path = "accounts/#{@account_id}/#{@list_token_type}"
      else
        @list_type_path = @list_token_type
      end
    end

    # find a number within the given country/region and options like area_code or containing with contains
    def search(country_code, options={})
      options = {:country_code => country_code}.merge(options)
      path_str = "/api/v1/#{@list_type_path}/search.json"
      res = self.class.get(path_str, :query => options.merge(:auth_token => @token))
      data = res.parsed_response
      if data["status"] == "success"
        list_data = {'available_numbers' => data['results'].map {|res| res.merge('account_id' => @account_id) },
                     'page' => 1,
                     'per_page' => data['results'].size,
                     'total_entries' => data['results'].size}
        CTM::List.new('AvailableNumber', {:account_id => @account_id}, @token, list_data)
      else
        raise CTM::Error::List.new(data["error"])
      end
    end

    # buy number with the digits
    def buy(digits)
      path_str = "/api/v1/#{@list_type_path}.json"
      res = self.class.post(path_str, :body => {:phone_number => digits}.merge(:auth_token => @token))
      if res && res['status'] == 'success'
        CTM::Number.new(res['number'], @token)
      else
        puts res.inspect
        raise CTM::Error::Buy.new(res["reason"])
      end
    end

    # add trackng number to tracking source
    def add(number)
      path_str = "/api/v1/#{@list_type_path}/#{number.id}/add.json"
      #puts "Add to #{@account_id}:#{@source_id} -> #{number.id} -> #{path_str}"
      #         accounts/25          /sources/5012     /numbers
      # /api/v1/accounts/:account_id/sources/:source_id/numbers/:id/add
      res = self.class.post(path_str, :body => {}.merge(:auth_token => @token))
      if res && res['status'] == 'success'
        CTM::Source.new(res['source'], @token)
      else
        puts res.inspect
        raise CTM::Error::Add.new(res["reason"])
      end
    end

    # def rem(number)
    #   puts "Rem to #{@account_id}:#{@source_id} -> #{number.id} -> #{@list_type_path}"
    #   # /api/v1/accounts/:account_id/sources/:source_id/numbers/:id/rem
    # end

  end
end
