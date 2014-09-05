class FriendFinder
  def initialize(authenticated_mechanize)
    @mechanize = authenticated_mechanize
  end

  def for_user(user_id)
    # for all pages, get the user's friends
    first_friends_page = @mechanize.get("https://fetlife.com/users/#{user_id}/friends")
    friend_links = first_friends_page.links_with(href: %r{/users/\d+})


    friends = friend_links.map do |link|
      {
        name: link.text,
        href: link.href,
        id: link.href.match(%r{/users/(\d+)})[1]
      }
    end
    uniq_friends = friends.uniq!

    uniq_friends = uniq_friends.reject do |friend|
      # reject when: not a user link
      # or
      # is authenticated user
      # or
      # is current user
      !friend[:href].match(%r{/users/\d+$}) ||
        friend[:name].match(%r{View Your Profile}) ||
        friend[:href].match(%r{/users/#{user_id}})
    end

    uniq_friends
  end

end
