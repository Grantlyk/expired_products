require 'rubygems'
require 'csv'
require 'pg'
require 'net/http'
require 'uri'
require 'zip'

`curl -o ~/SearchTheSales/scripts/expired_products/asos2.csv.zip http://datafeed.api.productserve.com/datafeed/download/apikey/5ceb2936022c9df973e19221f267ec28/cid/129,595,539,147,149,135,163,168,159,169,161,167,170,171,174,183,178,179,175,172,189,194,141,205,198,206,203,208,199,204,201/fid/5678/columns/aw_product_id,merchant_product_id,merchant_category,aw_deep_link,merchant_image_url,search_price,description,product_name,rrp_price,display_price,brand_name,size,specifications,merchant_deep_link/format/csv/delimiter/,/compression/zip/adultcontent/0/`
`curl -o ~/SearchTheSales/scripts/expired_products/hof2.csv.zip http://datafeed.api.productserve.com/datafeed/download/apikey/5ceb2936022c9df973e19221f267ec28/cid/171,174,183,178,179,175,172,189,194,198,206,199,204,201/fid/3100/columns/aw_product_id,merchant_product_id,merchant_category,aw_deep_link,merchant_image_url,search_price,description,product_name,rrp_price,display_price,brand_name,specifications,size,colour,stock_quantity,merchant_deep_link/format/csv/delimiter/,/compression/zip/adultcontent/0/`
`curl -o ~/SearchTheSales/scripts/expired_products/flannels2.csv.zip http://datafeed.api.productserve.com/datafeed/download/apikey/5ceb2936022c9df973e19221f267ec28/fid/3805/columns/aw_product_id,merchant_product_id,merchant_category,aw_deep_link,merchant_image_url,search_price,description,product_name,rrp_price,display_price,brand_name,specifications,merchant_deep_link/format/csv/delimiter/,/compression/zip/adultcontent/0/`


conn = PG::Connection.open(:dbname => 'test')

products = ["asos","hof","flannels"]#,"coggles","john_lewis","office_shoes","zalando","footasylum","spartoo","schuh","sarenza","oki_ni","menlook","allsole","cloggs","joules","topman","topshop","size?","aphrodite","brown_bag","diffusion","infinites","jules_b","psyche","repertoire","rubbersole","trainerstation","treds","tucci","van_mildert","woodhouse"]
expired_products = []
data1 = {}
data2 = {}
i = 0
c = 0

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
puts "Job Complete"
#Net::HTTP.new('http://localhost').delete('/path')



