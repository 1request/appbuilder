@loadResources = ->
  $('head').append '<link rel="stylesheet" href="/stylesheets/foundation.css"/>'
  $('head').append '<link rel="stylesheet" href="/stylesheets/mobile.css"/>'
  $('head').append '<link rel="stylesheet" href="/stylesheets/flexslider.css"/>'
  $('head').append '<link rel="stylesheet" href="/stylesheets/jquery.mobile-1.0rc2.min.css"/>'
  $('head').append '<link rel="stylesheet" href="/stylesheets/jquery.mmenu.all.css"/>'
  $('head').append '<script type="text/javascript" src="/js/jquery.flexslider.js"/>'
  $('head').append '<script type="text/javascript" src="/js/jquery.mmenu.min.all.js"/>'
  $('head').append '<script type="text/javascript" src="/js/o-script.js"/>'

@removeResources = ->
  $('link[href="/stylesheets/foundation.css"]').remove()
  $('link[href="/stylesheets/mobile.css"]').remove()
  $('link[href="/stylesheets/flexslider.css"]').remove()
  $('link[href="/stylesheets/jquery.mobile-1.0rc2.min.css"]').remove()
  $('link[href="/stylesheets/jquery.mmenu.all.css"]').remove()
  $('script[src="/js/jquery.mmenu.min.all.js"]').remove()
  $('script[src="/js/jquery.flexslider.js"]').remove()
  $('script[src="/js/o-script.js"]').remove()