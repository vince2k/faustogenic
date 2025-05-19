# scripts/test_compo.rb
require 'nokogiri'

file = 'lib/data/compo_2020_07_07_utf8.xml'
content = File.read(file)
doc = Nokogiri::XML(content)
puts "Nombre de nœuds COMPO : #{doc.xpath('//COMPO').count}"
doc.xpath('//COMPO').each do |compo|
  code = compo.at_xpath('alim_code')&.text
  const = compo.at_xpath('const_code')&.text
  value = compo.at_xpath('teneur')&.text
  source = compo.at_xpath('source_code')&.text
  puts "Code: #{code&.strip}, Const: #{const}, Value: #{value}, Source: #{source}" if %w[6581 12801].include?(code&.strip)
end
