module CTM
  class Account < Base
    attr_reader :id
    attr_accessor :name, :status, :stats, :balance

    def initialize(data, token=nil)
      super(data, token)
      puts data.inspect
      @id = data['id']
      @name = data['name']
      @status = data['status']
      @stats = data['stats']['calls']
      if data['balance']
        @balance = "$" + (data['balance']['cents'].to_i / 100).to_s + "." + (data['balance']['cents'].to_i % 100).to_s
      end
    end

    def numbers(options={})
      CTM::NumberList.new(options.merge(account_id: @id), @token)
    end

    def receiving_numbers(options={})
      CTM::List.new('ReceivingNumber', options.merge(account_id: @id), @token)
    end

    def sources(options={})
      CTM::List.new('Source', options.merge(account_id: @id), @token)
    end

    def users(options={})
      CTM::List.new('User', options.merge(account_id: @id), @token)
    end

    def webhooks(options={})
      CTM::List.new('Webhook', options.merge(account_id: @id), @token)
    end

    def calls(options={})
      CTM::List.new('Call', options.merge(account_id: @id), @token)
    end

    def messages(options={})
      CTM::MessageList.new(options.merge(account_id: @id), @token)
    end

  end
end
