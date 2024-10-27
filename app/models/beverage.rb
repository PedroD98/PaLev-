class Beverage < Item
  validates :alcoholic, inclusion: { in: [true, false] }
end