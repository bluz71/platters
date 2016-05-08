module ApplicationHelper
  def title(page_title)
    content_for(:title) { "Platters - #{page_title}" }
  end
end
