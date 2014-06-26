Template.notification.created = ->
  loadResources()

Template.notification.destroyed = ->
  removeResources()
  location.reload()

Template.notification.helpers
  mobileApp: ->
    MobileApps.findOne()
  notifications: -> 
    Notifications.find({}, {sort: {createdAt: -1}})
  dateFormat: (date) ->
    moment(date).format('MMM DD')
  outsideUrl: (url) ->
    if url.match("http://")
      url
    else
      "http://" + url
