#!/usr/bin/env ruby

require 'json'
require 'open-uri'
require 'rubygems'
require 'active_record'
require 'yaml'
require_relative 'models/Point'

dbconfig = YAML::load(File.open('config/database.yaml'))
ActiveRecord::Base.establish_connection(dbconfig['development'])

def load_data
  library_data = JSON.parse(open("http://data.hawaii.gov/api/views/jx86-2vch/rows.json?accessType=DOWNLOAD").read)
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

def display_data(points)
  points.each do |p|
    puts "#{p.id}: #{p.name} in #{p.city} positioned at #{p.latitude}/#{p.longitude}"
  end
end

p = Point.all
if (p.count == 0)
  load_data
  p = Point.all
  display_data(p)
else
  display_data(p)
end

