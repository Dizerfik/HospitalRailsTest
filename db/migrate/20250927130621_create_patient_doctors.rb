class CreatePatientDoctors < ActiveRecord::Migration[8.0]
  def change
    create_table :patient_doctors do |t|
      t.references :patient,
                   null: false, foreign_key: { on_delete: :cascade }
      t.references :doctor,
                   null: false, foreign_key: { on_delete: :cascade }
      t.timestamps
    end

    add_index :patient_doctors, [ :patient_id, :doctor_id ], unique: true
  end
end
