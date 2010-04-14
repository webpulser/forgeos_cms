namespace :forgeos do
  namespace :cms do
    task :create_page_cols, :needs => :environment do
      Page.all.each do |page|
        2.times do
          page.page_cols.create
        end if page.page_cols.empty?
      end
    end
    task :upgrade_page_to_page_cols, :needs => :environment do
      Page.all.each do |page|
       if col = page.page_cols.first
         col.update_attributes(:block_ids => page.old_block_ids, :content => page.old_content)
       end
      end
    end
  end
end
