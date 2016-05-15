class CreateWords < ActiveRecord::Migration
  def change
    create_table :words do |t|
      t.string :description
      t.belongs_to :color

      t.timestamps
    end
  end
end
