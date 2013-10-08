require 'csv'
require 'open-uri'

# mbta_commuter_rail_data = {
#   greenbush: "http://developer.mbta.com/lib/RTCR/RailLine_1.json",
#   kingston_plymouth: "http://developer.mbta.com/lib/RTCR/RailLine_2.json",
#   middleborough_lakeville:
# }

departure_board = "http://developer.mbta.com/lib/gtrtfs/Departures.csv"

base_url = "http://developer.mbta.com/lib/RTCR/RailLine_RAILNUM.json"

endpoint = [
  'Greenbush',
  'Kingston-Plymouth',
  'Middleborough-Lakeville',
  'Fairmount',
  'Providence-Stoughton',
  'Franklin',
  'Needham',
  'Framingham-Worcester',
  'Fitchburg',
  'Lowell',
  'Haverhill',
  'Newburyport-Rockport'
]

#puts "   Line: feed_url"
rail_line = {}
endpoint.each_with_index do |name, i|
  rail_line[name] = base_url.gsub(/RAILNUM/, (i+1).to_s)
end

records = []
CSV.foreach(open(departure_board),
            headers: true,
            header_converters: true,
            converters: :all,
            col_sep: ',') do |row|
  records << row
end

