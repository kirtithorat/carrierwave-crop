# encoding: utf-8

module CarrierWave
  module Crop
    class Railtie < Rails::Railtie
      initializer 'carrierwave.crop' do
        ActiveSupport.on_load :active_record do
          extend ModelAdditions::ClassMethods
          include ModelAdditions::InstanceMethods
        end
      end
    end
  end
end
