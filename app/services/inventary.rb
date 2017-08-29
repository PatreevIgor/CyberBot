module Inventary
  def get_inv
    send_request("https://market.dota2.net/api/Trades/?key=#{Rails.application.secrets.your_secret_key}")
    
  end

  def trades
  end

  private

  def send_request(url)
    uri           = URI.parse(url)
    response_json = Net::HTTP.get_response(uri)

    JSON.parse(response_json.body)
  end
end
