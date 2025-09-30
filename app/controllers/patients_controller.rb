class PatientsController < ApplicationController
  before_action :set_patient, only: %i[
   show edit update destroy bmr bmr_history bmi ]
  include Constants

  # GET /patients or /patients.json
  def index
    filter_params = {
      full_name: params[:full_name],
      gender: params[:gender],
      start_date: params[:start_date],
      end_date: params[:end_date]
    }
    patients = PatientFilterService.new(filter_params).filter
    patients = patients.includes(:doctors)
    limit = [ (params[:limit] || Constants::Pagination::DEFAULT).to_i,
              Constants::Pagination::MAX ].min
    offset = (params[:offset] || 0).to_i
    paginated = patients.limit(limit).offset(offset)

    render json: {
      total: patients.count,
      patients: paginated.as_json(include: :doctors),
      limit: limit,
      offset: offset
    }

  rescue => e
    render json: { error: e.message }, status: :unprocessable_entity
  end

  # GET /patients/1 or /patients/1.json
  def show
    render json: @patient.as_json(include: :doctors)
  rescue => e
    render json: { error: e.message }, status: :unprocessable_entity
  end

  # POST /patients or /patients.json
  def create
    patient = Patient.new(patient_params)
    if patient.save
      render json: patient.as_json(include: :doctors), status: :created
    else
      render json: {
        errors: patient.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /patients/1 or /patients/1.json
  def update
    if @patient.update(patient_params)
      attach_doctors(@patient)
      render json: @patient.as_json(include: :doctors)
    else
      render json: {
        errors: @patient.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # DELETE /patients/1 or /patients/1.json
  def destroy
    @patient.destroy
    head :no_content
  end

  def bmr
    return render json: { error: "Patient not found" },
                  status: :not_found unless @patient
    formula = params[:formula].to_s
    service = BmrCalculatorService.new(@patient)
    physical_activity = params[:physical_activity]
    result = service.calculate(formula, physical_activity)
    if result
      bmr = @patient.bmr_calculations.create!(
        formula: formula, value: result, physical_activity: physical_activity)
      render json: {
        formula: formula, bmr: result, record_id: bmr.id }, status: :ok
    else
      render json: { error: "Unknown formula" }, status: :bad_request
    end
  end

  def bmr_history
    limit = [ (params[:limit] || Constants::Pagination::DEFAULT).to_i,
              Constants::Pagination::MAX ].min
    offset = (params[:offset] || 0).to_i
    total = @patient.bmr_calculations.count
    records = @patient.bmr_calculations.order(
      created_at: :desc).limit(limit).offset(offset)
    render json: {
      total: total, limit: limit, offset: offset, records: records }
  end

  def bmi
    response = BmiCalculatorService.new.calculate(
      weight: @patient.weight, height: @patient.height)
    if response[:error]
      render json: { error: response[:error] }, status: :bad_gateway
    else
      render json: response[:body], status: :ok
    end
  end

  private

  def set_patient
    @patient = Patient.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: { error: "Patient not found" }, status: :not_found
  end

  def patient_params
    params.permit(
      :first_name, :last_name, :middle_name, :birthday, :gender, :height,
      :weight, doctor_ids: [])
  end

  def attach_doctors(patient)
    if params[:doctors].present? && params[:doctors].is_a?(Array)
      patient.doctor_ids = params[:doctors].map(&:to_i)
    end
  end
end
