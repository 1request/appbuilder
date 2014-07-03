createNotification = (notification) ->
  Meteor.call 'createNotification', notification, (error, result) ->
    if error
      throwAlert(error.reason)
    else
      if notification.type is 'instant'
        Router.go 'instantNotifications'
      else
        Router.go 'lbNotifications'
      throwAlert("successfully send notification")

Template.newNotification.helpers
  location: ->
    Session.get('location')

Template.newNotification.rendered = ->
  Session.setDefault('location', false)

Template.newNotification.events
  'change #type': (e) ->
    if e.target.value is 'location'
      Session.set "location", true
    else
      Session.set "location", false

  'submit form': (e) ->
    e.preventDefault()
    message = $('input[name="message"]').val()
    url = $('input[name="url"]').val()
    type = $('select[name="type"]').val()

    notification =
      appKey: Session.get('mobileAppKey')
      message: message
      type: type
      url: url

    unless !!message
      throwAlert('Please provide message')
    else unless !!url
      throwAlert('Please provide url')
    else if type is 'instant'
      createNotification(notification)
    else
      zone = $('select[name="zone"]').val()
      notification = _.extend notification, { zone: zone }
      createNotification(notification)

Template.newNotification.destroyed = ->
  delete Session.keys['location']





