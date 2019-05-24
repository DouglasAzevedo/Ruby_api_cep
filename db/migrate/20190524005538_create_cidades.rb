class CreateCidades < ActiveRecord::Migration[5.2]
  def change
    create_table :cidades do |t|
      t.string :codigo_ibge
      t.string :nome
      t.belongs_to :cidade, foreign_key: true

      t.timestamps
    end
  end
end