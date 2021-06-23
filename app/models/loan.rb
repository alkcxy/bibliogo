class Loan
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Attributes::Dynamic

  field :date, type: Date
  field :expected_return, type: Date
  field :actual_return, type: Date
  field :place, type: String
  field :reader, type: String

  belongs_to :book

  validates_presence_of :date
  validates_presence_of :expected_return
  validates_presence_of :place
  validates_presence_of :reader

  paginates_per 2 if Rails.env.development?

  scope :active, -> (loan_date, return_date) {
    any_of(
      { date: { '$gte' => loan_date, '$lte' => return_date }}, 
      { date: { '$lte' => loan_date }, expected_return: { 'gte' => return_date }, actual_return: nil}, 
      { date: { '$lte' => loan_date }, actual_return: { 'gte' => return_date }},
      { expected_return: { '$gte' => loan_date, '$lte' => return_date }, actual_return: nil },
      { actual_return: { '$gte' => loan_date, '$lte' => return_date }}
    )
    .order_by(actual_return: :desc, expected_return: :desc)
  }
  scope :status, -> (day, quarantine_duration) { 
    any_of(
      { date: { '$lte' => day }, actual_return: nil}, 
      { date: { '$lte' => day }, actual_return: { '$gte' => quarantine_duration.before(day) }},
    )
    .order_by(actual_return: :desc, expected_return: :desc)
  }
  scope :late, -> (day) {
    where(actual_return: nil, expected_return: { '$lte' => day })
  }

end
