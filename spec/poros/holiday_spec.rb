require "rails_helper"

RSpec.describe Holiday do
  it "exists" do
    attrs = {
      name: "Thanksgiving",
      date: "Thursday"
    }

    holiday = Holiday.new(attrs)

    expect(holiday).to be_a Holiday
    expect(holiday.name).to eq("Thanksgiving")
    expect(holiday.date).to eq("Thursday")
  end
end
