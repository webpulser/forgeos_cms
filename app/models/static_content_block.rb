class StaticContentBlock < Block
  def clone
    static_content_block = super
    static_content_block.globalize_translations = globalize_translations.clone unless globalize_translations.empty?
    %w(page_ids block_category_ids).each do |method|
      static_content_block.send("#{method}=",self.send(method))
    end
    return static_content_block
  end
end
