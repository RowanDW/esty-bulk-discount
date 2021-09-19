class Item < ApplicationRecord
  belongs_to :merchant
  has_many :invoice_items
  has_many :invoices, through: :invoice_items
  validates :name, :description, :unit_price, presence: true
  enum status: [:disabled, :enabled]

  def price_dollars(quantity = 1)
    '%.2f' % (unit_price * quantity / 100.0)
  end

  def unit_price_dollars
    "%.2f" % (unit_price / 100.0)
  end
end
