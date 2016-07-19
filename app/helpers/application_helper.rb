module ApplicationHelper
  def title(page_title)
    content_for(:title) { page_title }
  end

  def has_error?(model, field)
    "has-error" if model.errors[field].present?
  end

  #XXX TO-DELETE
  def letter_btn(params, letter)
    params[:letter] == letter ? "btn-success" : "btn-default"
  end

  #XXX TO-DELETE
  def digit_btn(params)
    params[:digit] ? "btn-success" : "btn-default"
  end

  def letter_activity(params, letter)
    params[:letter] == letter ? "active" : ""
  end

  def digit_activity(params)
    params[:digit] ? "active" : ""
  end
end
