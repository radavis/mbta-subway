# subway.rb

require 'sinatra'
require_relative 'mbta_subway.rb'

def format_subway_data(line_name, stop_name=nil)
  keep_columns = ['Destination', 'Stop', 'MinutesAway']

  line_data = MBTASubway.new(line_name).data
  @timestamp = line_data.first['CurrentTime'].strftime("%I:%M%p %m/%d/%Y")

  @results = []
  line_data.each do |line|
    line.keep_if { |k, v| keep_columns.include?(k) }

    if !stop_name.nil? and line['Stop'].downcase.include?(stop_name)
      @results << line

    elsif stop_name.nil?
      @results << line
    end
  end

  @results.sort_by! { |r| [r['Destination'], r['Stop'], r['MinutesAway']] }

end

get '/' do
  @subway_stops = {}
  [:blue, :orange, :red].each do |line|
    subway_info = MBTASubway.new(line)
    @subway_stops[line] = subway_info.stops
    @timestamp = subway_info.timestamp
  end

  erb :root
end

get '/:line' do
  format_subway_data(params[:line].downcase)
  erb :main
end

get '/:line/:stop' do
  format_subway_data(params[:line].downcase, params[:stop].downcase)
  erb :main
end
