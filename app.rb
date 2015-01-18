#!/usr/bin/env ruby

require 'json'
require 'open-uri'
require 'rubygems'
require 'active_record'
require 'yaml'
require_relative 'models/Point'

dbconfig = YAML::load(File.open('config/database.yaml'))
ActiveRecord::Base.establish_connection(dbconfig['development'])

def display_data(points)
  points.each do |p|
    puts "#{p.id}: #{p.name} in #{p.city} positioned at #{p.latitude}/#{p.longitude}"
  end
end

p = Point.all
if (p.count == 0)
  Point.load_from_source
  p = Point.all
  display_data(p)
else
  display_data(p)
end

