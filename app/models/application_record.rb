class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  def full_address
    "#{address}, #{city}, #{state} #{zip}"
  end
end
