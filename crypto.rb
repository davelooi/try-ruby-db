require 'sequel'
require 'http'

DB = Sequel.sqlite

DB.create_table :currencies do
  primary_key :id
  String :name
  String :symbol
end

DB.create_table :prices do
  primary_key :id
  foreign_key :currency_id, :currencies
  Time :current_time
  String :last
  String :bid
  String :ask
end

# populate the currencies
btc = DB[:currencies].insert(name: 'Bitcoin', symbol: 'BTC')
eth = DB[:currencies].insert(name: 'Ethereum', symbol: 'ETH')

# fetch and store the latest prices for each currencies
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

DB[:currencies].each { |anything| puts anything }
DB[:prices].each { |x| puts x }
