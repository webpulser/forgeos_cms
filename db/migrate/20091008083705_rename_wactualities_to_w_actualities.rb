class RenameWactualitiesToWActualities < ActiveRecord::Migration
  def self.up
    rename_column :actualities , :wactuality_id, :widget_actuality_id
  end

  def self.down
    rename_column :actualities , :widget_actuality_id, :wactuality_id
  end
end
