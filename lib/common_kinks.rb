require 'fetish_finder'
require 'friend_finder'
require 'profile'
922216
class CommonKinks

  class Client
    def initialize(config)
      @config = config
    end

    def find(user_id, friend_to_check)
      mechanize_session = authenticated_mechanize(@config)

      finder = FetishFinder.new(mechanize_session)
      friend_finder = FriendFinder.new(mechanize_session)

      if friend_to_check == "All"
        friends = friend_finder.for_user(user_id)
      else
        friends_page = Profile.find(friend_to_check, mechanize_session)
        friends = [{
          name: friends_page.at("h2.bottom").text,
          href: "https://fetlife.com/users/#{friend_to_check}",
          id: friend_to_check
        }]
      end

      friends.map do |friend|
        intersection = finder.in_common(user_id, friend[:id])
        {
          name: friend[:name],
          intersection: intersection
        }
      end
    end

    private

    def authenticated_mechanize(config)
      mechanize = Mechanize.new
      page = mechanize.get('https://fetlife.com/login')
      login_form = page.forms.first
      login_form['nickname_or_email'] = config['username']
      login_form['password'] = config['password']
      login_form.submit
      mechanize
    end

  end


  def self.for_user(config, user_id, friend_to_check)
    client = Client.new(config)
    client.find(user_id, friend_to_check)
  end

end
