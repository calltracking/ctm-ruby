module CTM
  class TargetNumber < Base
    attr_reader :id, :account_id
    attr_accessor :name, :number, :display_number, :exact, :tracking_numbers

    def initialize(data, token=nil)
      super(data, token)
      @id               = data['id']
      @account_id       = data['account_id']
      @name             = data['name']
      @number           = data['number']
      @display_number   = data['display_number']
      @exact            = data['exact']
      @tracking_numbers = data['tracking_numbers']
    end

    def save
      options = {
        :name => @name,
        :number => @number
      }
      super(options)
    end

  end
end
