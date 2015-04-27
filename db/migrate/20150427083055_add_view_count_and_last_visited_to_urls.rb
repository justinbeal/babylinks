class AddViewCountAndLastVisitedToUrls < ActiveRecord::Migration
  def change
    add_column :urls, :view_count, :integer, :default => 0
    add_column :urls, :last_seen, :timestamp
  end
end
