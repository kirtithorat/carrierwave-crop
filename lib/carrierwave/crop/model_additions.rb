module Carrierwave
  module Crop
    module ModelAdditions

      module ClassMethods

        ## Adding dynamic attribute accessors
        def crop_uploaded(attachment)

          [:crop_x, :crop_y, :crop_w, :crop_h, :field_name].each do |a|
            attr_accessor :"#{attachment}_#{a}"
          end
          attr_accessor :attachment_field_name
          after_update :"recreate_#{attachment}_versions"
        end
      end

      module InstanceMethods

        def cropping?(attachment)
          !self.send(:"#{attachment}_crop_x").blank? &&
            !self.send(:"#{attachment}_crop_y").blank? &&
            !self.send(:"#{attachment}_crop_w").blank? &&
            !self.send(:"#{attachment}_crop_h").blank?
        end

        def reset_crop_attributes(attachment)
          [:crop_x, :crop_y, :crop_w, :crop_h].each do |a|
            self.send :"#{attachment}_#{a}=", nil
          end
        end

        def method_missing(method, *args)
          if method.to_s =~ /recreate_(\S{1,})_versions/
            crop_image(
              method.to_s.scan(/recreate_(\S{1,})_versions/).flatten.first.to_sym
            )
          else
            super
          end
        end

        def crop_image(attachment)
          if cropping?(attachment)
            attachment_instance = send(attachment_name)
            self.send(:"attachment_field_name=",attachment)
            attachment_instance.recreate_versions!

            reset_crop_attributes(attachment_name)
          end
        end

      end
    end

    module Uploader

      def crop
        resize_to_limit(600, 600)
        manipulate! do |img|
          attachment = model.send(:attachment_field_name)
          x = model.send("#{attachment}_crop_x").to_i
          y = model.send("#{attachment}_crop_y").to_i
          w = model.send("#{attachment}_crop_w").to_i
          h = model.send("#{attachment}_crop_h").to_i
          img.crop!(x, y, w, h)
        end
      end
    end
  end
end


if defined? CarrierWave::Uploader::Base
  CarrierWave::Uploader::Base.class_eval do
    include Carrierwave::Crop::Uploader
  end
end
