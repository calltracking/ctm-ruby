module CTM
  class ReceivingNumber < Base
    attr_reader :id, :account_id
    attr_accessor :name, :number, :formatted, :split

    def initialize(data, token=nil)
      super(data, token)
      @id         = data['id']
      @account_id = data['account_id']
      @name       = data['name']
      @number     = data['number']
      @formatted  = data['formatted']
      @split      = data['split']
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
