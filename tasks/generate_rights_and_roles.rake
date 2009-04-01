require 'active_record/fixtures'

namespace :rails_content do
	namespace :generate do

	  desc "Generates a role per controller and a right per controller action."
	  task :rights_and_roles => :environment do
      
      # set project path
      # By default, plugin path
      # else path is set to the first argument provided.
      if ARGV[1] && !ARGV[1].blank?
        project_path = ARGV[1]
      else
        project_path = File.join(RAILS_ROOT, 'vendor', 'plugins', 'rails_content')
      end

      # list admin controllers
	    path = File.join(project_path, 'app', 'controllers', 'admin')

	    if File.directory? path
	      # create a role for each controller and its associated actions rights
	      Dir.foreach(path) do |filename| 
          next if filename.match(/^\./) or !filename.match(/\.rb$/) or File.directory?(File.join(path, filename))
          
          controller_underscore = filename.gsub(".rb", "")
          controller_name = controller_underscore.gsub("_controller", "")
          controller = ("admin/"+controller_underscore).camelize.constantize

          print "generating role #{controller_name}..."
          role = Role.find_or_create_by_name controller_name

          # create a right per controller action
          controller.action_methods.reject { |action| ApplicationController.action_methods.include?(action) }.each do |action|
            right = Right.find_or_create_by_name_and_controller_name_and_action_name "#{controller_name}_#{action}", "admin/#{controller_name}", action
            role.rights << right unless role.rights.include? right
          end
          puts 'ok'

          # add this new role to the admin roles
          admin = Admin.find_by_id(Fixtures.identify('administrator'))
          admin.roles << role unless admin.roles.find_by_name(role.name)

          # add all rights of role to the admin
          role.rights.each do |right|
            admin.rights << right unless admin.rights.find_by_name(right.name)
          end
	      end
	    end
	  end
	end
end
