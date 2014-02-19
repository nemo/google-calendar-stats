class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.datetime :created
      t.datetime :start_time
      t.datetime :end_time
      t.text :html_link
      t.string :event_id
      t.string :organizer
      t.string :creator
      t.text :description
      t.string :summary
      t.string :status
      t.integer :duration

      t.timestamps
    end
  end
end
