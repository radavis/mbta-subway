# subway.rb

require 'sinatra'
require_relative 'mbta_subway.rb'
require 'pry'

keep_columns = ['Destination', 'Stop', 'MinutesAway']

get '/:line' do
  # select a list of stops alphabetically (or by stop location?)

  line_data = MBTASubway.new(params[:line]).data
  @timestamp = line_data.first['CurrentTime'].strftime("%I:%M%p %m/%d/%Y")

  @results = []
  line_data.each do |line|
    line.keep_if { |k, v| keep_columns.include?(k) }
    @results << line
  end

  @results.sort_by { |result| result['Stop'] }

  erb :main
end

get '/:line/:stop' do

  line_data = MBTASubway.new(params[:line]).data
  @timestamp = line_data.first['CurrentTime'].strftime("%I:%M%p %m/%d/%Y")

  @results = []
  line_data.each do |line|
    if line['Stop'].downcase.include?(params[:stop])
      line.keep_if { |k, v| keep_columns.include?(k) }
      @results << line
    end
  end

  @results.sort_by! { |result| result['MinutesAway'] }


  #binding.pry
  erb :main
end
