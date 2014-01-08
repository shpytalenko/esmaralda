module LayoutHelper
  def title(page_title, show_title = true)
    @content_for_title = page_title.to_s
    @show_title = show_title
  end
  
  def show_title?
    @show_title
  end
  
  def stylesheet(*args)
    content_for(:head) { stylesheet_link_tag(*args.map(&:to_s)) }
  end
  
  def javascript(*args)
    args = args.map { |arg| arg == :defaults ? arg : arg.to_s }
    content_for(:head) { javascript_include_tag(*args) }
  end
  
  
  def yes_no(bool)
    bool ? 'Yes' : 'No'
  end
  
  def button_link_to(name, options = {}, html_options = nil)
    html_options ||= options.delete(:html)
    url_options = options.delete(:url)
    
    #function = update_page do |page|
    #  page.redirect_to url_options
    #end
    function = "window.location.href = \'#{url_for(url_options)}\'"
    
    function = "if (confirm('#{escape_javascript(options[:confirm])}')) { #{function}; }; return false;" if options[:confirm]
    button_to_function(name, function, html_options)
  end

  def link_to_remote_unless(condition, name, options = {}, html_options = {}, &block)
    if condition
      if block_given?
        block.arity <= 1 ? yield(name) : yield(name, options, html_options)
      else
        name
      end
    else
      link_to_remote(name, options, html_options)
    end
  end

  def link_to_function_unless(condition, name, *args, &block)
    if condition
      if block_given?
        block.arity <= 1 ? yield(name) : yield(name, *args)
      else
        name
      end
    else
      link_to_function(name, *args, &block)
    end
  end
  
  def navigation_path(arr)
    unless arr.blank?
      arr_html = []
      arr.each do |item|
        arr_html << link_to_unless(item == arr.last, h(item[:name]), item[:href], item)
      end
      arr_html.join(" &raquo; ")      
    else
      "&nbsp;"
    end
  end
  
  def navigation_path_client(arr)
    unless arr.blank?
      arr_html = []
      arr.each do |item|
        arr_html << '<li>'+link_to_unless(item == arr.last, h(item[:name]), item[:href], item)+'</li>'
      end
      '<ul class="historyNav" style="margin-bottom: 10px;">'+arr_html.join('&nbsp;<li class="sep">&nbsp;</li>&nbsp;')+'</ul>'
    else
      '&nbsp;'
    end
  end
  
  #def siger_nested_set_options(class_name, mover_id=nil)
  #  items = class_name.all_without_mover(mover_id)
  #  result = []
  #  items.each do |item|
  #    result << [yield(item), item.id]
  #  end
  #  result
  #end
  
  def siger_nested_set_options(class_name, mover_id=nil)
    result = []
    items = class_name.all_without_mover(mover_id)
    class_name.each_with_level(items) do |item, level|
      result << [yield(item, level), item.id]
    end
    result
  end
  
  
  def add_file_upload_link(name)
    link_to_function name do |page|
      page.insert_html :bottom, :images_upload_div, :partial => 'image'
    end
  end
  
  
  def display_price_or_free(price)
    (price.to_f == 0) ? "FREE" : number_to_currency(price)
  end
  
  
  def strip_white_spaces(&block)
    content = capture(&block)
    #content.squeeze!(" ")
    #content = content.to_s.dup
    
    content.gsub!(/\t+/, "")
    #content.gsub!(/\s\s+/, "")
    
    content.gsub!(/\r\n?/, "\n")  # \r\n and \r -> \n
    content.gsub!(/\n\n+/, "\n")  # 2+ newline  -> 1 newline
    
    concat(content)
  end
  
end









