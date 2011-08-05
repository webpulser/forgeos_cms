load File.join(Gem.loaded_specs['forgeos_core'].full_gem_path, 'app', 'controllers', 'admin', 'import_controller.rb')
Admin::ImportController.class_eval do
  map_fields :create_page, Page.new.attributes.keys
  map_fields :create_block, Block.new.attributes.keys
  before_filter :cms_models, :only => :index

  def create_page
    create_model(Page,'single_key')
  end

  def create_block
    create_model(Block,'single_key')
  end

  private

  def cms_models
    @models << 'page' << 'block'
  end
end
