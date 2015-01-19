$(window).load ->
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
    w = $('#<%= file_name %>_<%= attachment_name %>_crop_original_w').val()
    h = $('#<%= file_name %>_<%= attachment_name %>_crop_original_h').val()

    if w == "0"
      zoom_factor_x = 1 
    else
      zoom_factor_x = w / $('#<%= file_name %>_<%= attachment_name %>_cropbox').width()

    if h == "0"
      zoom_factor_y = 1
    else
      zoom_factor_y = h / $('#<%= file_name %>_<%= attachment_name %>_cropbox').height()

    $('#<%= file_name %>_<%= attachment_name %>_crop_x').val(Math.round(zoom_factor_x * coords.x))
    $('#<%= file_name %>_<%= attachment_name %>_crop_y').val(Math.round(zoom_factor_y * coords.y))
    $('#<%= file_name %>_<%= attachment_name %>_crop_w').val(Math.round(zoom_factor_x * coords.w))
    $('#<%= file_name %>_<%= attachment_name %>_crop_h').val(Math.round(zoom_factor_y * coords.h))

  updatePreview: (coords) =>
    zoom_factor_x = $('#<%= file_name %>_<%= attachment_name %>_previewbox_wrapper').width()  / coords.w
    zoom_factor_y = $('#<%= file_name %>_<%= attachment_name %>_previewbox_wrapper').height() / coords.h
    $('#<%= file_name %>_<%= attachment_name %>_previewbox').css
      width:  Math.round(zoom_factor_x * $('#<%= file_name %>_<%= attachment_name %>_cropbox').width())  + 'px'
      height: Math.round(zoom_factor_y * $('#<%= file_name %>_<%= attachment_name %>_cropbox').height()) + 'px'
      marginLeft: '-' + Math.round(zoom_factor_x * coords.x) + 'px'
      marginTop:  '-' + Math.round(zoom_factor_y * coords.y) + 'px'
