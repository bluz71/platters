module ApplicationHelper
  def title(page_title)
    content_for(:title) { page_title }
  end

  def has_error?(model, field)
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
  #   <h1>Types <small>(300 Types)</small></h1>
  def index_page_header_text(type, objects)
    genre = params.key?(:genre) ? params[:genre] : ""
    year = params.key?(:year) ? " from #{params[:year]}" : ""
    content_tag(:h1) do
      concat type.pluralize
      concat " "
      concat content_tag(:small) {
        "(#{number_with_delimiter(objects.total_count)} #{genre} #{type.pluralize(objects.total_count)}#{year})"
      }
    end
  end

  def add_letter(letter)
    request.query_parameters.merge(letter: letter)
  end
end
