# Carrierwave::Crop

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

### Credits and resources
* [Carrierwave](https://github.com/carrierwaveuploader/carrierwave)
* [Deep Liquid's JCrop](http://deepliquid.com/content/Jcrop.html)
* And Ryan Bates [Railscast#182](http://railscasts.com/episodes/182-cropping-images/)
