Template.mobile.helpers
  mobile: ->
    Mobile.findOne()
  imageUrl: ->
    if Mobile.findOne().imageUrls
      "<img src='#{Mobile.findOne().imageUrl}' class='responsive-image' alt='img'>"

Template.mobile.rendered = ->
  $('nav#menu').mmenu
    searchfield : true
    slidingSubmenus: true
  if Mobile.findOne().imageUrls
    $('.flexslider').flexslider
      animation: "slide"