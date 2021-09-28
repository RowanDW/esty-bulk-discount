class InvoiceItem < ApplicationRecord
  validates :quantity, :unit_price, :status, :created_at, :updated_at, presence: true

  belongs_to :item
  belongs_to :invoice

  enum status: [:pending, :packaged, :shipped]

  def self.incomplete_invoices
    invoice_ids = InvoiceItem.where("status = 0 OR status = 1").pluck(:invoice_id)
    Invoice.order(created_at: :asc).find(invoice_ids)
  end

  def self.on_merchant_invoice(invoice_id, merchant_id)
    invoice = Invoice.find(invoice_id)
    InvoiceItem.where(item_id: invoice.items.where(merchant_id: merchant_id), invoice_id: invoice_id)
               .order(:item_id)
  end

  def self.total_rev
    pennies = self.sum("unit_price * quantity")
    '%.2f' % (pennies / 100.0)
  end

  def item_rev
    (unit_price * quantity / 100.0)
  end

  def get_item
    Item.find(item_id)
  end

  def get_merch
    item.merchant
  end

  def price_dollars(mult = 1)
    '%.2f' % (unit_price * mult / 100.0)
  end

  def apply_discount
    disc = get_merch.get_discount(self)
    item_rev * ((100 - disc.percentage) / 100.0)
  end

  def self.discount_revenue
    result = self.sum do |ii|
      merch = ii.get_merch
      if merch.get_discount(ii).nil?
        ii.item_rev
      else
        ii.apply_discount
      end
    end
    '%.2f' % result
  end

end
