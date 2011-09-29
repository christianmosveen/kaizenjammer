require 'rubygems'
require 'sinatra'
require 'datamapper'

get '/' do
	@kaizens = Kaizen.all :order => :id.desc
	@title = 'All Kaizens'
	erb :home
end

post '/' do
	k = Kaizen.new
	k.content = params[:content]
	k.created_at = Time.now
	k.save
	redirect '/'
end

DataMapper::setup(:default, "sqlite3://#{Dir.pwd}/kaizenjammer.db")

class Kaizen
	include DataMapper::Resource
	property :id, Serial
	property :content, Text, :required => true
	property :complete, Boolean, :required => true, :default => false
	property :created_at, DateTime
	property :votes, Integer, :default => 0
end

DataMapper.finalize.auto_upgrade!