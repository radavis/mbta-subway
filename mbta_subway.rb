require 'csv'
require 'open-uri'

class MBTASubway

  MBTA_FILES = {
    blue: 'http://developer.mbta.com/lib/rthr/blue.csv',
    orange: 'http://developer.mbta.com/lib/rthr/orange.csv',
    red: 'http://developer.mbta.com/lib/rthr/red.csv'
  }

  UPDATE_FREQUENCY = 30  # seconds

  attr_reader :color, :data, :timestamp

  def initialize(color)
    @color = color
    @remote_csv = MBTA_FILES[color.to_sym] # better be blue, orange, or red
    @local_csv = "data/#{color}.csv"
    update
  end

  def stops
    @data.map { |train| train['Stop'] }.uniq
  end

  def update
    grab_csv if (Time.now - File.mtime(@local_csv)).to_i > UPDATE_FREQUENCY

    @data = []
    CSV.foreach(@local_csv,
                headers: true,
                converters: :all,
                col_sep: ',') do |row|

      row["CurrentTime"] = Time.at(row["CurrentTime"])
      @timestamp = row["CurrentTime"]
      row["PosTimestamp"] = Time.at(row["PosTimestamp"]) if row["PosTimestamp"]
      row["MinutesAway"] = (row["SecondsAway"] / 60.0).round
      @data << row.to_hash
    end
  end

  private
  def grab_csv
    remote_data = open(@remote_csv).read
    departures_csv = File.open(@local_csv, "w")
    departures_csv.write(remote_data)
    departures_csv.close
  end

end
