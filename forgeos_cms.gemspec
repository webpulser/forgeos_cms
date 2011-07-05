Gem::Specification.new do |s|
  s.add_dependency 'forgeos_core', '>= 1.9.0'
  s.name = 'forgeos_cms'
  s.version = '1.9.0'
  s.date = '2011-07-05'

  s.summary = 'Cms of Forgeos plugins suite'
  s.description = 'Forgeos Cms provide pages, blocks and other cms features'

  s.authors = ['Cyril LEPAGNOT', 'Jean Charles Lefrancois']
  s.email = 'dev@webpulser.com'
  s.homepage = 'http://github.com/webpulser/forgeos_cms'

  s.files = Dir['{app,lib,config,db,recipes}/**/*', 'README*', 'LICENSE*']
end
