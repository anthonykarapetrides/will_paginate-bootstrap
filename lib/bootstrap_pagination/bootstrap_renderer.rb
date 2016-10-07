require "bootstrap_pagination/version"

module BootstrapPagination
  # Contains functionality shared by all renderer classes.
  module BootstrapRenderer
    ELLIPSIS = "&hellip;"

    def to_html
      list_items = pagination.map do |item|
        case item
          when Fixnum
            page_number(item)
          else
            send(item)
        end
      end.join(@options[:link_separator])

      tag("nav", tag("ul", list_items, class: ul_class), 'aria-label' => 'Page navigation')
    end

    def container_attributes
      super.except(*[:link_options])
    end

    protected

    def link_options
      link_options = @options[:link_options] || {}
      link_options[:class] = "%s page-link" % link_options[:class]
    end

    def page_number(page)
      if page == current_page
        tag("li", tag("span", page), class: "page-item active")
      else
        tag("li", link(page, page, link_options.merge(rel: rel_value(page))))
      end
    end

    def previous_or_next_page(page, text, classname)
      if page
        if classname == "next"
          aria_label  = "Next"
          aria_hidden = "&laquo;"
        else
          aria_label  = "Previous"
          aria_hidden = "&raquo;"
        end
        the_link = link(page, link_options.merge('aria-label' => aria_label)) do
          text + tag("span", aria_hidden, "aria-hidden" => true) + tag("span", aria_label, :class => "sr-only")
        end
        tag("li", the_link, class: "%s page-item" % classname)
      else
        tag("li", tag("span", text), class: "%s page-item disabled" % classname)
      end
    end

    def gap
      tag("li", tag("span", ELLIPSIS), class: "page-item disabled")
    end

    def previous_page
      num = @collection.current_page > 1 && @collection.current_page - 1
      previous_or_next_page(num, @options[:previous_label], "prev")
    end

    def next_page
      num = @collection.current_page < @collection.total_pages && @collection.current_page + 1
      previous_or_next_page(num, @options[:next_label], "next")
    end

    def ul_class
      ["pagination", @options[:class]].compact.join(" ")
    end
  end
end
