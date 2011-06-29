Gem::Specification.new do |s|
  s.add_dependency 'rails', '>= 3.1.0.rc4'
  s.name = 'forgeos_cms'
  s.version = '1.9.9'
  s.date = '2011-06-29'

  s.summary = 'Cms of Forgeos plugins suite'
  s.description = 'Forgeos Cms provide pages, blocks and other cms features'

  s.authors = ['Cyril LEPAGNOT', 'Jean Charles Lefrancois']
  s.email = 'dev@webpulser.com'
  s.homepage = 'http://github.com/webpulser/forgeos_core'

  s.files = Dir['{app,lib}/**/*', 'README*', 'LICENSE*']
end
