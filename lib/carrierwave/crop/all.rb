# encoding: utf-8

require "carrierwave/crop/version"
require "carrierwave/crop/error"

if defined? Rails
  require "carrierwave/crop/engine"
  require 'carrierwave/crop/helpers'
  require "carrierwave/crop/model_additions"
  require "carrierwave/crop/railtie"
end
