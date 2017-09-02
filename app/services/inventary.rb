module Inventary
  def get_inv
    Connection.send_request("https://market.dota2.net/api/Trades/?key=#{Rails.application.secrets.your_secret_key}")
  end

  def trades
  end
end
