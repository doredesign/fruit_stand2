class Display
  include Helpers

  def initialize(state, cli)
    @state = state
    @cli = cli

    @state[:user][:balance] = @state[:constants][:initial_balance]
  end

  def show
    page = @state[:page]
    response = @cli.ask page_text(page)
    send("#{page}_handler", response)
  end

  private

  def home_handler(response)
    @state[:error] = nil

    valid_responses = %w[1 2 3]
    unless valid_responses.include?(response)
      @state[:error] = "#{response} is not a valid option\n\n"
      return
    end

    case response
    when "1"
      @state[:page] = :inventory
    when "2"
      set_prices!
      @state[:page] = :buy
    when "3"
      @cli.say page_text(:exit)
      exit
    end
  end

  def buy_handler(response)
    @state[:error] = nil

    valid_responses = (1..(@state[:available_to_buy].count + 1)).to_a.map(&:to_s)
    unless valid_responses.include?(response)
      @state[:error] = "#{response} is not a valid option\n\n"
      return
    end

    buying = response.to_i
    if buying <= @state[:available_to_buy].count
      @state[:page_status][:buying][:selection] = buying - 1
      if max_lbs_can_afford > 0
        @state[:page] = :buying
      else
        @state[:error] = <<~RESPONSE
          Unfortunately you can't afford those right now.

          Please select another option.
        RESPONSE
        return
      end
    else
      @state[:page] = :home
    end

    @state[:today] += 1
  end

  def buying_handler(response)
    @state[:error] = nil

    valid_responses = (1..max_lbs_can_afford).to_a.map(&:to_s)
    unless valid_responses.include?(response)
      @state[:error] = "#{response} is not a valid option. The max you can afford is #{max_lbs_can_afford} lbs.\n\n"
      return
    end

    lbs_to_buy = response.to_i
    cost = currently_buying.current_price * lbs_to_buy

    # Take away $
    @state[:user][:balance] = (@state[:user][:balance] -= cost).round(2)

    # Add to inventory
    @state[:user][:inventory][currently_buying.name] ||= []
    @state[:user][:inventory][currently_buying.name] << Lot.new(currently_buying,
      expires_on: today + currently_buying.expire_after_days,
      weight: lbs_to_buy,
    )

    @state[:page] = :home
  end

  def inventory_handler(response)
    @state[:page] = :home
  end

  def welcome_handler(response)
    @state[:user][:name] = response
    @state[:page] = :home
  end

  def page_text(page)
    template_location = "pages/#{page}.txt.erb"
    template_str = File.read(template_location)
    system "clear"
    ERB.new(template_str).result(binding)
  end

  def set_prices!
    @state[:available_to_buy].each(&:set_current_price!)
  end
end
