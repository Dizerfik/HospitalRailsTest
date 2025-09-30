class BmrCalculation < ApplicationRecord
  belongs_to :patient
  validates :formula, :value, presence: true
  validates :formula, inclusion: { in: %w[mifflin_san_jeor harris_benedict] }
end
