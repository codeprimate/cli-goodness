#!/usr/local/bin/ruby

# (c)2007 Patrick Morgan All Rights Reserved.

class Array
  def uniq_by
    clean = []
    self.collect{|x| yield(x)}.uniq.each do |x|
      clean << self.select{|y| yield(y) == x}.last
    end
    clean
  end
end

class LogParser
  require 'rubygems'  
  require 'active_record'
  require 'yaml'
  require 'erb'
  include ActiveRecord
  
  attr_reader :requests, :total_queries, :db_config, :explain_tally, :qid, :logfilename

  def initialize(base_dir=".",output_file=nil)
    env = ENV["RAILS_ENV"] || "development"
    @base_dir = base_dir
    @logfilename = "#{base_dir}/log/#{env}.log"   
    configfilename = "#{base_dir}/config/database.yml"
    @outputfilename = output_file || "#{@base_dir}/explained.html"
    
    raise "Log not found at #{logfilename}" unless File.exist?(logfilename)
    raise "Database config not found.  You need to be in the rails root!" unless File.exist?(configfilename)
    
    @raw_data = File.new(logfilename,"r").read
    @db_config = YAML.load(File.new(configfilename).read)[env]
    @requests = []
    @qid = 0
    @rid = 0
  end
  
  def parse_data!(limit=nil)
    parse_log! if @requests.empty?
    @total_queries = @qid.to_i
    @requests.each do |r|
      r[:db_time] = r[:queries].inject(0.0){|sum,q| sum += q[:time]} 
      r[:queries].each do |q|
        time = (q[:time]/r[:db_time])*100.0
        if time < 1
          time = "<1%"
        else
          time = "#{time.round}%"
        end
        q[:pct_time] = time
      end 
    end
  end
  
  def parse_log!
    raw_requests = @raw_data.scan(/^Processing.+?\n\n/m).collect{|r| strip_log_formatting(r)}
    @raw_data = nil
    @requests = []
    raw_requests.each do |r|
      this_request = get_controller_and_action(r)
      this_request[:id] = new_rid
      this_request[:params] = get_params(r)
      this_request[:queries] = Array.new
      query_matches = r.scan(/^  +[A-Z][a-zA-Z]+ [a-zA-Z ]+ \(([0-9]+\.[0-9]+)\)\s+(.+)/)
      query_matches.each do |q|
        query = { :time => q[0].to_f, :query => q[1], :qid => new_qid}
        this_request[:queries] << query
      end
      this_request[:queries] = this_request[:queries].sort_by{|q| q[:time]}.reverse
      @requests << this_request unless this_request[:queries].empty?
    end
    @requests = @requests.uniq_by{|r| r[:controller] + r[:action]}.sort_by{|r| r[:controller]}
    @requests.collect!{|r| r.merge({:queries => r[:queries].uniq_by{|q| q[:query]}})}
  end
  
  def explain_requests!
    parse_data! if @requests.empty?
    Base.establish_connection(@db_config)
    @explain_tally = 0
    @requests.each do |r|
      r[:queries].each do |q|
        begin
          x = Base.connection.execute("EXPLAIN #{q[:query]}")
          q[:explain] = parse_mysql_result(x)
          @explain_tally += 1
        rescue
          q[:explain] = {:fields => "Error", :rows => "Error executing explain SQL"}
        end
      end
    end
  end
  
  def output_html
    explain_requests! if @requests.empty?
    rhtml = TEMPLATE
    File.new(@outputfilename,"w+").puts((ERB.new rhtml).result(binding))
    puts "Output to => #{@outputfilename}"
  end
  
  
  private
  
  def parse_mysql_result(mr)
    info = {:fields => [], :rows => []}
    info[:fields] = mr.fetch_fields.collect{|f| f.name}
    info[:rows] = []
    mr.num_rows.times do |r|
      mr.data_seek(r)
      info[:rows] << mr.fetch_row
    end
    return info
  end
  
  def new_qid
    @qid += 1
  end
  
  def new_rid
    @rid += 1
  end
  
  def strip_log_formatting(text)
    fcode = /\e\[[^m]+m/
    text.gsub(fcode,'')
  end
  
  def get_controller_and_action(data)
    action = nil
    controller = nil
    action_match = data.match(/Parameters: .+"action"=>"([^"]+)"/)
    action = action_match[1] if action_match
    controller_match = data.match(/Parameters: .+"controller"=>"([^"]+)"/)
    controller = controller_match[1] if controller_match  
    info_hash = {:action => action, :controller => controller}
    return info_hash
  end
  
  def get_params(data)
    params_match = data.match(/Parameters: \{(.+)\}$/)
    params = (params_match ? params_match[1] : "")
    return params
  end
    
end

TEMPLATE = %q{
  <!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
  	"http://www.w3.org/TR/html4/loose.dtd">
  <html>
  	<head>
  		<title>Explain Request SQL Queries for <%= @logfilename %></title>
  		<style>
  		*{margin:0;padding:0}table,form,fieldset,a img,iframe{border:0}td,th,caption,h1,h2,h3,h4,h5,h6{font-size:100%;font-weight:normal}ul,ol,dl,li,dt,dd{list-style:none}legend{color:#000}input,textarea,select,button{font:100% serif}table{border-collapse:collapse;margin-left:1em;max-width:700px}td,th,caption{text-align:left}body{font:12pt sans-serif}h2{font-size:1.5em}ol{margin:2em;list-style:decimal inside}lh{border-bottom:1px solid gray;font-size:1.2em}lh,p.query_sql{margin-bottom:0.5em}li{margin-left:0.5em}div.request{margin:1em;margin-bottom:2em}p.request_params{margin:0.5em;margin-top:0.2em;font-color:red}p.request_params,span.time{font-style:italic}span.time{font-size:0.75em}div.query{margin:1.5em;margin-top:0.4em;border-top:2px solid #999;border-left:1px solid #999;border-right:0;padding-top:0.2em}div.query,td{padding:0.5em}p.query_sql{font:0.9em courier}table tr,td{border:1px solid gray}td{color:#444;font-size:0.9em}tr.header td{color:black;font-weight:bold}
  		</style>
  	</head>
  	<body>
  		<a name="#contents"/>
  		<ol>
  			<lh>Contents</lh>
  		<% @requests.each do |request| %>
  			<li><a href="#r<%= request[:id] %>"><%= request[:controller]%>::<%= request[:action]%></a></li>
  		<% end %>
  		</ol>
  		<% @requests.each do |request| %>
  		<div id="r<%= request[:id]%>" class="request">
  			<h2><%= request[:controller]%>::<%= request[:action]%> <span class="time">[<%= request[:db_time] %>s] (<%= request[:queries].size%> queries)</span></h2>
  			<p class="request_params">
  				<%= request[:params]%>
  			</p>
  			<% request[:queries].each do |query| %>
  				<div class="query">
  					<p class="query_sql">
  						<b>[<%= query[:pct_time]%> <%= query[:time]%>s]</b><br/> <%= query[:query]%>
  					</p>
  					<table>
  						<tr class="header">
  						<% query[:explain][:fields].each do |f|%>
  							<td><%= f.upcase %></td>
  						<% end%>
  						</tr>
  						<% query[:explain][:rows].each do |r|%>
  							<tr>
  								<% r.each do |f|%>
  									<td><%= f.gsub(',',', ') unless f.nil? %></td>
  								<% end %>
  							</tr>
  						<% end %>
  					</table>
  				</div>
  			<% end %>
  		</div>
  		<% end %>
  	</body>
  </html>
}


LogParser.new.output_html