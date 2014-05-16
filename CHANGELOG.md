## CarrierWave-Crop v0.1.0 
   * Initial commit
   * Supports processors `rmagick`.  
   * `process crop: :avatar` resizes the original image to `600x600` and performs cropping on it.
   
## CarrierWave-Crop v0.1.1 
   * Supports processors `rmagick` and `mini-magick`. 
   * Changed module name `Carrierwave` to `CarrierWave` in sync with `CarrierWave` gem.
   * Deprecated `cropped_preview` form helper. Replaced it with `previewbox`.
   * Supports cropping of ONE attachment per model. Can be directly applied on original attachment if no versions exists.
   
         process crop: :avatar

   * Supports cropping of MULTIPLE versions of one attachment per model.
   * Updated the cropping coffeescript (created by rails generator) to incorporate the changes in form helpers.  
   * Added `version`, `width` and `height` options to form helpers `cropbox` and `previewbox`.
   
         ##To render a specific version for cropping pass `version` option.
         <%= f.cropbox :avatar , version: :medium %>   
         <%= f.peviewbox :avatar , version: :medium %>  ## Pass the same version as specified in cropbox

         ## If you override ONE of width/height you MUST override both, otherwise passed option would be ignored.
         <%= f.cropbox :avatar, width: 550, height: 600 %>
         <%= f.previewbox :avatar, width: 200, height: 200 %>
         
   * Added `width` and `height` arguments to proccessor method `crop`. 
   
         ## If ONLY "thumb" version is to be cropped
         version :jumbo do
           resize_to_limit(600,600)
         end
         version :thumb do
           process crop: :avatar  ## Crops this version based on original image
           resize_to_limit(100,100)
         end  
         
         ## With width and height
         ## If ONLY "thumb" version is to be cropped
         version :jumbo do
           resize_to_limit(600,600)
         end
         version :thumb do
           ## To crop this version based on `jumbo` version, pass width = 600 and height = 600
           ## Specify both width and height values otherwise they would be ignored
           process crop: [:avatar, 600, 600]  
           resize_to_limit(100,100)
         end 

## CarrierWave-Crop v0.1.1 
   * Fixes Issue #1: Colons in html `id` attribute for Namespaced Models