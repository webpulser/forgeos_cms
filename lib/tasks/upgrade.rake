namespace :forgeos do
  namespace :cms do
    task :create_page_cols => :environment do
      Page.all.each do |page|
        i = page.min_cols_by_page
        i.times do
          page.page_cols.create
        end if page.page_cols.empty?
      end
    end
    task :upgrade_page_to_page_cols => :environment do
      I18n.available_locales.each do |locale|
        I18n.locale = locale
        Page.all.each do |page|
         if col = page.page_cols.first
           col.update_attributes(:block_ids => page.old_block_ids, :content => page.old_content)
         end
        end
      end
    end
  end
end
