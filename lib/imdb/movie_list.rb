module Imdb

  class MovieList
    def movies
      @movies ||= parse_movies
    end

    private

    def parse_movies
      document.xpath('//a[starts-with(@href,"/title/tt")]').reject do |element|
        element.inner_html =~ /^<img/ || element.inner_html =~ /^tt\d+/
      end.map do |element|
        id = element['href'][/\d+/]
        title = element.text.imdb_unescape_html
        year = (element.next.text.match(/\d+/)[0].to_i rescue nil)
        [id, {:title => title, :year => year}]
      end.uniq.map do |values|
        Imdb::Movie.new(*values)
      end


    end
  end # MovieList

end # Imdb
