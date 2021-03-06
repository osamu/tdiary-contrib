# pathtraq_counter.rb $Revision 1.0 $
#
# Copyright (c) 2008 SHIBATA Hiroshi <shibata.hiroshi@gmail.com>
# You can redistribute it and/or modify it under GPL2.
#

require 'timeout'
require 'open-uri'
begin
	require 'json'
rescue
	retry if require 'rubygems'
end

def call_pathtraq_json( url, mode )
	json = nil
	begin
		timeout(10) do
			open( "http://api.pathtraq.com/page_counter?api=json&url=#{url}&m=#{mode}" ) do |f|
				json = JSON.parse( f.read )
			end
		end
	rescue => e
		@logger.debug( e )
	end
	return json
end

def pathtraq_counter
	url = @conf.base_url
	mode = ['popular', 'hot', 'upcoming'] 

	r = %Q|<ul>\n|
	begin
		mode.each do |m|
			json = call_pathtraq_json( url, m )
			r << %Q|<li>#{m}: #{json["count"]} hits</li>\n| unless json.nil?
		end
	rescue => e
		@logger.debug( e )
	end
	r << %Q|</ul>\n|
	r << %Q|<div class="iddy"><span class="iddy-powered">Powered by <a href="http://pathtraq.com/">Pathtraq</a></span></div>\n|

	return r
end
