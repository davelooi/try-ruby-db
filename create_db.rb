require 'sequel'

DB = Sequel.sqlite('coinjar.sqlite')

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
