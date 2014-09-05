require 'rubygems'
require 'bundler/setup'

require 'pry'
require 'yaml'
require 'mechanize'

$:.unshift 'lib'
require 'common_kinks'

print "What's your user ID? (look in the URL on your page): "
$stdout.flush

user_to_check = gets

print "Which friend would you find? Enter their ID. Enter \"All\" for all friends: "
$stdout.flush

friend_to_check = gets.chomp

if friend_to_check == "All"
  puts "OK! We're looking up all of your friends."
  puts "This might take a while..."
else
  puts "OK! We're looking up #{friend_to_check}. This will take just a second."
end

config = YAML.load_file('config/credentials.yml')

common_kinks = CommonKinks.for_user(config, user_to_check, friend_to_check)

puts " "
common_kinks.each do |friend_intersection|
  puts "-"*10
  puts friend_intersection[:name]
  puts friend_intersection[:intersection].map { |fetish| fetish[:name] }
  puts "-"*10
end


