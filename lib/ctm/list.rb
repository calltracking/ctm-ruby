# Generic List Object to handle paginated lists of objects
module CTM
  class List
    include Enumerable

    include HTTParty
    base_uri ENV["CTM_URL"] || "api.calltrackingmetrics.com"

    attr_reader :list_type, :token, :per_page, :page, :total_entries, :objects

    # e.g. Account, token
    def initialize(list_type, options={}, token=nil, fetched_objects=nil)
      @list_type = list_type
      @list_token_type = list_type.underscore.pluralize
      @object_klass = CTM.module_eval(list_type)
      @token = token || CTM::Auth.token
      @account_id = options[:account_id]
      if @account_id
        @list_type_path = "accounts/#{@account_id}/#{@list_token_type}"
      else
        @list_type_path = @list_token_type
      end

      @fetched_objects = fetched_objects
      @options = options
    end

    def each &block
      load_records
      @objects.each do |obj|
        if block_given?
          block.call obj
        else
          yield obj
        end
      end
    end

    def create(options)
      @object_klass.create(options.merge(list_type_path: @list_type_path,
                                         list_token_type: @list_token_type,
                                         account_id: @account_id,
                                         token: @token))
    end

    def find(options)
      first_name = options.delete(:first_name)
      last_name  = options.delete(:last_name)
      options[:filter] = options.delete(:filter) || "#{first_name} #{last_name}".strip if first_name || last_name

      fetch_page(options)
      self
    end

    def get(recordid, options={})
      path_str = "/api/v1/#{@list_type_path}/#{recordid}.json"
      res = self.class.get(path_str, query: options.merge(auth_token: @token))
      data = res.parsed_response
      @object_klass.new(data, @token) 
    end

  protected

    def load_records
      if @fetched_objects
        map_data(@fetched_objects)
      else
        fetch_page(@options)
      end
    end

    def fetch_page(options={})
      options = {per_page: 10, page: 1}.merge(options)
      path_str = "/api/v1/#{@list_type_path}.json"
      res = self.class.get(path_str, query: options.merge(auth_token: @token))
      data = res.parsed_response
      if data["status"] && data["status"] == "error"
        puts data.inspect
        raise CTM::Error::List.new(data["message"] || data["reason"])
      end
      map_data(data)
    end

    def map_data(data)
      @page = data['page']
      @per_page = data['per_page']
      @total_entries = data['total_entries']
      @objects = data[@list_token_type].map {|obj|
        @object_klass.new(obj, @token) 
      }
    end

  end
end
