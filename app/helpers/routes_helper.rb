module RoutesHelper
  def page_path(*args)
    forgeos_cms.page_path(extract_page_options(args))
  end

  def page_url(*args)
    forgeos_cms.page_url(extract_page_options(args))
  end

  def extract_page_options(args)
    options = args.dup.extract_options!
    object = args.first
    if object.kind_of?(Page)
      return options.merge(:url => object.url)
    else
      return args
    end
  end
end
