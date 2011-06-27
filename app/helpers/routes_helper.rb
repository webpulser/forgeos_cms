module RoutesHelper
  def page_path(*args)
    super(extract_page_options(args))
  end

  def page_url(*args)
    super(extract_page_options(args))
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
