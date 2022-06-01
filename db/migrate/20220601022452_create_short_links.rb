class CreateShortLinks < ActiveRecord::Migration[5.2]
  def change
    create_table :short_links do |t|
      t.string :slug, index: true, unique: true, limit: 100
      t.string :destination_url, limit: 255
      t.timestamps
    end
  end
end
