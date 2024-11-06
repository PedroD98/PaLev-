class MenuItem < ApplicationRecord
  belongs_to :item
  belongs_to :menu
end
