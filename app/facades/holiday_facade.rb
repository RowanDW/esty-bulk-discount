class HolidayFacade

  def self.holidays(num)
    json = HolidayService.get_holidays

    @holidays = json.map do |holiday_data|
      Holiday.new(holiday_data)
    end

    @holidays.first(num)
  end
end
