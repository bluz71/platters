module ApplicationHelper
  def title(page_title)
    content_for(:title) { page_title }
  end

  def letter_btn(params, letter)
    params[:letter] == letter ? "btn-success" : "btn-default"
  end

  def digit_btn(params)
    params[:digit] ? "btn-success" : "btn-default"
  end
end
