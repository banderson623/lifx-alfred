#!/usr/bin/env ruby
# encoding: utf-8

require 'rubygems' unless defined? Gem
require "./bundle/bundler/setup"
require "alfred"
require 'lifx'

class LifxWrapper
  attr_reader :client, :bulbs

  def initialize
    @client = LIFX::Client.lan
    @bulbs = []
    get_bulbs
  end

  def bulb_names
    @bulbs.collect{|b| b.label}
  end

  private

  def get_bulbs
    @client.discover! do |c|
      @bulbs << c.lights
    end
  end

end

Alfred.with_friendly_error do |alfred|
  fb = alfred.feedback
  lifx = LifxWrapper.new
  
  # lifx.bulbs.each do |b|

    # fb.add_item({
    #   :uid => b.id,
    #   :title => b.label,
    #   :subtitle => b.color.inspect,
    #   :arg => "this is the arg",
    #   :valid => "yes"
    # })
  # end

  fb.add_item({
    :uid => '',
    :title => 'list',
    :subtitle => 'List all lights',
    :arg => "list",
    :valid => "yes"
  })

  if ARGV[0].eql? "failed"
    alfred.with_rescue_feedback = true
    raise Alfred::NoBundleIDError, "Wrong Bundle ID Test!"
  end

  puts fb.to_xml(ARGV)
end


# Alfred.with_friendly_error do |alfred|
#   alfred.with_rescue_feedback = true
#   alfred.with_cached_feedback do
#     # expire in 1 hour
#     # use_cache_file :expire => 3600
#     # or define your own cache file
#     # use_cache_file(
#     #   :file   => File.join(alfred.volatile_storage_path ,"this_workflow.alfred2feedback") ,
#     #   :expire => 3600
#     # )

#   end

#   # prepend ! in query to refresh
#   is_refresh = false
#   if ARGV[0] == '!'
#     is_refresh = true
#     ARGV.shift
#   end

#   if !is_refresh and fb = alfred.feedback.get_cached_feedback
#     # cached feedback is valid
#     puts fb.to_alfred
#   else
#     fb = alfred.feedback
#     # ... generate_feedback as usually
#     fb.put_cached_feedback
#   end
# end