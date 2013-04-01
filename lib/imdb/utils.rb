module Imdb
  module Utils
    def self.get_page(path,locale=nil)
      locale ||= Imdb::Config.accept_language
      header= {"Accept-Language" => "#{locale};q=0.8,en;q=0.5"}
      #begin
      open("http://www.imdb.com#{path}",header)
      #rescue
      #  puts $!.backtrace.join("\n")
      #end
    end
  end
end 