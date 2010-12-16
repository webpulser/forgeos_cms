class CreateNewsletter < ActiveRecord::Migration
  def self.up
    create_table :newsletters do |t|
        t.column :email, :string
        t.timestamps
    end
  end

  def self.down
    drop_table :newsletters
  end
end
