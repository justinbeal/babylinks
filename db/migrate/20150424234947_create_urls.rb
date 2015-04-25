class CreateUrls < ActiveRecord::Migration
  def change
    create_table :urls, :id => false do |t|
      t.string :short_url, :null => false
      t.string :long_url, :null => false
      t.timestamps null: false
    end

    add_index :urls, :short_url, :unique => true
    add_index :urls, :long_url
  end
end
