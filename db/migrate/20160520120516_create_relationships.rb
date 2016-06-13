class CreateRelationships < ActiveRecord::Migration
  def change
    create_table :relationships do |t|
      t.belongs_to :word, index: true
      t.belongs_to :emotion, index: true

      t.timestamps
    end
  end
end
