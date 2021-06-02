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

  def self.unloanable(loan_date, quarantine_date)
    expected = self.expected(loan_date, quarantine_date).first
    actual = self.actual(loan_date, quarantine_date).first

    if actual
      actual.actual_return
    elsif expected && !expected.actual_return
      expected.expected_return
    else
      nil
    end

  end

  def self.lent(loan_date, quarantine_date)
    expected = self.expected(loan_date, quarantine_date).first
    actual = self.actual(loan_date, quarantine_date).first

    if actual
      actual
    elsif expected
      expected
    else
      nil
    end
  end

  scope :expected, -> (loan_date, quarantine_date) { where({ date: { '$lte' => loan_date }, expected_return: { '$gt' => quarantine_date }}).order_by(expected_return: :asc) }
  scope :actual, -> (loan_date, quarantine_date) { where({ date: { '$lte' => loan_date }, actual_return: { '$gt' => quarantine_date }}).order_by(actual_return: :asc) }


end
