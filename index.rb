#!/usr/bin/env ruby

require 'rubygems'
require 'mechanize'
require 'open-uri'
require 'hpricot'
require 'ferret'
include Ferret

originalurl = 'http://taxreview.treasury.gov.au/content/submission.aspx?round=1'
baseurl = 'http://ray.haleblian.com/taxreview/html'
agent = WWW::Mechanize.new
index = Index::Index.new

doc = agent.get(baseurl + '/autoindex.html')
doc.links.each do |link|
  if(link.to_s =~ /s\.html/)
    puts link.uri.to_s
    url = baseurl + '/' + link.to_s.strip
    d = Hpricot(open(url))
    textfile = open(link.to_s.strip + '.txt','w')
    textfile << d.to_plain_text
    textfile.close
    #index << {:title => link.to_s.strip, :content => d.to_plain_text}    
  end
end

#index.search_each('content:"quick brown fox"') do |id, score|
#  puts "Document #{id} found with a score of #{score}"
#end
