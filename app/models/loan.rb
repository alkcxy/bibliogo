class Loan
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Attributes::Dynamic

  field :date, type: DateTime
  field :expected_return, type: DateTime
  field :actual_return, type: DateTime
  field :place, type: String
  field :reader, type: String

  belongs_to :book
end
