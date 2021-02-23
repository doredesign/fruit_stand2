require 'bundler/inline'

gemfile do
  source 'https://rubygems.org'
  gem 'highline'
end

require 'highline'
require './lib/helpers'
require './lib/display'
require './lib/lot'
require './lib/crop'

cli = HighLine.new
state = {
  # page: :home,
  page: :welcome,
  page_status: {
    buying: {
      selection: nil
    }
  },
  user: {
    balance: 0,
    inventory: {}
  },
  error: nil,
  today: Date.parse("May 1"),
  constants: {
    initial_balance: 100
  },
  available_to_buy: [
    Crop.new("Blueberries", min_price: 2, max_price: 5, expire_after_days: 8),
    Crop.new("Raspberries", min_price: 3, max_price: 6, expire_after_days: 4),
    Crop.new("Strawberries", min_price: 0.5, max_price: 1.5, expire_after_days: 6),
  ]
}

display = Display.new(state, cli)
loop do
  display.show
end
