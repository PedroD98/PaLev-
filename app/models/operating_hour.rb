class OperatingHour < ApplicationRecord
  belongs_to :restaurant
  enum :day_of_week, { sunday: 0, monday: 1, tuesday: 2, wednesday: 3,
                       thursday: 4, friday: 5, saturday: 6, }

  validates :day_of_week, presence: true
  validates :closed, inclusion: { in: [true, false] }
  validates :open_time, :close_time, presence: true, unless: :closed?
end
