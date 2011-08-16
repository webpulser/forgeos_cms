load File.join(Gem.loaded_specs['forgeos_core'].full_gem_path, 'app', 'controllers', 'admin', 'base_controller.rb')
Admin::BaseController.class_eval do
  before_filter :forgeos_cms_javascripts_files, :except => [:notifications, :url]

private

  def forgeos_cms_javascripts_files
    @forgeos_js_functions_files += forgeos_javascripts_files('forgeos_cms', 'forgeos/admin/functions')
    @forgeos_js_inits_files += forgeos_javascripts_files('forgeos_cms', 'forgeos/admin/inits')
  end
end
