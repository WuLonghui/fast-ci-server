class CreateRepositories < ActiveRecord::Migration
  def change
    create_table :repositories do |t|

      t.timestamps null: false
    end
  end
end
