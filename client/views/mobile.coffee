Template.mobile.helpers
  mobile: ->
    Mobile.findOne()
  imageUrl: ->
    if Mobile.findOne().imageUrl
      "<img src='#{Mobile.findOne().imageUrl}' class='responsive-image' alt='img'>"