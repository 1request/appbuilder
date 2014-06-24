Template.notification.created = ->
  loadResources()

Template.notification.destroyed = ->
  removeResources()
  location.reload()

Template.notification.helpers
  mobileApp: ->
    MobileApps.findOne(appKey: Session.get 'mobileAppKey')
  notifications: ->
    Notifications.find({appKey: Session.get 'mobileAppKey'}, {sort: {createdAt: -1}})
  dateFormat: (date) ->
    moment(date).format('MMM DD')
