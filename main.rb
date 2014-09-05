require 'rubygems'
require 'bundler/setup'

require 'pry'
require 'yaml'
require 'mechanize'

$:.unshift 'lib'
require 'fetish_finder'

config = YAML.load_file('config/credentials.yml')

finder = FetishFinder.new(config)

friends = finder.users_friends(config["testuser"])

friend_intersections = friends.map do |friend|
  intersection = finder.in_common(config["testuser"], friend[1])
  puts friend[0]
  puts intersection.map {|f|f[0]}
  puts "-"*10
  {
    name: friend[0],
    intersection: intersection
  }
end


# Find all the friends of the user
# compare all of their fetishes
# Cache users' fetishes to not spam the original user's page

#puts intersection.map { |f| f[0] }
#binding.pry

