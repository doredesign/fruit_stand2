class Lot
  include Helpers

  @id = 0

  def self.next_id
    @id += 1
  end

  attr_reader :id, :weight, :expires_on

  def initialize(crop, expires_on:, weight:)
    @crop = crop
    @expires_on = expires_on
    @weight = weight
    @id = Lot.next_id
  end

  def display
    "#{weight} lbs, expires at #{display_date(expires_on)}"
  end
end
