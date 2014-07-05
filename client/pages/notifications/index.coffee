Template.notifications.helpers
  notifications: ->
    Notifications.find({}, {sort: {createdAt: -1}})
  timeFormat: (time) ->
    moment(time).format('YYYY-MM-DD HH:mm')
  showAction: (action) ->
    showAction(action)

Template.notifications.events
  'click a[data-remove]': (e) ->
    notification = Notifications.findOne(e.target.dataset.remove)
    Meteor.call 'destroyNotification', notification._id, (error, result) ->
      if error
        throwAlert error.reason
      else
        throwAlert "Notification is removed successfully"

