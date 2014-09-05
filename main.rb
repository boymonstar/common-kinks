require 'rubygems'
require 'bundler/setup'

require 'pry'
require 'yaml'
require 'mechanize'

config = YAML.load_file('config/credentials.yml')

mechanize = Mechanize.new

page = mechanize.get('https://fetlife.com/login')

login_form = page.forms.first
login_form['nickname_or_email'] = config['username']
login_form['password'] = config['password']
login_form.submit

def page_for_user(id, mechanize)
  mechanize.get("https://fetlife.com/users/#{id}")
end

def fetishes_links_for_user(id, mechanize)
  page = page_for_user(id, mechanize)
  page.links_with(:href => %r{/fetishes/\d+})
end

def fetishes_for_user(id, mechanize)
  user_1_fetishes = fetishes_links_for_user(id, mechanize)
  user_1_fetishes.map { |f| [f.text, f.href] }
end

puts config["testuser"]
puts config["testfriend"]

user_1_fetishes = fetishes_for_user(config["testuser"], mechanize)
user_2_fetishes = fetishes_for_user(config["testfriend"], mechanize)
intersection = user_1_fetishes & user_2_fetishes

puts intersection.map { |f| f[0] }
binding.pry

