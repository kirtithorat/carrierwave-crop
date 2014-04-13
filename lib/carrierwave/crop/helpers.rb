module Carrierwave
  module Crop
    module Helpers

      def cropped_preview(attachment, opts = {})
        attachment = attachment.to_sym
        width      = opts[:width] || 100
        height     = (width / 1).round

        if(self.object.send(attachment).class.ancestors.include? CarrierWave::Uploader::Base )
          wrapper_options = {
            :id    => "#{attachment}_crop_preview_wrapper",
            :style => "width:#{width}px; height:#{height}px; overflow:hidden"
          }

          preview_image = @template.image_tag(self.object.send(attachment).url, :id => "#{attachment}_crop_preview")

          @template.content_tag(:div, preview_image, wrapper_options)
        end
      end


      def cropbox(attachment, opts={})
        attachment = attachment.to_sym

        if(self.object.send(attachment).class.ancestors.include? CarrierWave::Uploader::Base )
          box  = self.text_field(:"#{attachment}_crop_x", id: "#{self.object.class.name.downcase}_#{attachment}_crop_x")
          [:crop_y, :crop_w, :crop_h].each do |attribute|
            box << self.text_field(:"#{attachment}_#{attribute}", id: "#{self.object.class.name.downcase}_#{attachment}_#{attribute}")
          end

          crop_image = @template.image_tag(self.object.send(attachment).url, :id => "#{self.object.class.name.downcase}_#{attachment}_cropbox")

          box << @template.content_tag(:div, crop_image)

        end
      end
    end
  end
end

if defined? ActionView::Helpers::FormBuilder
  ActionView::Helpers::FormBuilder.class_eval do
    include Carrierwave::Crop::Helpers
  end
end
