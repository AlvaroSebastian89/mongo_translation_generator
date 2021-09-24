
class TranslationController

  def self.process()
    begin
      zones = ZoneController.process
      chilexpress_zones = ChilexpressController.process

      p "Bsale zones"
      p zones.count
      p "Chilexpress zones"
      p chilexpress_zones.count

      chilexpress_codes = []

      zones.each do |zone|
        zone_name = I18n.transliterate(zone[:name].downcase.strip)
        cz = chilexpress_zones.select {|cz| I18n.transliterate(cz[:coverageName].downcase.strip) == zone_name}.first

        # Validar si la zona es una localidad
        if cz.nil? && zone_name.include?('-')
          locality = zone_name.split('-')[1].strip
          cz = chilexpress_zones.select {|cz| I18n.transliterate(cz[:coverageName].downcase.strip) == locality}.first
        end

        next if cz.nil?
        chilexpress_codes << cz
        createTranslations(zone, cz)
      end

      rejected_zones = chilexpress_zones - chilexpress_codes
      p 'rejected_zones'
      p rejected_zones
      p 'rejected_zones count'
      p rejected_zones.count

    rescue Exception => e
      p e.message
      p e.backtrace
      { :success => false, :error => e.message }
    end
  end

  def self.createTranslations(zone, cz)
    begin
      chilexpress_code = {
        # * El ID puede variar entre instancias, por eso se decidió compararlo por nombre
        # bsid: zone[:id],
        bsnm: zone[:name],
        cou: {
          chilexpress: cz[:countyCode]
          # starken: nil # todo: dejar en nil si el courier no trabaja con esta zona
        }
      }
      IntShippingTranslator.create!(chilexpress_code).as_json
    rescue Exception => e
      p e.message
      p e.backtrace
    end
  end

end