# Carrierwave-Crop

[![Build Status](https://travis-ci.org/kirtithorat/carrierwave-crop.svg?branch=master)](https://travis-ci.org/kirtithorat/carrierwave-crop)

Carrierwave extension to crop uploaded images using Jcrop plugin with preview.

## Installation

Install the latest stable release:

    $[sudo] gem install carrierwave

In Rails, add it to your Gemfile:

    gem 'carrierwave-crop'

And then execute:

    $ bundle

Finally, restart the server to apply the changes.

## Getting Started

Add the required files in assets

In  `application.js`

    //= require jquery
    //= require jquery.jcrop

In  `application.css`

    *= require jquery.jcrop

Generate a coffeescript for cropping:

    rails generate cropper user avatar

 this should give you a file in:
 
     app/assets/javascripts/users.js.coffee    

## Usage

Open your model file and add the cropper:

     class User < ActiveRecord::Base
       mount_uploader :avatar, AvatarUploader
       crop_uploaded :avatar  ## Add this
     end        

Render a view after creating/updating a user, add a `crop` action in your `controller.` For example:

      def create
        @user = User.new(user_params)
        respond_to do |format|
          if @user.save
            format.html {
              if params[:user][:avatar].present?
                render :crop  ## Render the view for cropping
              else
                redirect_to @user, notice: 'User was successfully created.'
              end
            }
            format.json { render action: 'show', status: :created, location: @user }
          else
            format.html { render action: 'new' }
            format.json { render json: @user.errors, status: :unprocessable_entity }
          end
        end
      end    

For `Rails 4.x`, whitelist the cropping attributes - `fieldname_crop_x`, `fieldname_crop_y`, `fieldname_crop_w`, `fieldname_crop_h`. 

For example:

    def user_params
      params.require(:user).permit(:avatar_crop_x, :avatar_crop_y, :avatar_crop_w, :avatar_crop_h, ....)
    end


In the view, say `crop.html.erb`:

    <%= form_for @user do |f| %>
      <%= f.cropbox :avatar %>
      <%= f.cropped_preview :avatar %>
      <%= f.submit 'Crop' %>
    <% end %>

In the carrierwave uploader, say `AvatarUploader`:

Call process on the version you would like to be cropped:

     ## If ONLY "thumb" version is to be cropped
     version :jumbo do
        resize_to_limit(600,600)
     end

     version :thumb do
        process crop: :avatar  ## Add this
        resize_to_limit(100,100)
     end      

### Credits and resources
* [Carrierwave](https://github.com/carrierwaveuploader/carrierwave)
* [Deep Liquid's JCrop](http://deepliquid.com/content/Jcrop.html)
* And Ryan Bates [Railscast#182](http://railscasts.com/episodes/182-cropping-images/)
