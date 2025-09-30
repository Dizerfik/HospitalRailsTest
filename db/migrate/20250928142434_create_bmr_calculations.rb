class CreateBmrCalculations < ActiveRecord::Migration[8.0]
  def change
    create_table :bmr_calculations do |t|
      t.references :patient,
                   null: false, foreign_key: { on_delete: :cascade }
      t.string :formula, null: false
      t.integer :physical_activity, null: false
      t.decimal :value, precision: 7, scale: 3, null: false
      t.timestamps
    end

    add_check_constraint :bmr_calculations,
                         "physical_activity BETWEEN 0 AND 4",
                         name: 'chk_physical_activity'
  end
end
