class RemoveWidgetsWnewsCarouselsTables < ActiveRecord::Migration
  def self.up
    drop_table :widgets
    drop_table :wnews
    drop_table :carousels
    drop_table :pages_widgets
  end

  def self.down
    create_table "widgets", :force => true do |t|
      t.integer  "widgetable_id"
      t.string   "widgetable_type"
      t.datetime "created_at"
      t.datetime "updated_at"
    end

    create_table "wnews", :force => true do |t|
      t.string   "title"
      t.date     "news_since"
      t.datetime "created_at"
      t.datetime "updated_at"
    end

    create_table "carousels", :force => true do |t|
        t.string   "title"
        t.datetime "created_at"
        t.datetime "updated_at"
    end

    create_table "pages_widgets", :id => false, :force => true do |t|
      t.integer "widget_id"
      t.integer "page_id"
      t.integer "position"
    end

  end
end
