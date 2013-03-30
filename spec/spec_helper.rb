require 'fakeweb'

$:.unshift(File.dirname(__FILE__) + '/../lib')
require 'imdb'

def read_fixture(path)
  File.read(File.expand_path(File.join(File.dirname(__FILE__), "fixtures", path)))
end

IMDB_SAMPLES = { 
  "http://www.imdb.com:80/find?q=Kannethirey+Thondrinal;s=tt" => "search_kannethirey_thondrinal",
  "http://www.imdb.com:80/find?q=Matrix+Revolutions;s=tt" => "search_matrix_revolutions",
  "http://www.imdb.com:80/find?q=Star+Trek;s=tt" => "search_star_trek",
  "http://www.imdb.com:80/title/tt0117731/" => "tt0117731",
  "http://www.imdb.com:80/title/tt0095016/" => "tt0095016",
  "http://www.imdb.com:80/title/tt0242653/" => "tt0242653",
  "http://www.imdb.com/title/tt0242653/?fr=c2M9MXxsbT01MDB8ZmI9dXx0dD0xfG14PTIwfGh0bWw9MXxjaD0xfGNvPTF8cG49MHxmdD0xfGt3PTF8cXM9TWF0cml4IFJldm9sdXRpb25zfHNpdGU9ZGZ8cT1NYXRyaXggUmV2b2x1dGlvbnN8bm09MQ__;fc=1;ft=20" => "tt0242653",
  "http://www.imdb.com:80/chart/top" => "top_250",
  "http://www.imdb.com/title/tt0111161/" => "tt0111161",
  "http://www.imdb.com/title/tt1352369/" => "tt1352369",
  "http://www.imdb.com/title/tt0083987/" => "tt0083987",
  "http://www.imdb.com/title/tt0036855/" => "tt0036855",
  "http://www.imdb.com/title/tt0110912/" => "tt0110912",
  "http://www.imdb.com/title/tt0330508/" => "tt0330508",
  "http://www.imdb.com/title/tt0330508/?fr=c2M9MXxsbT01MDB8ZmI9dXx0dD0xfG14PTIwfGh0bWw9MXxjaD0xfGNvPTF8cG49MHxmdD0xfGt3PTF8cXM9S2FubmV0aGlyZXkgVGhvbmRyaW5hbHxzaXRlPWFrYXxxPUthbm5ldGhpcmV5IFRob25kcmluYWx8bm09MQ__;fc=1;ft=1" => "tt0330508"
}

unless ENV['LIVE_TEST']
  FakeWeb.allow_net_connect = false
  IMDB_SAMPLES.each do |url, response|
    FakeWeb.register_uri(:get, url, :response => read_fixture(response))
  end
end
