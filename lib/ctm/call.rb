module CTM
  class Call < Base
    ReadOnlyFields = [
      :id, :account_id, :search, :referrer, :location, :source,
      :likelihood, :duration, :talk_time, :ring_time, :called_at, :tracking_number, :business_number,
      :dial_status, :caller_number_split, :excluded, :tracking_number_format, :business_number_format,
      :caller_number_format, :audio, :tag_list, :latitude, :longitude, :extended_lookup, :sale
    ]
    ReadWriteFields = [
      :name, :email, :street, :city, :state, :country, :postal_code, :notes
    ]
    attr_reader *ReadOnlyFields 
    attr_accessor *ReadWriteFields

    # {"id":729485,"account_id":25,"name":"Escondido    Ca","search":null,"referrer":null,"location":null,"source":"Facebook","source_id":36,"likelihood":null,"duration":25,
    # "talk_time":10,"ring_time":15,"email":"tmacleod@stradegy.ca","street":"1600 Amphitheatre","city":"Escondido","state":"CA","country":"US","postal_code":"94043",
    # "called_at":"2013-05-01 11:48 PM -04:00","tracking_number_id":41,"tracking_number":"+17203584118","tracking_label":null,"business_number":"+14109759000","business_label":"Main Office",
    # "receiving_number_id":9,"dial_status":"completed","caller_number_split":["1","760","705","8888"],"excluded":false,"tracking_number_format":"(720) 358-4118",
    #"business_number_format":"(410) 975-9000","caller_number_format":"(760) 705-8888","alternative_number":"(760) 705-8888","caller_number_complete":"+17607058888",
    # "caller_number":"+17607058888","visitor":false,"audio":"https://calltrackingmetrics.com/accounts/ACe2a2cc9e29744544bfa706ba45ad9baf/recordings/RE18e40e5aad04e7a35da0b54ba47895da",
    # "tag_list":["follow up"],"notes":"","latitude":33.0879,"longitude":-117.116,"extended_lookup_on":false,"extended_lookup":{"first_name":"","last_name":"","name_type":"","phone_type":"0","business_name":null,"street_number":"1600","street_name":"Amphitheatre","city":"Mountain View","state":"CA","zipcode":"94043"}}
    def initialize(data, token=nil)
      super(data, token)
      ReadOnlyFields.each do|field|
        instance_variable_set("@#{field}", data[field.to_s])
      end
      ReadWriteFields.each do|field|
        instance_variable_set("@#{field}", data[field.to_s])
      end
    end

    def record_sale(sale_detail)
      path_str = "/api/v1/#{@list_type_path}/#{self.id}/sale_record.json"
      post_options = {}
      sale_detail.each do|k,v|
        post_options["service_rep_call[#{k}]"] = v
      end
      res = self.class.post(path_str, :body => post_options.merge(:auth_token => @token))
      (res && res['status'] == 'success')
    end

    def update_sale(sale_detail)
    end

  end
end
