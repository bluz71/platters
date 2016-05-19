module ApplicationHelper
  def title(page_title)
    content_for(:title) { page_title }
  end

  def has_by_letter?(params, letter)
    params[:by_letter] == letter ? "btn-success" : "btn-default"
  end
end
