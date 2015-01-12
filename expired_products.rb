require 'rubygems'
require 'csv'
require 'pg'
require 'net/http'
require 'uri'
require 'zip'
require 'open-uri'
require 'json'


content = open("http://www.shopshopgo.com/get_data_feeds.json").read
data_feed_download_url = Hash.new {|hash, key| hash[key] = []}
data_feed_download_url = JSON.parse(content)
products = []
expired_products = []
data1 = {}
data2 = {}
i = 0
c = 0
count = 0
d = 0


while count < data_feed_download_url.length do
  products << data_feed_download_url[count]["store_name"]
  count +=1
end

while d < data_feed_download_url.length do
  `curl -o ~/SearchTheSales/scripts/expired_products/#{products[d]}2.csv.zip #{data_feed_download_url[d]["feed_url"]}`
  d +=1
end



puts "Importing & Comparing files - Please wait..."

while i < products.length  do
  Zip::File.open(products[i] + "2.csv.zip") do |zip_file|
    zip_file.each do |entry|
      entry.extract("../expired_products/" + products[i] + "2.csv")
    end
  end


  CSV.foreach(products[i] + ".csv") do |row|
    data1[row[0]] = [row[3]]
  end
  CSV.foreach(products[i] + "2.csv") do |row|
    data2[row[0]] = [row[3]]
  end
  i +=1
end


data1.each_key do |e|
  if(!data2.has_key?(e))
    expired_products << data1.fetch(e)
  end
end


while c < products.length do
  destfile = "../expired_products/#{products[c]}.csv"
  FileUtils.rm(destfile)
  File.rename(products[c].to_s + "2.csv", products[c].to_s + ".csv")
  c +=1
end

puts expired_products
puts expired_products.length
puts "Job Complete"
#Net::HTTP.new('http://localhost').delete('/path')



