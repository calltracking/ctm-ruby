module CTM
  class Account < Base
    attr_reader :id
    attr_accessor :name, :status, :stats, :balance

    # {"id"=>25, "name"=>"CallTrackingMetrics", "user_role"=>"admin", "status"=>"active",
    # "stats"=>{"calls"=>{"2013-04-18"=>3, "2013-04-25"=>1}, "tracking_numbers"=>48},
    # "url"=>"http://ctmdev.co/api/v1/accounts/25.json", "balance"=>{"cents"=>23739, "currency"=>"USD", "precision"=>2}}
    def initialize(data, token=nil)
      super(data, token)
      @id = data['id']
      @name = data['name']
      @status = data['status']
      @stats = data['stats']['calls']
      @balance = "$" + (data['balance']['cents'].to_i / 100).to_s + "." + (data['balance']['cents'].to_i % 100).to_s
    end

    def numbers(options={})
      CTM::NumberList.new(options.merge(:account_id => @id), @token)
    end

    def receiving_numbers(options={})
      CTM::List.new('ReceivingNumber', options.merge(:account_id => @id), @token)
    end

    def sources(options={})
      CTM::List.new('Source', options.merge(:account_id => @id), @token)
    end

    def users(options={})
      CTM::List.new('User', options.merge(:account_id => @id), @token)
    end

    def webhooks(options={})
      CTM::List.new('Webhook', options.merge(:account_id => @id), @token)
    end
  end
end
