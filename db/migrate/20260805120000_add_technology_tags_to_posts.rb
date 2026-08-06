class AddTechnologyTagsToPosts < ActiveRecord::Migration[8.1]
  def change
    add_column :posts, :technology_tags, :json, default: [], null: false
  end
end
