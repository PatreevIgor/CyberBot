class Connection
  def self.send_request(url)
    uri           = URI.parse(url)
    response_json = Net::HTTP.get_response(uri)

    JSON.parse(response_json.body)
  end
end
