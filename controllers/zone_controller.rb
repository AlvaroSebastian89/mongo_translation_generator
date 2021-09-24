
class ZoneController

  def self.process()
    begin
      active_list = [0, 1]
      zone_list = []
      active_list.each do |active|
        zones = get_zones(active)
        zone_list << zones
      end
      return zone_list.flatten
    rescue Exception => e
      p e.message
      p e.backtrace
      { :success => false, :error => e.message }
    end
  end

  def self.get_zones(active)
    zones = []
    response = {}
    data_remaining = true
    limit  = 50
    offset = 0
    base_url = "#{$settings['bshipping_courier_api']}/v3/admin/shipping_zones.json"

    begin
      3.times do
        while data_remaining do
          url = base_url + "?mkId=#{$mk_id}&active=#{active}&limit=#{limit}&offset=#{offset}"
          response = Api.call(url, { :method => 'GET', :headers => { :access_token => $access_token } })
          response[:data].each do |element|
            zones.push(element)
          end if response[:success]
          data_remaining = false if response[:next].nil?
          offset += limit
        end
        break if response[:success]
      end
      return zones
    rescue Exception => e
      p e.message
      p e.backtrace
      { :success => false, :error => e.message }
    end
  end

end