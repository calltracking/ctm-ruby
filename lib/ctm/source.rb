module CTM
  class Source < Base
    attr_reader :id, :account_id
    attr_accessor :name, :referring_url, :landing_url, :position, :online, :crm_tag

    def initialize(data, token=nil)
      super(data, token)
      @id            = data['id']
      @account_id    = data['account_id']
      @name          = data['name']
      @referring_url = data['referring_url']
      @landing_url   = data['landing_url']
      @position      = data['position']
      @online        = data['online']
      @crm_tag       = data['crm_tag']
    end

    def save
      options = {
        :name          => @name,
        :position      => @position,
        :online        => @online,
        :referring_url => @referring_url,
        :landing_url   => @landing_url,
        :source_tag    => @crm_tag
      }
      super(options)
    end

    def numbers(options={})
      CTM::NumberList.new(options.merge(:account_id => @account_id, :source_id => @id), @token)
    end

  end
end
