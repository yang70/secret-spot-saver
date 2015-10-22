class SpotSerializer < ActiveModel::Serializer
  attributes :id,
             :user_id,
             :name,
             :lat,
             :lon,
             :water_type,
             :technique,
             :notes,
             :created_at,
             :updated_at
end
