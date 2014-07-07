createNotification = (notification) ->
  Meteor.call 'createNotification', notification, (error, result) ->
    if error
      throwAlert(error.reason)
    else
      if notification.type is 'instant'
        Router.go 'instantNotifications'
        throwAlert("successfully send notification")
      else
        Router.go 'lbNotifications'
        throwAlert("Notification updated successfully")

updateNotification = (notification) ->
  Meteor.call 'updateNotification', notification, (error, result) ->
    if error
      throwAlert(error.reason)
    else
      if notification.type is 'instant'
        Router.go 'instantNotifications'
        throwAlert("successfully send notification")
      else
        Router.go 'lbNotifications'
        throwAlert("Notification updated successfully")

Template.newNotification.helpers
  zone: ->
    Zones.findOne(_id: Session.get 'zone')
  isLbn: ->
    Session.get('location')
  showUrl: ->
    Session.get('url')
  notification: ->
    notification = Notifications.findOne(Session.get 'notification')
  actionSelected: (action)->
    notification = Notifications.findOne(Session.get 'notification')
    if notification
      action == notification.action

Template.newNotification.rendered = ->
  Session.setDefault('location', false)

Template.newNotification.events
  'change #type': (e) ->
    if e.target.value is 'location'
      Session.set "location", true
    else
      Session.set "location", false

  'change #action': (e) ->
    if e.target.value is 'url'
      Session.set "url", true
    else
      Session.set "url", false

  'submit form': (e) ->
    e.preventDefault()
    message = $('input[name="message"]').val()
    zone = Session.get 'zone'
    type = if Session.get 'location'
      'location'
    else
      'instant'
    action = $('select[name="action"]').val()
    if action is 'url'
      url = $('input[name="url"]').val()
    else
      url = null

    unless !!message
      throwAlert('Please provide message')
    else if action is 'url' and !url
      throwAlert('Please provide url')
    else
      notification = Notifications.findOne(Session.get 'notification')
      if notification
        # appKey, type, zone unchange
        notification.action = action
        notification.url = url
        notification.message = message

        updateNotification(notification)
      else 
        notification =
          appKey: Session.get('mobileAppKey')
          message: message
          type: type
          action: action

        if action is 'url' then _.extend notification, { url: url }
        if type is 'location' then _.extend notification, { zone: zone }

        createNotification(notification)




