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
    @updateCoords(coords)
    @updatePreview(coords)

  updateCoords: (coords) =>
    $('#<%= file_name %>_<%= attachment_name %>_crop_x').val(coords.x)
    $('#<%= file_name %>_<%= attachment_name %>_crop_y').val(coords.y)
    $('#<%= file_name %>_<%= attachment_name %>_crop_w').val(coords.w)
    $('#<%= file_name %>_<%= attachment_name %>_crop_h').val(coords.h)

  updatePreview: (coords) =>
    zoom_factor_x = $('#<%= file_name %>_<%= attachment_name %>_previewbox').width()  / coords.w
    zoom_factor_y = $('#<%= file_name %>_<%= attachment_name %>_previewbox').height() / coords.h
    $('#<%= file_name %>_<%= attachment_name %>_previewbox').css
      width:  Math.round(zoom_factor_x * $('#<%= file_name %>_<%= attachment_name %>_cropbox').width())  + 'px'
      height: Math.round(zoom_factor_y * $('#<%= file_name %>_<%= attachment_name %>_cropbox').height()) + 'px'
      marginLeft: '-' + Math.round(zoom_factor_x * coords.x) + 'px'
      marginTop:  '-' + Math.round(zoom_factor_y * coords.y) + 'px'
