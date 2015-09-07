# encoding: utf-8

module CarrierWave
  module Crop
    module ModelAdditions
      module ClassMethods

        # Adds cropping feature on a specific attribute of your model
        #
        #   crop_uploaded :avatar
        #
        # @param attachment [Symbol] Name of the attachment attribute to be cropped
        def crop_uploaded(attachment)

          [:crop_x, :crop_y, :crop_w, :crop_h, :only_version].each do |a|
            attr_accessor :"#{attachment}_#{a}"
          end
          after_update :"recreate_#{attachment}_versions"

        end

      end ## End of ClassMethods

      module InstanceMethods

        # Checks if the attachment received cropping attributes
        # @param  attachment [Symbol] Name of the attribute to be croppedv
        #
        # @return [Boolean]
        def cropping?(attachment)
          !self.send(:"#{attachment}_crop_x").blank? &&
            !self.send(:"#{attachment}_crop_y").blank? &&
            !self.send(:"#{attachment}_crop_w").blank? &&
            !self.send(:"#{attachment}_crop_h").blank?
        end

        # method_missing is used to respond to the model callback
        def method_missing(method, *args)
          if method.to_s =~ /recreate_(\S{1,})_versions/
            crop_image(method.to_s.scan(/recreate_(\S{1,})_versions/).flatten.first.to_sym)
          else
            super
          end
        end

        # Saves the attachment if the crop attributes are present
        # @param  attachment [Symbol] Name of the attribute to be cropped
        def crop_image(attachment)
          if cropping?(attachment)
            only_version = self.send("#{attachment}_only_version")
            only_version = only_version.to_sym if only_version.is_a? String

            attachment_instance = send(attachment)
            if only_version
              if only_version.is_a? Array
                only_version.map!(&:to_sym)
                attachment_instance.recreate_versions!(*only_version)
              else
                attachment_instance.recreate_versions!(only_version.to_sym)
              end
            else
              attachment_instance.recreate_versions!
            end
          end
        end

      end  ## End of InstanceMethods

    end  ## End of ModelAdditions

    module Uploader

      # Performs cropping.
      #
      #  On original version of attachment
      #  process crop: :avatar
      #
      #  Resizes the original image to 600x600 and then performs cropping
      #  process crop: [:avatar, 600, 600]
      #
      # @param attachment [Symbol] Name of the attachment attribute to be cropped
      def crop(attachment, width = nil, height = nil)
        if model.cropping?(attachment)
          x = model.send("#{attachment}_crop_x").to_i
          y = model.send("#{attachment}_crop_y").to_i
          w = model.send("#{attachment}_crop_w").to_i
          h = model.send("#{attachment}_crop_h").to_i
          only_version = model.send("#{attachment}_only_version")
          attachment_instance = model.send(attachment)

          if self.respond_to? "resize_to_limit"
            begin
              if only_version
                if only_version.is_a? Array
                  only_version.each do |item|
                    crop_manipulate(attachment_instance, width, height, x, y, w, h) if item.to_sym == self.version_name.to_sym
                  end
                else
                  crop_manipulate(attachment_instance, width, height, x, y, w, h) if only_version.to_sym == self.version_name.to_sym
                end
              elsif only_version.nil?
                crop_manipulate(attachment_instance, width, height, x, y, w, h)
              end

            rescue Exception => e
              raise CarrierWave::Crop::ProcessingError, "Failed to crop - #{e.message}"
            end

          else
            raise CarrierWave::Crop::MissingProcessorError, "Failed to crop #{attachment}. Add rmagick or mini_magick."
          end
        end
      end

      #manipulate croping
      def crop_manipulate(attachment_instance, width, height, x, y, w, h)
        if width && height
          resize_to_limit(width, height)
        end
        manipulate! do |img|
          if attachment_instance.kind_of? CarrierWave::RMagick
            img.crop!(x, y, w, h)
          elsif attachment_instance.kind_of? CarrierWave::MiniMagick
            img.crop("#{w}x#{h}+#{x}+#{y}")
            img
          end
        end
      end

    end ## End of Uploader
  end ## End of Crop
end ## End of CarrierWave


if defined? CarrierWave::Uploader::Base
  CarrierWave::Uploader::Base.class_eval do
    include CarrierWave::Crop::Uploader
  end
end
