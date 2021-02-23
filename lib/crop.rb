class Crop
  attr_reader :name, :current_price, :expire_after_days

  def initialize(name, min_price:, max_price:, expire_after_days:)
    @name = name
    @min_price = min_price
    @max_price = max_price
    @expire_after_days = expire_after_days
    @current_price = nil
  end

  def set_current_price!
    @current_price = (difference * rand + @min_price).round(2)
  end

  private

  def difference
    @difference ||= @max_price - @min_price
  end
end
