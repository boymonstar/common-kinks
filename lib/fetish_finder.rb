class FetishFinder
  def initialize(config)
    @config = config
    @mechanize = Mechanize.new
  end

  def in_common(user_a, user_b)
    authenticate!
    fetish_intersection(user_a, user_b)
  end

  def users_friends(user_id)
    # for all pages, get the user's friends
    authenticate!
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

  private

  def authenticate!
    page = @mechanize.get('https://fetlife.com/login')
    login_form = page.forms.first
    login_form['nickname_or_email'] = @config['username']
    login_form['password'] = @config['password']
    login_form.submit
  end

  def page_for_user(id)
    @mechanize.get("https://fetlife.com/users/#{id}")
  end

  def fetishes_links_for_user(id)
    page = page_for_user(id)
    page.links_with(:href => %r{/fetishes/\d+})
  end

  def fetishes_for_user(id)
    user_1_fetishes = fetishes_links_for_user(id)
    user_1_fetishes.map { |f| [f.text, f.href] }
  end

  def fetish_intersection(user_a, user_b)
    user_1_fetishes = fetishes_for_user(user_a)
    user_2_fetishes = fetishes_for_user(user_b)
    user_1_fetishes & user_2_fetishes
  end
end
