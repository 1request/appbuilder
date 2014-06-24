Template.notification.created = ->
  $('head').append '<link rel="stylesheet" href="/stylesheets/foundation.css"/>'
  $('head').append '<link rel="stylesheet" href="/stylesheets/flexslider.css"/>'
  $('head').append '<link rel="stylesheet" href="/stylesheets/jquery.mobile-1.0rc2.min.css"/>'
  $('head').append '<link rel="stylesheet" href="/stylesheets/jquery.mmenu.all.css"/>'
  $('head').append '<link rel="stylesheet" href="/stylesheets/mobile.css"/>'
  $('head').append '<script type="text/javascript" src="/js/jquery.mobile-1.0rc2.min.js"/>'
  $('head').append '<script type="text/javascript" src="/js/jquery.mmenu.min.all.js"/>'

Template.notification.destroyed = ->
  $('link[href="/stylesheets/foundation.css"]').remove()
  $('link[href="/stylesheets/flexslider.css"]').remove()
  $('link[href="/stylesheets/jquery.mobile-1.0rc2.min.css"]').remove()
  $('link[href="/stylesheets/jquery.mmenu.all.css"]').remove()
  $('link[href="/stylesheets/mobile.css"]').remove()
  $('script[src="/js/jquery.mobile-1.0rc2.min.js"]').remove()
  $('script[src="/js/jquery.mmenu.min.all.js"]').remove()
  location.reload()

Template.notification.helpers
  mobileApp: ->
    MobileApps.findOne(appKey: Session.get 'mobileAppKey')
  notifications: -> 
    Notifications.find({appKey: Session.get 'mobileAppKey'}, {sort: {createdAt: -1}})
  dateFormat: (date) ->
    moment(date).format('MMM DD')
