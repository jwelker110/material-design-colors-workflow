require './color_to_hex'

def item_xml(options = {})
  <<-ITEM
  <item arg="#{options[:arg]}" uid="#{options[:uid]}">
    <title>#{options[:title]}</title>
    <subtitle>#{options[:subtitle]}</subtitle>
    <icon>#{options[:path]}</icon>
  </item>
  ITEM
end

images_path = File.expand_path('../images/colors', __FILE__)

queries = ARGV.first.split(' ')

colors = COLOR_TO_HEX.inject([]) do |res, (color_name, color_kinds)|
  color_kinds.each do |color_num, color_val|
    res << {
      name: "#{color_name}_#{color_num}",
      value: color_val
    }
  end
  res
end

matched_colors = colors.select do |color|
  queries.select do |query|
    !color[:name].match(/#{query}/i)
  end.length == 0
end

items = matched_colors.map do |color|
  arg = "\##{color[:value]}"
  uid = "#{color[:name]}"
  path = "images/colors/#{uid}.png"
  title = "#{color[:name].gsub!('_', ' ')}"
  subtitle = "#{arg}"
  item_xml({ arg: arg, uid: uid, path: path, title: title, subtitle: subtitle})
end.join

output = "<?xml version='1.0'?>\n<items>\n#{items}</items>"

puts output
