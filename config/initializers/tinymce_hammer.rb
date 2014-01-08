Tinymce::Hammer.install_path = '/libs/tiny_mce'

Tinymce::Hammer.plugins = %w(safari table advimage advlink inlinepopups preview media contextmenu paste directionality fullscreen noneditable visualchars nonbreaking xhtmlxtras)

Tinymce::Hammer.init = [
  [:paste_convert_middot_lists, true],
  [:paste_remove_spans, true],
  [:paste_remove_styles, true],
  [:paste_strip_class_attributes, 'all'],
  
  [:theme, 'advanced'],
  [:theme_advanced_toolbar_location, 'top'],
  [:theme_advanced_toolbar_align, 'left'],
  [:theme_advanced_statusbar_location, 'bottom'],
  [:theme_advanced_resizing, true],
  #[:theme_advanced_resize_horizontal, false],
  
  [:relative_urls, false],
  [:convert_urls, true],
  
  [:theme_advanced_buttons1, 'undo,redo,|,cut,copy,paste,pastetext,pasteword,selectall,|,link,unlink,anchor,image,|,cleanup,removeformat,visualaid,|,code'],
  [:theme_advanced_buttons2, 'bold,italic,strikethrough,|,justifyleft,justifycenter,justifyright,justifyfull,|,bullist,numlist,|,sub,sup,charmap,|,formatselect'],
  #[:theme_advanced_buttons3, ''],
  #[:theme_advanced_buttons4, ''],
  
  #[:theme_advanced_buttons3, 'tablecontrols'],
  [:theme_advanced_buttons3, 'underline,media,forecolor,backcolor,|,ltr,rtl,|,formatselect,fontsizeselect,|,preview,fullscreen,help'],

  #[:valid_elements, "a[href|title],blockquote[cite],br,caption,cite,code,dl,dt,dd,em,i,img[src|alt|title|width|height|align],li,ol,p,pre,q[cite],small,strike,strong/b,sub,sup,u,ul"],
]
