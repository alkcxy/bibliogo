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

  def self.unloanable(loan_date, quarantine_date)
    expected = self.expected(loan_date, quarantine_date).first
    actual = self.actual(loan_date, quarantine_date).first

    if expected && (actual && expected.expected_return < actual.actual_return || !actual) && expected != actual
      expected.expected_return
    elsif actual
      actual.actual_return
    else
      nil
    end

  end

  def self.lent(loan_date, quarantine_date)
    expected = self.expected(loan_date, quarantine_date).first
    actual = self.actual(loan_date, quarantine_date).first

    if expected && (actual && expected.expected_return < actual.actual_return || !actual) && expected != actual
      expected
    elsif actual
      actual
    else
      nil
    end
  end

  scope :expected, -> (loan_date, quarantine_date) { where({ date: { '$lte' => loan_date }, expected_return: { '$gte' => quarantine_date }}).order_by(expected_return: :asc) }
  scope :actual, -> (loan_date, quarantine_date) { where({ date: { '$lte' => loan_date }, actual_return: { '$gte' => quarantine_date }}).order_by(actual_return: :asc) }


end
