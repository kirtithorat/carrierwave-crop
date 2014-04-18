# encoding: utf-8

module CarrierWave
  module Crop
    module Helpers

      # Form helper to render the preview of a cropped attachment.
      # Loads the actual image. Previewbox has no constraints on dimensions, image is renedred at full size.
      # By default box size is 100x100. Size can be customized by setting the :width and :height option.
      # If you override one of width/height you must override both.
      # By default original image is rendered. Specific version can be specified by passing version option
      #
      #   previewbox :avatar
      #   previewbox :avatar, width: 200, height: 200
      #   previewbox :avatar, version: :medium
      #
      # @param attachment [Symbol] attachment name
      # @param opts [Hash] specify version or width and height options
      def previewbox(attachment, opts = {})
        attachment = attachment.to_sym

        if(self.object.send(attachment).class.ancestors.include? CarrierWave::Uploader::Base )
          ## Fixes Issue #1 : Colons in html id attributes with Namespaced Models
          model_name = self.object.class.name.downcase.split("::").last 
          width, height = 100, 100
          if(opts[:width] && opts[:height])
            width, height = opts[:width].round, opts[:height].round
          end
          wrapper_attributes = {id: "#{model_name}_#{attachment}_previewbox_wrapper", style: "width:#{width}px; height:#{height}px; overflow:hidden"}
          if opts[:version]
            img = self.object.send(attachment).url(opts[:version])
          else
            img = self.object.send(attachment).url
          end
          preview_image = @template.image_tag(img, id: "#{model_name}_#{attachment}_previewbox")
          @template.content_tag(:div, preview_image, wrapper_attributes)
        end
      end

      # Form helper to render the actual cropping box of an attachment.
      # Loads the actual image. Cropbox has no constraints on dimensions, image is renedred at full size.
      # Box size can be restricted by setting the :width and :height option. If you override one of width/height you must override both.
      # By default original image is rendered. Specific version can be specified by passing version option
      #
      #   cropbox :avatar
      #   cropbox :avatar, width: 550, height: 600
      #   cropbox :avatar, version: :medium
      #
      # @param attachment [Symbol] attachment name
      # @param opts [Hash] specify version or width and height options
      def cropbox(attachment, opts={})
        attachment = attachment.to_sym
        attachment_instance = self.object.send(attachment)

        if(attachment_instance.class.ancestors.include? CarrierWave::Uploader::Base )
          ## Fixes Issue #1 : Colons in html id attributes with Namespaced Models
          model_name = self.object.class.name.downcase.split("::").last 
          hidden_elements  = self.hidden_field(:"#{attachment}_crop_x", id: "#{model_name}_#{attachment}_crop_x")
          [:crop_y, :crop_w, :crop_h].each do |attribute|
            hidden_elements << self.hidden_field(:"#{attachment}_#{attribute}", id: "#{model_name}_#{attachment}_#{attribute}")
          end

          box =  @template.content_tag(:div, hidden_elements, style: "display:none")

          wrapper_attributes = {id: "#{model_name}_#{attachment}_cropbox_wrapper"}
          if(opts[:width] && opts[:height])
            wrapper_attributes.merge!(style: "width:#{opts[:width].round}px; height:#{opts[:height].round}px; overflow:hidden")
          end

          if opts[:version]
            img = self.object.send(attachment).url(opts[:version])
          else
            img = self.object.send(attachment).url
          end
          crop_image = @template.image_tag(img, :id => "#{model_name}_#{attachment}_cropbox")
          box << @template.content_tag(:div, crop_image, wrapper_attributes)
        end
      end
    end
  end
end

if defined? ActionView::Helpers::FormBuilder
  ActionView::Helpers::FormBuilder.class_eval do
    include CarrierWave::Crop::Helpers
  end
end
