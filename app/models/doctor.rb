class Doctor < ApplicationRecord
  has_many :patient_doctors, dependent: :destroy
  has_many :patients, through: :patient_doctors

  validates :first_name, :last_name, presence: true
  validates :first_name, :last_name, length: { maximum: 30 }
  validates :middle_name, length: { maximum: 30 }, allow_nil: true

end
