class BulkDiscount < ApplicationRecord
  validates :percentage, :quantity, presence: true

  belongs_to :merchant
end
