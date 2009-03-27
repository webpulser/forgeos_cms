namespace :rails_content do
  task :sync do
    public_path = File.join(RAILS_ROOT, 'vendor', 'plugins', 'rails_content', 'public')
    system "rsync -rvC #{public_path} #{RAILS_ROOT}"
  end
end

