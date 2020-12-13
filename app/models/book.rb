class Book
  include Mongoid::Document
  field :title, type: String
  field :authors, type: Array
  field :year, type: Integer
  field :genre, type: String
  field :language, type: String
  field :spot, type: String
  field :isbn, type: Integer
  field :abstract, type: String
end
