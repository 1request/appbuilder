Template.mobile.created = ->
  $('head').append '<link rel="stylesheet" href="/stylesheets/foundation.css"/>'
  $('head').append '<link rel="stylesheet" href="/stylesheets/flexslider.css"/>'
  $('head').append '<link rel="stylesheet" href="/stylesheets/jquery.mobile-1.0rc2.min.css"/>'
  $('head').append '<link rel="stylesheet" href="/stylesheets/jquery.mmenu.all.css"/>'
  $('head').append '<link rel="stylesheet" href="/stylesheets/mobile.css"/>'
  $('head').append '<script type="text/javascript" src="/js/jquery.mobile-1.0rc2.min.js"/>'
  $('head').append '<script type="text/javascript" src="/js/jquery.mmenu.min.all.js"/>'

Template.mobile.helpers
  mobile: ->
    Mobile.findOne()
  imageUrl: ->
    if Mobile.findOne().imageUrls
      "<img src='#{Mobile.findOne().imageUrl}' class='responsive-image' alt='img'>"
  tags: ->
    Tags.find()
  mobileAppUer: ->
    MobileAppUers.findOne()

Template.mobile.rendered = ->
  $('nav#menu').mmenu
    searchfield : true
    slidingSubmenus: true
  if Mobile.findOne().imageUrls
    $('.flexslider').flexslider
      animation: "slide"

Template.mobile.destroyed = ->
  $('link[href="/stylesheets/foundation.css"]').remove()
  $('link[href="/stylesheets/flexslider.css"]').remove()
  $('link[href="/stylesheets/jquery.mobile-1.0rc2.min.css"]').remove()
  $('link[href="/stylesheets/jquery.mmenu.all.css"]').remove()
  $('link[href="/stylesheets/mobile.css"]').remove()
  $('script[src="/js/jquery.mobile-1.0rc2.min.js"]').remove()
  $('script[src="/js/jquery.mmenu.min.all.js"]').remove()
  location.reload()