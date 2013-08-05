module CTM
  class Message < Base
    attr_reader :id, :account_id, :body, :callerid, :from, :to, :from_location, :to_location, :source_id, :direction

    def initialize(data, token=nil)
      super(data, token)
      @id            = data['id']
      @account_id    = data['account_id']
      @body          = data['body']
      @to            = data['to_number']
      @from          = data['from_number']
      @callerid      = data['callerid']
      @from_location = CTM::Base::Location.new(nil, data['from_city'], data['from_state'], data['from_country'], data['from_zip'])
      @to_location   = CTM::Base::Location.new(nil, data['to_city'], data['to_state'], data['to_country'], data['to_zip'])
      @source_id     = data['tracking_source_id']
      @direction  = data['direction']
    end

  end

end
