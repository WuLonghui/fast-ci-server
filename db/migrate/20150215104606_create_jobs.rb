class CreateJobs < ActiveRecord::Migration
  def change
    create_table :jobs do |t|
      t.integer :repository_id
      t.string :name
      t.string :server_url

      t.timestamps null: false
    end
  end
end
