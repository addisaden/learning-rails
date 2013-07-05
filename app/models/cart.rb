class Cart < ActiveRecord::Base
  # Wenn Cart gelöscht wird, werden auch die dazugehörigen LineItems gelöscht.
  has_many :line_items, dependent: :destroy
end
