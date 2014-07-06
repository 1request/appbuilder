Template.lbNotifications.helpers
  zones: ->
    Zones.find()

Template.zoneNotifications.helpers
  hasNotifications: ->
    Notifications.findOne({zone: @_id})
  notifications: ->
    Notifications.find({zone: @_id})
  zone: ->
    Zones.findOne(@zone)
  showAction: (action) ->
    showAction(action)

Template.zoneNotifications.events
  'click a[data-remove]': (e) ->
    notification = Notifications.findOne(e.target.dataset.remove)
    Meteor.call 'destroyNotification', notification._id, (error, result) ->
      if error
        throwAlert error.reason
      else
        throwAlert "Notification is removed successfully"
