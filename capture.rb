require 'sequel'
require 'http'

DB = Sequel.sqlite('coinjar.sqlite')

# fetch and store the latest prices for each currencies
while(1) do
    DB[:currencies].each do |cur|
    resp = HTTP.get("https://data.exchange.coinjar.com/products/#{cur[:symbol]}AUD/ticker")
    tick = JSON.parse(resp.to_s)
    DB[:prices].insert(
        currency_id: cur[:id],
        current_time: tick['current_time'],
        last: tick['last'],
        bid: tick['bid'],
        ask: tick['ask']
    )
    end
    sleep 60 * 5
end

DB[:currencies].each { |anything| puts anything }
DB[:prices].each { |x| puts x }
