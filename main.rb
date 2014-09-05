require 'rubygems'
require 'bundler/setup'

require 'pry'
require 'yaml'
require 'mechanize'

$:.unshift 'lib'
require 'fetish_finder'
require 'friend_finder'

config = YAML.load_file('config/credentials.yml')

def authenticated_mechanize(config)
  mechanize = Mechanize.new
  page = mechanize.get('https://fetlife.com/login')
  login_form = page.forms.first
  login_form['nickname_or_email'] = config['username']
  login_form['password'] = config['password']
  login_form.submit
  mechanize
end

mechanize_session = authenticated_mechanize(config)

finder = FetishFinder.new(mechanize_session)
friend_finder = FriendFinder.new(mechanize_session)

friends = friend_finder.for_user(config["testuser"])

puts friends
#friend_intersections = friends.map do |friend|
  friend = friends[1]
puts friend

  intersection = finder.in_common(config["testuser"], friend[:id])
  puts friend[:name]
  puts intersection.map {|fetish| fetish[0]}
  puts "-"*10
  {
    name: friend[0],
    intersection: intersection
  }
#end


# Find all the friends of the user
# compare all of their fetishes
# Cache users' fetishes to not spam the original user's page

#puts intersection.map { |f| f[0] }
#binding.pry

