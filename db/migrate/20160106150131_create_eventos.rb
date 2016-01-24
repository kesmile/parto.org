class CreateEventos < ActiveRecord::Migration
  def change
    create_table :eventos do |t|
      t.string :tipo
      t.string :usuario
      t.string :telefono
      t.timestamp :fecha
      t.boolean :status
      t.string :categoria
      t.timestamp :fecha_gestion
      t.timestamps null: false
    end
  end
end
