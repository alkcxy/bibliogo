class Book
  include Mongoid::Document
  include Mongoid::Timestamps

  field :title, type: String
  field :authors, type: Array
  field :year, type: Integer
  field :genre, type: String
  field :language, type: String
  field :spot, type: String
  field :isbn, type: String
  field :abstract, type: String
  field :code, type: Integer
  field :catalogue, type: String

  has_many :loans

  paginates_per 2 if Rails.env.development?

  index({ code: 1 }, { unique: true, language_override: "lang", default_language: "it" })
  index({ year: 1 }, { unique: false, language_override: "lang", default_language: "it" })
  index({ "$**": "text" }, { language_override: "lang", default_language: "it" })

  validates :code, uniqueness: { case_sensitive: false }
  validates_presence_of :code
  validates_presence_of :title
  validates_presence_of :authors
  validates_presence_of :spot
  validates_presence_of :isbn

  scope :late, -> (day) { Book.where({ id: { "$in" => Loan.late(day).pluck(:book_id).uniq }})}

  scope :max_code, -> () { Book.order_by({ code: :desc }).limit(1) }

  def self.next_code
    value = nil
    key = self.name
    if Sequence.max_sequence(key).first.nil?
      book = max_code.first
      value = book.nil? ? 1 : book.code + 1
    end
    sequence = Sequence.create_sequence(key, value)
    sequence.value
  end

end
