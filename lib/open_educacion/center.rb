require 'net/https'
require 'open-uri'
require 'nokogiri'
require 'logger'
require 'cgi'

module OpenEducacion
  class Center

    attr_accessor :code, :name, :type, :link, :province

    def initialize(options = {})
      @name     = options[:name]
      @code     = options[:code].to_i
      @type     = options[:type]
      @link     = options[:link]
      @province = options[:province]
    end
  
  end
end