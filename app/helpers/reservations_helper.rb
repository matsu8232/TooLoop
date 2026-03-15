module ReservationsHelper
  def reserved_on?(reserved_dates, day)
    reserved_dates.include?(day.to_s)
  end
end
