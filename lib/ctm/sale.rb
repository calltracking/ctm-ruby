module CTM
  class Sale < Base
    ReadWriteFields = [:conversion,
                       :sale_date,        :score,
                       :service_rep_name, :value]

    attr_reader :call_id
    attr_accessor(*ReadWriteFields)

    def initialize(data, token=nil)
      super(data, token)

      [ :call_id, *ReadWriteFields].each do |k|
        instance_variable_set "@#{k}", data[k.to_s]
      end
    end

    def name
      @service_rep_name
    end

    def name=(n)
      @service_rep_name = n
      @service_rep_name
    end

    def release!
      path_str ="/api/v1/#{@list_type_path}/#{@call_id}/sale.json"
      res = self.class.delete path_str, body: {auth_token: @token}
      res.parsed_response
    end

    def save(options = {})
      path_str = "/api/v1/#{@list_type_path}/#{@call_id}/sale.json"
      options = {}
      ReadWriteFields.each do |k|
        v = self.send k
        case k.to_s
        when 'conversion' then v = v ? 'on' : 'off'
        when 'service_rep_name' then k = :name
        end
        options[k] = v
      end
      options[:id] = @call_id

      #self.class.debug_output $stderr
      res = self.class.post path_str, body: options.merge(auth_token: @token)
      #self.class.debug_output nil
      return nil unless res
      (res['status'] == 'success') ? true : (res['message'] || res['reason'])
    end

  end
end
