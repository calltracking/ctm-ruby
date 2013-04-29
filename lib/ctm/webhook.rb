module CTM
  class Webhook < Base
    attr_reader :id
    attr_accessor :weburl, :with_resource_url, :position

    def initialize(data, token=nil)
      super(data, token)
      @id                = data['id']
      @weburl            = data['weburl']
      @with_resource_url = data['with_resource_url']
      @position          = data['position']
    end

  end
end
