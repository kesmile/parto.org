class CreateComadronas < ActiveRecord::Migration
  def change
    create_table :comadronas do |t|
      t.string :nombre
      t.string :direccion
      t.string :telefono
      t.string :categoria
      t.string :token

      t.timestamps null: false
    end
  end
end
