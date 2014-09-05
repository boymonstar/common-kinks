class FriendFinder
  def initialize(authenticated_mechanize)
    @mechanize = authenticated_mechanize
  end

  def for_user(user_id)
    # for all pages, get the user's friends
    first_friends_page = @mechanize.get("https://fetlife.com/users/#{user_id}/friends")
    friend_links = first_friends_page.links_with(href: %r{/users/\d+})
    #friend_links.map { |link| [link.text, link.href.match(/(\d+)/)[[1]]] }
    tuples = friend_links.map { |link| [link.text, link.href] }
    uniq_tuples = tuples.uniq!

    only_friend_links = uniq_tuples.reject do |tuple|
      # reject when: not a user link
      # or
      # is authenticated user
      # or
      # is current user
      !tuple[1].match(%r{/users/\d+$}) ||
        tuple[0].match(%r{View Your Profile}) ||
        tuple[1].match(%r{/users/#{user_id}})
    end

    only_friend_links.map do |tuple|
      [
        tuple[0],
        tuple[1].match(%r{/users/(\d+)})[1]
      ]
    end
  end


end
