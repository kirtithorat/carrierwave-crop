jQuery ->
  new CarrierWaveCropper()

class CarrierWaveCropper
  constructor: ->
    $('#<%= file_name %>_<%= attachment_name %>_cropbox').Jcrop
      aspectRatio: 1
      setSelect: [0, 0, 200, 200]
      onSelect: @update
      onChange: @update

  update: (coords) =>
    $('#<%= file_name %>_<%= attachment_name %>_crop_x').val(coords.x)
    $('#<%= file_name %>_<%= attachment_name %>_crop_y').val(coords.y)
    $('#<%= file_name %>_<%= attachment_name %>_crop_w').val(coords.w)
    $('#<%= file_name %>_<%= attachment_name %>_crop_h').val(coords.h)
    @updatePreview(coords)

  updatePreview: (coords) =>
    $('#<%= file_name %>_<%= attachment_name %>_previewbox').css
      width: Math.round(100/coords.w * $('#<%= file_name %>_<%= attachment_name %>_cropbox').width()) + 'px'
      height: Math.round(100/coords.h * $('#<%= file_name %>_<%= attachment_name %>_cropbox').height()) + 'px'
      marginLeft: '-' + Math.round(100/coords.w * coords.x) + 'px'
      marginTop: '-' + Math.round(100/coords.h * coords.y) + 'px'
