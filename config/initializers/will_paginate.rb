#ActionController::Base.rescue_responses['WillPaginate::InvalidPage'] = :not_found
WillPaginate::ViewHelpers.pagination_options[:previous_label] = '&laquo; Prev'
WillPaginate::ViewHelpers.pagination_options[:next_label]     = 'Next &raquo;'
WillPaginate::ViewHelpers.pagination_options[:page_links]     =  true

#how many links are shown around the current page (default: 4)
WillPaginate::ViewHelpers.pagination_options[:inner_window] = 3

#how many links are around the first and the last page (default: 1)
WillPaginate::ViewHelpers.pagination_options[:outer_window] = 0
