class CreateDoctors < ActiveRecord::Migration[8.0]
  def change
    create_table :doctors do |t|
      t.string :first_name, null: false, limit: 30
      t.string :last_name, null: false, limit: 30
      t.string :middle_name, limit: 30
      t.timestamps
    end

    add_index :doctors, [ :first_name, :middle_name, :last_name ],
              unique: true, name: 'uk_doctors_fullname'
  end
end
