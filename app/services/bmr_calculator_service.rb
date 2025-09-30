class BmrCalculatorService
  def initialize(patient)
    @patient = patient
  end

  def calculate(formula, physical_activity)
    weight = @patient.weight.to_f
    height = @patient.height.to_f
    age = calculate_age(@patient.birthday)
    gender = (@patient.gender)
    method_name = FormulaConstants::FORMULAS[formula]
    puts 1
    puts formula
    send(method_name, weight, height, age, gender, physical_activity)
  end

  private

  def calculate_age(birthday)
    now = Date.current
    age = now.year - birthday.year
    age -= 1 if (birthday + age.years) > now
    age
  end

  def mifflin_san_jeor(weight, height, age, gender, physical_activity)
    puts 1
    puts weight, height, age, gender, physical_activity
    value = 10 * weight + 6.25 * height - 5 * age
    if gender == Constants::Gender::MALE
      (value + 5) * FormulaConstants::ACTIVITY[physical_activity]
    else
      (value - 161) * FormulaConstants::ACTIVITY[physical_activity]
    end
  end

  def harris_benedict(weight, height, age, gender, physical_activity)
    if gender == Constants::Gender::MALE
      (88.362 + (13.397 * weight) + (4.799 * height) - (5.677 * age)) *
        FormulaConstants::ACTIVITY[physical_activity]
    else
      (447.593 + (9.247 * weight) + (3.098 * height) - (4.330 * age)) *
        FormulaConstants::ACTIVITY[physical_activity]
    end
  end
end
