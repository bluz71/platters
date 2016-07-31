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
end
