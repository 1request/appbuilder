Template.notifications.helpers
  notifications: -> 
    Notifications.find({}, {sort: {createdAt: -1}})
  timeFormat: (time) ->
    moment(time).format('YYYY-MM-DD HH:mm')
