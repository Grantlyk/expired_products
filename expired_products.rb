require 'csv'
require 'pg'
require 'net/http'
require 'uri'


conn = PG::Connection.open(:dbname => 'test')


expired_products = []
data1 = {}
data2 = {}


CSV.foreach("datafeed.csv") do |row|
  data1[row[0]] = [row[3]]
end

CSV.foreach("datafeed2.csv") do |row| 
  data2[row[0]] = [row[3]]
end


data1.each_key do |e|
  if(!data2.has_key?(e))
    expired_products << data1.fetch(e)
  end
end


Net::HTTP.new('http://localhost').delete('/path')

