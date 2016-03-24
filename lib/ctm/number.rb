module CTM
  class Number < Base
    attr_reader :id, :account_id
    attr_accessor :name, :number, :formatted, :split, :routing

    def initialize(data, token=nil)
      super(data, token)
      @id         = data['id']
      @account_id = data['account_id']
      @name       = data['name']
      @number     = data['number']
      @formatted  = data['formatted']
      @split      = data['split']
      @routing    = data['routing']
    end

    def save
      options = {
        :name => @name,
      }
      super(options)
    end

    def receiving_numbers(options={})
      CTM::ReceivingNumberList.new(options.merge(:account_id => @account_id, :number_id => @id), @token)
    end

    def target_numbers(options={})
      CTM::TargetNumberList.new(options.merge(:account_id => @account_id, :number_id => @id), @token)
    end

    def source
    end

  end
end
