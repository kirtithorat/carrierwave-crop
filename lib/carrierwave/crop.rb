require "carrierwave"
require "carrierwave/crop/version"
require "carrierwave/crop/model_additions"
if defined? Rails
  require 'carrierwave/crop/engine'
  require "carrierwave/crop/railtie"
  require 'carrierwave/crop/helpers'
end
