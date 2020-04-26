# Load the Rails application.
require_relative "application"

# Initialize the Rails application.
Rails.application.initialize!

# Disable field_with_errors wrapper, see:
#   https://coderwall.com/p/s-zwrg/remove-rails-field_with_errors-wrapper
ActionView::Base.field_error_proc = proc do |html_tag, instance|
  html_tag.html_safe
end

# XXX See: https://stackoverflow.com/questions/5267998/rails-3-field-with-errors-wrapper-changes-the-page-appearance-how-to-avoid-t
# Fix toast as well
