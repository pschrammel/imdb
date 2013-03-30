require 'cgi'
 
module Imdb #:nordoc:
  module StringExtensions
    if  RUBY_VERSION.to_f < 1.9
    # Unescape HTML
    require 'iconv'
    def imdb_unescape_html
      Iconv.conv("UTF-8", 'ISO-8859-1', CGI::unescapeHTML(self))
    end
    else
    def imdb_unescape_html
      encode(Encoding::UTF_8, :invalid => :replace, :undef => :replace, :replace => '')
    end
  end
    # Strip tags
    def imdb_strip_tags
      gsub(/<\/?[^>]*>/, "")
    end
    
    # Strips out whitespace then tests if the string is empty.
    def blank?
      strip.empty?
    end unless method_defined?(:blank?)
  end
end

String.send :include, Imdb::StringExtensions
