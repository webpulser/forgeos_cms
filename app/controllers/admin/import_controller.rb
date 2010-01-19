class Admin::ImportController < Admin::BaseController
  map_fields :create_page, %w(SingleKey Title* Url* Content* Categories)
  before_filter :cms_models, :only => :index

  def create_page
    create_model(Page,'single_key') do |row|
      attributes = {} 
      %w(single_key title url content).each_with_index do |attribute,i|
        attributes[attribute.to_sym] = row[i] if row[i]
      end
      attributes[:page_category_ids] = PageCategory.find_all_by_name(row[4].split(','), :select=>'id').map(&:id) if row[4]
      attributes
    end
  end

  private

  def cms_models
    @models << 'page'
  end
end
