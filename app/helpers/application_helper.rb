# frozen_string_literal: true

module ApplicationHelper
  def title(page_title)
    content_for(:title) { page_title }
  end

  def error?(model, field)
    "has-error" if model.errors[field].present?
  end

  def letter_activity(params, letter)
    params[:letter] == letter ? "active" : ""
  end

  def digit_activity(params)
    params[:digit] ? "active" : ""
  end

  def search_form_visibility(params)
    "hidden" unless params.key?(:search)
  end

  # Helper used to produce an index page header of the form:
  #   <h1>Types <small>(300 <<Genre>> Types <<from Year>>)</small></h1>
  #
  # Note, <<Genre>> and <<from Year>> will only be set if supplied in the
  # params hash.
  def header_text_with_counter(header, type, objects_count)
    genre = params.key?(:genre) ? params[:genre] : ""
    year = params.key?(:year) && params[:year].present? ? " from #{params[:year]}" : ""
    content_tag(header) do
      concat type.pluralize
      concat " "
      concat content_tag(:small, "data-behavior" => "#{type.downcase}-header-counter") {
        "(#{number_with_delimiter(objects_count)} #{genre} "\
        "#{type.pluralize(objects_count)}#{year})"
      }
    end
  end

  def add_letter(letter)
    request.query_parameters.delete(:page)
    request.query_parameters.merge(letter: letter)
  end

  def turbolinks_cache_control
    if random_albums_action?
      # Due to a jarring visual effect disable the Turbolinks cache for the
      # randomized albums index action.
      "no-cache"
    elsif development_home_page?
      # Turbolinks cache effect is also jarring with the home page "album of
      # the day" in development mode which does not enable caching by default;
      # caching hides the effect hence no need for 'no-preview' in production
      # mode.
      #
      # Note, the use 'no-preview' means the cache will still be used with the
      # back button but not when the 'home' link is clicked.
      "no-preview"
    else
      "cache"
    end
  end

  def signed_in_as_admin?
    signed_in? && current_user.admin?
  end

  def gravatar_url(user, size = 80)
    hash = Digest::MD5.hexdigest(user.email.strip.downcase)
    "https://gravatar.com/avatar/#{hash}?s=#{size}&r=pg&d=identicon"
  end

  private

  def random_albums_action?
    controller_name == "albums" && action_name == "index" && params.key?(:random)
  end

  def development_home_page?
    Rails.env.development? && (controller_name == "misc_pages" && action_name == "home")
  end
end
