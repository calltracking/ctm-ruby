module CTM
  class Call < Base
    attr_reader :id

    def initialize(data, token=nil)
      super(data, token)
      @id        = data['id']
    end

  end
end
