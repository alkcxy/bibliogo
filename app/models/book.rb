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

end
