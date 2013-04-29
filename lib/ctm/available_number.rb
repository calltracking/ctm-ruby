module CTM
  class AvailableNumber < Base
    attr_reader :friendly_name, :latitude, :longitude, :rate_center, :lata, :region, :postal_code, :iso_country, :phone_number

    def initialize(data, token=nil)
      super(data, token)
      @friendly_name = data['friendly_name']
      @latitude = data['latitude']
      @longitude = data['longitude']
      @lata = data['lata']
      @region = data['region']
      @postal_code = data['postal_code']
      @iso_country = data['iso_country']
      @phone_number = data['phone_number']
    end

  end
end
