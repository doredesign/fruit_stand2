module Helpers
  def display_date(date)
    date.strftime("%b %-d")
  end

  def currently_buying
    @state[:available_to_buy][@state[:page_status][:buying][:selection]]
  end

  def max_lbs_can_afford
    (@state[:user][:balance] / currently_buying.current_price).floor
  end

  def today
    @state[:today]
  end
end
