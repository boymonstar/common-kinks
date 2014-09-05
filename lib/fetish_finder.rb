class FetishFinder
  def initialize(mechanize_session)
    @mechanize = mechanize_session
    @fetish_links_cache = {}
    @requests_made = 0
  end

  def in_common(user_a, user_b)
    fetish_intersection(user_a, user_b)
  end

  def page_for_user(id)
    @requests_made = @requests_made + 1
    Profile.find(id, @mechanize)
  end

  private


  def fetishes_links_for_user(user_id)
    return @fetish_links_cache[user_id] if @fetish_links_cache[user_id]
    page = page_for_user(user_id)
    @fetish_links_cache[user_id] = page.links_with(:href => %r{/fetishes/\d+})
  end

  def fetishes_for_user(id)
    user_1_fetishes = fetishes_links_for_user(id)
    user_1_fetishes.map { |f| {name: f.text, link: f.href} }
  end

  def fetish_intersection(user_a, user_b)
    user_1_fetishes = fetishes_for_user(user_a)
    user_2_fetishes = fetishes_for_user(user_b)
    user_1_fetishes & user_2_fetishes
  end
end
