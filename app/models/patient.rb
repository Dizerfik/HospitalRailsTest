class Patient < ApplicationRecord
  has_many :patient_doctors, dependent: :destroy
  has_many :doctors, through: :patient_doctors
  has_many :bmr_calculations, dependent: :destroy

  validates :first_name, :last_name, :birthday, :gender, :height, :weight,
            presence: true
  validates :first_name, :last_name, length: { maximum: 30 }
  validates :middle_name, length: { maximum: 30 }, allow_nil: true
  validates :height, numericality: {
    only_integer: true,
    greater_than_or_equal_to: 50,
    less_than_or_equal_to: 800
  }
  validates :weight, numericality: {
    greater_than_or_equal_to: 0,
    less_than_or_equal_to: 800
  }
  validate :birthday_range
  validate :unique_fullname_birthday_validate
  validates :gender, inclusion: {
    in: %w[M F],
    message: "%{value} is not a valid gender"
  }

  def age
    now = Time.now.utc.to_date
    now.year - birthday.year - (
      birthday.to_date.change(year: now.year) > now ? 1 : 0)
  end

  private

  def birthday_range
    return unless birthday
    if birthday > Date.current
      errors.add(:birthday, "the birthday exceeds today's date")
    elsif birthday < Date.current - 150.years
      errors.add(:birthday, "the birthday cannot be more than 150 years ago")
    end
  end

  def unique_fullname_birthday_validate
    existing_patient = Patient.where(
      first_name: first_name,
      middle_name: middle_name,
      last_name: last_name,
      birthday: birthday
    ).where.not(id: id).first

    if existing_patient
      errors.add(
        :base, "Patient with same full name and birthday already exists")
    end
  end
end
