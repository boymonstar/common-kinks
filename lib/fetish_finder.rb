class FetishFinder
  def initialize(mechanize_session)
    @mechanize = mechanize_session
  end

  def in_common(user_a, user_b)
    fetish_intersection(user_a, user_b)
  end

  private

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
