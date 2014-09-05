class FriendFinder
  def initialize(authenticated_mechanize)
    @mechanize = authenticated_mechanize
  end

  def for_user(user_id)
    # for all pages, get the user's friends
    first_friends_page = @mechanize.get("https://fetlife.com/users/#{user_id}/friends")
    links = first_friends_page.links_with(href: %r{/users/\d+})

    link_hashes = links.map do |link|
      {
        name: link.text,
        href: link.href,
        id: link.href.match(%r{/users/(\d+)})[1]
      }
    end

    filter_to_friend_links(link_hashes, user_id)
  end

  private

  def filter_to_friend_links(link_hashes, user_id)
    hashes = link_hashes.uniq!

    hashes.reject do |hash|
      # reject when: not a user link
      # or
      # is authenticated user
      # or
      # is current user
      !hash[:href].match(%r{/users/\d+$}) ||
        hash[:name].match(%r{View Your Profile}) ||
        hash[:href].match(%r{/users/#{user_id}})
    end
  end

end
