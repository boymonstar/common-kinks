require 'rubygems'
require 'bundler/setup'

require 'pry'
require 'yaml'
require 'mechanize'

$:.unshift 'lib'
require 'fetish_finder'

config = YAML.load_file('config/credentials.yml')


finder = FetishFinder.new(config)
intersection = finder.in_common(config["testuser"], config["testfriend"])

puts intersection.map { |f| f[0] }
#binding.pry

