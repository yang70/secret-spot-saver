class SpotSerializer < ActiveModel::Serializer
  attributes :id,
             :name,
             :lat,
             :lon,
             :water_type,
             :technique,
             :notes,
             :created_at,
             :updated_at
end
