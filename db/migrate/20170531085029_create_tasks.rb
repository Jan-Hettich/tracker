class CreateTasks < ActiveRecord::Migration
  def change
    create_table :tasks, id: :uuid do |t|
      t.references :project, type: :uuid, null: false, index: true
      t.string :name
      t.text :description
      t.integer :state, default: 10

      t.timestamps null: false
    end
  end
end
