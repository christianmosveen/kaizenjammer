require 'rubygems'
require 'sinatra'
require 'datamapper'

DataMapper::setup(:default, "sqlite3://#{Dir.pwd}/kaizenjammer.db")

class Kaizen
	include DataMapper::Resource
	property :id, Serial
	property :content, Text, :required => true
	property :complete, Boolean, :required => true, :default => false
	property :created_at, DateTime
	property :votes, Number, :default => 0
end

DataMapper.finalize.auto_upgrade!

get '/' do
	@notes = Kaizen.all :order => :id.desc
	@title = 'All Kaizens'
	erb :home
end