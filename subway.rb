# subway.rb

require 'sinatra'
require_relative 'mbta_subway.rb'
require 'pry'

def format_subway_data(line_name, stop_name=nil)
  keep_columns = ['Destination', 'Stop', 'MinutesAway']

  line_data = MBTASubway.new(line_name).data
  @timestamp = line_data.first['CurrentTime'].strftime("%I:%M%p %m/%d/%Y")

  @results = []
  line_data.each do |line|
    line.keep_if { |k, v| keep_columns.include?(k) }

    #binding.pry
    if !stop_name.nil? and line['Stop'].downcase.include?(stop_name)
      @results << line

    elsif stop_name.nil?
      @results << line
    end
  end

  @results.sort! do |r1, r2|
    comp = (r1['Destination'] <=> r2['Destination'])
    comp.zero? ? comp = (r1['Stop'] <=> r2['Stop']) : comp
    comp.zero? ? comp = (r1['MinutesAway'] <=> r2['MinutesAway']) : comp
  end
end

get '/' do
  erb :main
end

get '/:line' do
  format_subway_data(params[:line].downcase)
  erb :main
end

get '/:line/:stop' do
  format_subway_data(params[:line].downcase, params[:stop].downcase)
  erb :main
end
