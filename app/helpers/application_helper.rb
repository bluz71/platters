module ApplicationHelper
  def title(page_title)
    content_for(:title) { page_title }
  end

  def by_letter_btn(params, letter)
    params[:by_letter] == letter ? "btn-success" : "btn-default"
  end

  def by_digit_btn(params)
    params[:by_digit] ? "btn-success" : "btn-default"
  end
end
