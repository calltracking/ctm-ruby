# Generic List Object to handle paginated lists of objects
module CTM
  class List
    include Enumerable

    include HTTParty
    base_uri "https://#{(ENV["CTM_URL"] || "api.calltrackingmetrics.com")}"

    attr_reader :list_type, :token, :total_entries, :objects
    attr_reader :per_page, :page, :total_pages

    attr_reader :filters

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
      @filters = {}
      load_records
    end

    def page=(num)
      @options[:page] = num.to_i
      fetch_page(@options) unless @options[:page] == @page
      @page
    end

    def each_page
      # Trick to allow .each_page.each_with_index from:
      # http://stackoverflow.com/a/18089712
      return to_enum(:each_page) unless block_given?

      1.upto(@total_pages) do |pnum|
        self.page = pnum
        yield self
      end
    end

    def each
      return to_enum(:each) unless block_given?
      load_records
      @objects.each do |obj|
        yield obj
      end
    end

    def create(options)
      @object_klass.create(options.merge(list_type_path: @list_type_path,
                                         list_token_type: @list_token_type,
                                         account_id: @account_id,
                                         token: @token))
    end

    def find(options = {})
      return self unless options.class == Hash

      first_name = options.delete(:first_name)
      last_name  = options.delete(:last_name)
      options[:filter] = options.delete(:filter) || "#{first_name} #{last_name}".strip if first_name || last_name

      @filters = options

      self.page = 1
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
      options = {per_page: 10, page: 1}.merge(options).merge(@filters)
      path_str = "/api/v1/#{@list_type_path}.json"
      res = self.class.get(path_str, query: options.merge(auth_token: @token))
      data = res.parsed_response
      if data["status"] && data["status"] == "error"
        puts data.inspect
        raise CTM::Error::List.new(data["message"] || data["reason"])
      end

      @page = options[:page]
      @per_page = options[:per_page]
      map_data(data)
    end

    def map_data(data)
      @total_entries = data['total_entries']
      @total_pages   = data['total_pages']
      @objects       = (data[@list_token_type]||[]).map {|obj|
        @object_klass.new(obj, @token)
      }
    end

  end
end
