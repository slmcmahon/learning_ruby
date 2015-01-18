class Point < ActiveRecord::Base
  DATA_URL = "http://data.hawaii.gov/api/views/jx86-2vch/rows.json?accessType=DOWNLOAD"
  def self.load_from_source()
    library_data = JSON.parse(open(DATA_URL).read)
    library_data["data"].each do |lib|
      loc = lib[11]
      addr = JSON.parse(loc[0])

      p = Point.new
      p.name = lib[8]
      p.city = addr["city"]
      p.latitude = loc[1]
      p.longitude = loc[2]
      p.save
    end
  end
end