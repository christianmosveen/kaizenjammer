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

get '/:id' do
	@kaizen = Kaizen.get params[:id]
	@title = "Edit kaizen ##{params[:id]}"
	erb :edit
end

put '/:id' do
	k = Kaizen.get params[:id]
	k.content = params[:content]
	k.complete = params[:complete] ? 1 : 0
	k.save
	redirect '/'
end

get '/:id/complete' do
	k = Kaizen.get params[:id]
	k.complete = k.complete ? 0 : 1
	k.save
	redirect '/'
end

get '/:id/delete' do
	@kaizen = Kaizen.get params[:id]
	@title = "Confirm deletion of kaizen ##{params[:id]}"
	erb :delete
end

delete '/:id' do
	k = Kaizen.get params[:id]
	k.destroy
	redirect '/'
end


DataMapper::setup(:default, ENV['DATABASE_URL'] || 'sqlite3://#{Dir.pwd}/kaizenjammer.db')

class Kaizen
	include DataMapper::Resource
	property :id, Serial
	property :content, Text, :required => true
	property :complete, Boolean, :required => true, :default => false
	property :created_at, DateTime
	property :score, Integer, :default => 0
	has n, :votes
	has n, :voters, :through => :votes
end

class Voter
	include DataMapper::Resource
	property :id, Serial
	property :name, Text, :required => true
	has n, :votes
	has n, :kaizens, :through => :votes
end

class Vote
	include DataMapper::Resource
	property :id, Serial
	property :created_at, DateTime
	belongs_to :kaizen
	belongs_to :voter
end

DataMapper.finalize.auto_upgrade!
