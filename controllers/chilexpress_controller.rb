
class ChilexpressController

  def self.process()
    begin
      zones = []

      regions = get_regions()
      regions[:regions].each do |region|
        coverage = get_coverage(region[:regionId])
        zones << coverage[:coverageAreas]
      end

      return zones.flatten
    rescue Exception => e
      p e.message
      p e.backtrace
      { :success => false, :error => e.message }
    end
  end

  def self.get_regions()
    begin
      url = "#{$settings['chilexpress_api']}/georeference/api/v1.0/regions"
      regions = Api.call(url, {
        :method => 'GET',
        :headers => { 'Ocp-Apim-Subscription-Key': $settings['chilexpress_api'] }
      })
      return regions
    rescue Exception => e
      p e.message
      p e.backtrace
      { :success => false, :error => e.message }
    end
  end

  def self.get_coverage(region_id)
    begin
      url = "#{$settings['chilexpress_api']}/georeference/api/v1.0/coverage-areas?RegionCode=#{region_id}&type=0"
      coverage = Api.call(url, {
        :method => 'GET',
        :headers => { 'Ocp-Apim-Subscription-Key': $settings['chilexpress_api'] }
      })
      return coverage
    rescue Exception => e
      p e.message
      p e.backtrace
      { :success => false, :error => e.message }
    end
  end

end