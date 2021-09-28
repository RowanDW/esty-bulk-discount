require 'rails_helper'

RSpec.describe 'Merchant invoices show page' do
  before :each do
    allow_any_instance_of(GithubService).to receive(:get_data).and_return("haha")
    allow_any_instance_of(GithubService).to receive(:pulls).and_return({one: 1, two: 2 })
    allow_any_instance_of(GithubService).to receive(:name).and_return({name: "little-esty-shop"})
    @merch = create(:merchant)
    @merch2 = create(:merchant)
    @item1 = create(:item, merchant_id: @merch.id)
    @item2 = create(:item, merchant_id: @merch.id)
    @item3 = create(:item, merchant_id: @merch2.id)
    @cust = create(:customer)
    @invoice1 = create(:invoice, customer_id: @cust.id)
    @inv_item1 = create(:invoice_item, invoice_id: @invoice1.id, item_id: @item1.id)
    @inv_item2 = create(:invoice_item, invoice_id: @invoice1.id, item_id: @item2.id)
    @inv_item3 = create(:invoice_item, invoice_id: @invoice1.id, item_id: @item3.id)
  end

  it "shows invoice attribues" do
    visit "/merchant/#{@merch.id}/invoices/#{@invoice1.id}"

    within('#attributes') do
      expect(page).to have_content("Invoice ##{@invoice1.id}")
      expect(page).to have_content("Status: #{@invoice1.status}")
      expect(page).to have_content("Created on: Tuesday, March 27, 2012")
      expect(page).to have_content("Customer: #{@cust.first_name} #{@cust.last_name}")
    end
  end

  it "shows invoice item" do
    visit "/merchant/#{@merch.id}/invoices/#{@invoice1.id}"

    sum1 = @inv_item1.price_dollars(@inv_item1.quantity)
    within('#items') do
      expect(page).to have_content(@item1.name)
      expect(page).to have_content(@inv_item1.quantity)
      expect(page).to have_content("$#{sum1}")
      expect(page).to have_content(@inv_item1.status)

      expect(page).to have_content(@item2.name)
      expect(page).to_not have_content(@item3.name)
    end
  end

  it "Shows the total revenue for all items on the invoice" do
    @inv_item1.update(unit_price: 225)
    @inv_item1.update(quantity: 3)
    @inv_item2.update(unit_price: 621)
    @inv_item2.update(quantity: 2)

    visit "/merchant/#{@merch.id}/invoices/#{@invoice1.id}"

    within('#attributes') do
      expect(page).to have_content("Total Revenue: $19.17")
    end
  end

   it "shows a drop down selector to change the status" do
     visit merchant_invoice_path(@merch.id, @invoice1.id)

     within("#invoice-item#{@inv_item1.id}") do
       select(:packaged)
       click_button "Update Status"
     end

     expect(page).to have_content("Item Updated Successfully")
     expect(current_path).to eq(merchant_invoice_path(@merch.id, @invoice1.id))

     within("#invoice-item#{@inv_item1.id}") do
       expect(page).to have_content('packaged')
     end
   end

   it "shows the discounted revenue" do
     @inv_item1.update(unit_price: 200)
     @inv_item1.update(quantity: 5)
     @inv_item2.update(unit_price: 400)
     @inv_item2.update(quantity: 2)

     discount = create(:bulk_discount, merchant: @merch, percentage: 25, quantity: 5)

     visit merchant_invoice_path(@merch.id, @invoice1.id)

     within('#attributes') do
       expect(page).to have_content("Total Revenue: $18.00")
       expect(page).to have_content("Discounted Revenue: $15.50")
     end
   end

   it "links the applied discount to each item" do
     @inv_item1.update(unit_price: 200)
     @inv_item1.update(quantity: 5)
     @inv_item2.update(unit_price: 400)
     @inv_item2.update(quantity: 2)

     discount = create(:bulk_discount, merchant: @merch, percentage: 25, quantity: 5)

     visit merchant_invoice_path(@merch.id, @invoice1.id)

     within("#invoice-item#{@inv_item1.id}") do
       expect(page).to have_link("Discount #{discount.id}")
     end
     within("#invoice-item#{@inv_item2.id}") do
       expect(page).to have_content("No Discount")
     end
   end
end
