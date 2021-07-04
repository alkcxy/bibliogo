class Sequence
  include Mongoid::Document
  include Mongoid::Timestamps
  
  field :key, type: String
  field :value, type: Integer

  validates_presence_of :key
  validates_presence_of :value
  validates :value, uniqueness: { scope: :key }

  index({ value: 1 }, { unique: false })

  scope :max_sequence, -> (key) { Book.where(key: key).order_by({ value: :desc }).limit(1) }

  def self.create_sequence(key, value)
    seq = Sequence.max_sequence(key).first
    value = seq.value + 1 if !seq.nil?
    Sequence.create(key: key, value: value)
  end
end
