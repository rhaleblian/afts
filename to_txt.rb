#!/usr/bin/env ruby

require 'rubygems'
require 'mechanize'
require 'open-uri'
require 'hpricot'

originalurl = 'http://taxreview.treasury.gov.au/content/submission.aspx?round=1'
baseurl = 'http://ray.haleblian.com/taxreview/html'

agent = WWW::Mechanize.new
doc = agent.get(baseurl + '/autoindex.html')
doc.links.each do |link|
  if(link.to_s =~ /s\.html/)
    puts link.uri.to_s
    url = baseurl + '/' + link.to_s.strip
    d = Hpricot(open(url))
    textfile = open(link.to_s.strip + '.txt','w')
    textfile << d.to_plain_text
    textfile.close
  end
end
