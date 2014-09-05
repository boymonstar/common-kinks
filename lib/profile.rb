class Profile
  def self.find(id, mechanize)
    page = mechanize.get("https://fetlife.com/users/#{id}")
    print "."
    $stdout.flush
    page
  end
end
