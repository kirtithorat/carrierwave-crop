module Carrierwave
  module Crop
    module ModelAdditions

      module ClassMethods

        def crop_uploaded(attachment)

          [:crop_x, :crop_y, :crop_w, :crop_h].each do |a|
            attr_accessor :"#{attachment}_#{a}"
          end
        end
      end

      module InstanceMethods

        def cropping?(attachment)
          !self.send(:"#{attachment}_crop_x").blank? &&
            !self.send(:"#{attachment}_crop_y").blank? &&
            !self.send(:"#{attachment}_crop_w").blank? &&
            !self.send(:"#{attachment}_crop_h").blank?
        end

        def reset_crop_attributes_of(attachment)
          [:crop_x, :crop_y, :crop_w, :crop_h].each do |a|
            self.send :"#{attachment}_#{a}=", nil
          end
        end
      end
    end
  end
end
