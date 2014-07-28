Template.notifications.helpers
  notifications: ->
    Notifications.find({}, {sort: {createdAt: -1}})

Template.notifications.events
  'click a[data-remove]': (e) ->
    notification = Notifications.findOne(e.target.dataset.remove)
    Meteor.call 'destroyNotification', notification._id, (error, result) ->
      if error
        throwAlert error.reason
      else
        throwAlert "Notification is removed successfully"

Template.notificationRow.helpers
  timeFormat: (time) ->
    moment(time).format('YYYY-MM-DD HH:mm')
  showAction: (action) ->
    showAction(action)
  url: ->
    if !!@image
      image = Images.findOne(@image)
      "<img src='#{image.url(store: 'thumbs')}' alt='' class='img-responsive'>"
    else if !!@url
      @url