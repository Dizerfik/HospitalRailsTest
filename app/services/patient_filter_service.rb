class PatientFilterService
  def initialize(params)
    @params = params
  end

  def filter
    patients = Patient.all
    patients = filter_full_name(
      patients, @params[:full_name]) if @params[:full_name].present?
    patients = filter_gender(
      patients, @params[:gender]) if @params[:gender].present?
    patients = filter_birthday_range(
      patients, @params[:start_date], @params[:end_date]) if
      @params[:start_date].present? || @params[:end_date].present?
    patients
  end

  private

  def filter_full_name(model, name)
    search_term = "%#{name}%"
    model.where(
      "first_name ILIKE ? OR last_name ILIKE ? OR middle_name ILIKE ?",
      search_term, search_term, search_term)
  end

  def filter_gender(model, gender)
    model.where(gender: gender)
  end

  def filter_birthday_range(model, start_date, end_date)
    if start_date.present? && end_date.present?
      model.where(birthday: start_date..end_date)
    elsif start_date.present?
      model.where("birthday >= ?", start_date)
    elsif end_date.present?
      model.where("birthday <= ?", end_date)
    end
  end
end
