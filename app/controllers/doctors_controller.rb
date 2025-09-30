class DoctorsController < ApplicationController
  before_action :set_doctor, only: %i[ show edit update destroy ]
  # GET /doctors or /doctors.json
  def index
    limit = [ (params[:limit] || Constants::Pagination::DEFAULT).to_i,
              Constants::Pagination::MAX ].min
    offset = (params[:offset] || 0).to_i
    doctors = Doctor.limit(limit).offset(offset)
    render json: {
      total: Doctor.count, limit: limit, offset: offset, doctors: doctors }
  end

  # GET /doctors/1 or /doctors/1.json
  def show
    render json: @doctor.as_json(include: :patients)
  end

  # POST /doctors or /doctors.json
  def create
    doctor = Doctor.new(doctor_params)
    if doctor.save
      render json: doctor, status: :created
    else
      render json: {
        errors: doctor.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /doctors/1 or /doctors/1.json
  def update
    if @doctor.update(doctor_params)
      render json: @doctor
    else
      render json: {
        errors: @doctor.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # DELETE /doctors/1 or /doctors/1.json
  def destroy
    @doctor.destroy
    head :no_content
  end

  private

  def set_doctor
    @doctor = Doctor.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: { error: "Doctor not found" }, status: :not_found
  end

  def doctor_params
    params.require(:doctor).permit(:first_name, :last_name, :middle_name)
  end
end
