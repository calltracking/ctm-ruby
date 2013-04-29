module CTM
  class User < Base
    attr_reader :id
    attr_accessor :first_name, :last_name, :email, :role

    def name
      "#{first_name} #{last_name}"
    end

    def initialize(data, token=nil)
      super(data, token)
      @id         = data['id']
      @first_name = data['first_name']
      @last_name  = data['last_name']
      @email      = data['email']
      @role       = data['role']
    end

    def save
      options = {
        :first_name => @first_name,
        :last_name => @last_name,
        :email => @email,
        :role => @role
      }
      super(options)
    end

  end
end
