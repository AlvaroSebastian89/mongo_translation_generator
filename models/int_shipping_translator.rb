class IntShippingTranslator
  include Mongoid::Document
  include Mongoid::Attributes::Dynamic
  store_in collection: 'int_shipping_translator'

  field :bsid, as: :bsaleId, type: Integer
  field :bsnm, as: :bsaleName, type: String
  field :cou, as: :courier, type: Hash

  def self.get_translations_by_zone_id(zone_id)
      response_format = {
        "_id": { "$toString" => "$_id" },
        "bsaleId": "$bsid",
        "bsaleName": "$bsnm",
        "couriers": "$cou"
      }
      pipeline = []
      pipeline.push({ "$match" => { bsid: zone_id } })
      pipeline.push({ "$project" => response_format })
      self.collection.aggregate(pipeline).first
  end

end