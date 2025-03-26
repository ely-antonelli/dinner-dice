class ApplicationRecord < ActiveRecord::Base
  primary_abstract_class
  # protect_from_forgery with: :exception
end
