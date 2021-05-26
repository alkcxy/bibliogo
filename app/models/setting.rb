class Setting
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Attributes::Dynamic

  field :key, type: String
  field :value, type: String
end
