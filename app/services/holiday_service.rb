class HolidayService
  def self.get_holidays
    response = conn.get("api/v3/NextPublicHolidays/US")
    json = JSON.parse(response.body, symbolize_names: true)
  end

  def self.conn
    Faraday.new(url: 'https://date.nager.at')
  end
end
