class OperatingHour < ApplicationRecord
  belongs_to :restaurant
  enum :day_of_week, { sunday: 0, monday: 1, tuesday: 2, wednesday: 3,
                       thursday: 4, friday: 5, saturday: 6, }
  before_validation :opening_time_must_be_before_closing

  validates :day_of_week, presence: true
  validates :closed, inclusion: { in: [true, false] }
  validates :open_time, :close_time, presence: true, unless: :closed?

  private

  def opening_time_must_be_before_closing
    if self.open_time && self.close_time && self.open_time >= self.close_time
      self.errors.add(:close_time, 'O horário de abertura deve ser anterior ao fechamento.')
    end
  end
end
