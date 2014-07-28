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
  showTrigger: (trigger) ->
    showTrigger(trigger)
  showArea: (area) ->
    area = Areas.findOne(area)
    if !!area then area.name
  showImage: (image) ->
    image = Images.findOne(image)
    if !!image then image.url(store: 'thumbs')
  url: ->
    if @action is 'image'
      image = Images.findOne(@image)
      "<img src='#{image.url(store: 'thumbs')}' alt='' class='img-responsive'>"
    else if @action is 'url' or @action is 'video'
      @url

Template.zoneNotifications.events
  'click a[data-remove]': (e) ->
    notification = Notifications.findOne(e.target.dataset.remove)
    Meteor.call 'destroyNotification', notification._id, (error, result) ->
      if error
        throwAlert error.reason
      else
        throwAlert "Notification is removed successfully"
