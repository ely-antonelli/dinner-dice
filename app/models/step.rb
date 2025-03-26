class Step < ApplicationRecord
  belongs_to :recipe
  # has_many :steps, allow_destroy: true
  # accepts_nested_attributes_for :steps, allow_destroy: true
end
