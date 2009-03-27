# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper

  def display_standard_flashes(message = nil)
    if !flash[:notice].nil? && !flash[:notice].blank?
      flash_to_display, level = flash[:notice], 'notice'
      flash[:notice] = nil
    elsif !flash[:error].nil? && !flash[:error].blank?
      level = 'error'
      if flash[:error].instance_of? ActiveRecord::Errors
        flash_to_display = (message.nil? ? '' : '<span>%s</span>' % message)
        flash_to_display << activerecord_error_list(flash[:error])
      else
        flash_to_display = '<span>%s</span>' % flash[:error]
      end
      flash[:error] = nil
    else
      return
    end
    content_tag('div', flash_to_display, {:class => level})
  end

  def activerecord_error_list(errors)
    '<ul class="error_messages_list"> %s </ul>' %
    errors.collect{ |e, m| "<li>#{e.humanize unless e == 'base'} #{m}</li>" }.to_s
  end

  def yield_for_tools
    return '' unless @content_for_tools
    out = ''
    @content_for_tools.each do |content|
      out += content_tag('li', content)
    end
    return out
  end
end
