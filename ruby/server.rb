require 'sinatra'
require 'json'
require_relative 'correlation_status_helper'

class Resource
  attr_reader :path, :property, :property_name

  def initialize(path, property, property_name)
    @path = path
    @property = property
    @property_name = property_name
  end
end


def start_server(code_files, slope, intersect, r_squared)

  locs_sorted = code_files.sort_by { |item| item.loc }
  number_of_commits_sorted = code_files.sort_by { |item| item.number_of_commits }

  statistics_hash = {
    slope: slope,
    intersect: intersect,
    r_squared: r_squared,
    correlation_status: get_correlation_status(r_squared) 
  }

  resources = [
    Resource.new('/', :loc, 'Lines of code'),
    Resource.new('/commits', :number_of_commits, 'Number of commits'),
    Resource.new('/commits_per_loc', :commits_per_loc, 'Commits per loc'),
    Resource.new('/loc_per_commits', :loc_per_commits, 'Loc per commits'),
  ]

  resources.each do |resource|
    files = code_files.sort_by { |item| item.send(resource.property)}.last(20)

    get resource.path do
      erb :index, locals: {
        code_files: files,
        property: resource.property,
        property_name: resource.property_name
      }.merge(statistics_hash)
    end

    get resource.path.sub(/(\/)+$/,'') + '/json' do
      content_type :json

      files.map {|item| item.send(resource.property) }.to_json
    end
  end

  enable :run
end
