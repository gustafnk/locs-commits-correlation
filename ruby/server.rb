require 'sinatra'
require 'json'
require_relative 'correlation_status_helper'

def start_server(code_files, slope, intersect, r_squared)
  
  locs_sorted = code_files.sort_by { |item| item.loc }
  number_of_commits_sorted = code_files.sort_by { |item| item.number_of_commits }

  statistics_hash = {
      slope: slope,
      intersect: intersect,
      r_squared: r_squared,
      correlation_status: get_correlation_status(r_squared) 
  }

  get '/' do
    erb :index, locals: {
      code_files: locs_sorted.last(20), 
      property: :loc,
      property_name: 'Lines of code'
    }.merge(statistics_hash)
  end
  
  get '/json' do
    content_type :json

    locs_sorted.map(&:loc).to_json
  end
  
  get '/commits' do
    erb :index, locals: {
      code_files: number_of_commits_sorted.last(20), 
      property: :number_of_commits,
      property_name: 'Number of commits'
    }.merge(statistics_hash)
  end
  
  get '/commits/json' do
    content_type :json

    number_of_commits_sorted.map(&:number_of_commits).to_json
  end

  enable :run
end
