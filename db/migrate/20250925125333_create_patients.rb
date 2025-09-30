class CreatePatients < ActiveRecord::Migration[8.0]
  def change
    create_table :patients do |t|
      t.string :first_name, null: false, limit: 30
      t.string :last_name, null: false, limit: 30
      t.string :middle_name, limit: 30
      t.date :birthday, null: false
      t.string :gender, null: false, limit: 1
      t.integer :height, null: false
      t.decimal :weight, null: false, precision: 6, scale: 3

      t.timestamps
    end

    add_check_constraint :patients,
                         "birthday <= CURRENT_DATE AND birthday >= CURRENT_DATE - INTERVAL '150 years'",
                         name: 'chk_patients_birthday'

    add_check_constraint :patients,
                         "gender IN ('M', 'F')",
                         name: 'chk_patients_gender'

    add_check_constraint :patients,
                         "height BETWEEN 50 AND 300",
                         name: 'chk_patients_height'

    add_check_constraint :patients,
                         "weight BETWEEN 0 AND 800",
                         name: 'chk_patients_weight'

    add_index :patients, [ :first_name, :middle_name, :last_name, :birthday ],
              unique: true, name: 'uk_patients_fullname_birthday'
  end
end
