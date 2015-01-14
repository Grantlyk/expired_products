require 'rubygems'
require 'csv'
require 'net/http'
require 'uri'
require 'open-uri'
require 'json'

puts "starting..."

content = open("http://www.shopshopgo.com/get_data_feeds.json").read
data_feed_download_url = Hash.new {|hash, key| hash[key] = []}
data_feed_download_url = JSON.parse(content)
products = []
i = 0
count = 0


while count < data_feed_download_url.length do
  products << data_feed_download_url[count]["store_name"]
  count +=1
end

while i < products.length do
  `rm -rf #{products[i]}2.csv`
  puts "File #{products[i]}2.csv Removed\n"
  i +=1
end

puts "Finished"