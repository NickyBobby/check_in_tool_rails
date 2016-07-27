class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.references :location, index: true, foreign_key: true
      t.references :user, index: true, foreign_key: true
      t.datetime :start_time
      t.datetime :end_time

      t.timestamps null: false
    end
  end
end
