module Imdb

  # Represents a Movie on IMDB.com
  class Movie
    attr_accessor :id, :url, :title

    # Initialize a new IMDB movie object with it's IMDB id (as a String)
    #
    #   movie = Imdb::Movie.new("0095016")
    #
    # Imdb::Movie objects are lazy loading, meaning that no HTTP request
    # will be performed when a new object is created. Only when you use an 
    # accessor that needs the remote data, a HTTP request is made (once).
    #
    # params:
    # attributes a hash of Symbol => value
    # attributes[:locale] the locale to use for the DB query
    def initialize(imdb_id, attributes={})
      @id = imdb_id
      @url = "http://www.imdb.com/title/tt#{imdb_id}/"
      attributes={:title => attributes} if attributes.kind_of?(String)
      @locale = attributes.delete(:locale)
      @attributes=attributes
      @attributes[:title] = @attributes[:title].gsub(/"/, "") if @attributes[:title]

    end

    def reload
      @attributes={}
      @document=nil
      self
    end

    # Returns an array with cast members
    def cast_members
      document.xpath("//*[@class='cast_list']//*[@itemprop='actor']//*[@itemprop='name']").map { |elem|
        elem.text.imdb_unescape_html } rescue []
    end

    def cast_member_ids
      ids=document.xpath("//*[@class='cast_list']//*[@itemprop='actor']//*[@itemprop='url']").map { |elem|
        elem['href'] =~ %r{^/name/(nm\d+)}
        $1
      } rescue []
      ids
    end

    # Returns the name(s) of the director(s)
    def director
      document.xpath("//*[@itemprop='director']//*[@itemprop='name']").map { |elem|
        elem.text.imdb_unescape_html
      } rescue []
    end

    # Returns an array of genres (as strings)
    def genres
      document.xpath("//*[@itemprop='genre']//a").map { |elem|
              elem.text.imdb_unescape_html
      } rescue []
    end

    # Returns an array of languages as strings.
    def languages
      #document.xpath("h4[text()='Language:'] ~ a[@href*='/language/']").map { |link| link.innerHTML.imdb_unescape_html }
      document.xpath("//h4[normalize-space(.)='Language:']").first.parent.xpath("a").
          map { |link| link.text.imdb_unescape_html } rescue []
    end

    # Returns the duration of the movie in minutes as an integer.
    def length
      document.xpath("//h4[normalize-space(.)='Runtime:']").first.next_element.text.to_i rescue nil
    end

    # Returns a string containing the plot.
    def plot
      sanitize_plot(document.xpath("//*[@itemprop='description']").first.text.imdb_unescape_html) rescue nil
    end

    # Returns a string containing the URL to the movie poster.
    def poster
      src = document.xpath("//td[@id='img_primary']//img")
      return nil if src.empty?
      src=src.first['src']
      case src
        when /^(http:.+@@)/
          $1 + '.jpg'
        when /^(http:.+?)\.[^\/]+$/
          $1 + '.jpg'
      end
    end

    # Returns a float containing the average user rating
    def rating
      document.css(".star-box-giga-star").text.imdb_unescape_html.to_f rescue nil
    end

    # Returns a string containing the tagline
    def tagline
      document.xpath("//h4[text()='Taglines:']").first.next_sibling.text.imdb_unescape_html rescue nil
    end

    # Returns a string containing the mpaa rating and reason for rating
    #def mpaa_rating
    #  document.search("h4[text()*='Motion Picture Rating']").first.next_sibling.to_s.strip.imdb_unescape_html rescue nil
    #end

    # Returns a string containing the title
    def title
      attr(:title) do
        document.xpath("//*[@class='header']//*[@class='itemprop' and @itemprop='name']").text.imdb_unescape_html
      end
    end

    def original_title
      attr(:original_title) do
        document.xpath("//*[@class='header']//*[@class='title-extra' and @itemprop='name']").children.first.text.imdb_unescape_html
      end
    end

    # Returns an integer containing the year (CCYY) the movie was released in.
    def year
      attr(:year) do
        document.xpath('//*[@class="header"]//a[starts-with(@href,"/year/")]').text.imdb_unescape_html.to_i
      end
    end

    # Returns release date for the movie.
    def release_date
      sanitize_release_date(document.xpath("//h4[normalize-space(.)='Release Date:']").first.next.text) rescue nil
    end

    private

    # Returns a new Hpricot document for parsing.
    def document
      @document ||= Nokogiri::HTML(Imdb::Utils.get_page("/title/tt#{@id}/", @locale))
    end

    # Convenience method for search
    def self.search(query)
      Imdb::Search.new(query).movies
    end

    def self.top_250
      Imdb::Top250.new.movies
    end

    def sanitize_plot(the_plot)
      the_plot.gsub(/\s*See full summary.*/, '')
    end

    def sanitize_release_date(date)
      date.strip.imdb_unescape_html.gsub("\n", ' ')
    end

    def attr(name, on_fail=nil)
      return @attributes[name] if @attributes.has_key?(name)
      #@attributes[name] = yield
      @attributes[name] = (yield rescue on_fail)
    end

  end # Movie

end # Imdb
