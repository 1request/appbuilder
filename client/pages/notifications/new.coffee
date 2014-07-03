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
  url: ->
    Session.get('url')


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
    url = $('input[name="url"]').val()
    type = $('select[name="type"]').val()
    action = $('select[name="action"]').val()
    zone = $('select[name="zone"]').val()

    notification =
      appKey: Session.get('mobileAppKey')
      message: message
      type: type
      action: action

    if action is 'url' then _.extend notification, { url: url }
    if type is 'location' then _.extend notification, { zone: zone }

    unless !!message
      throwAlert('Please provide message')
    else if action is 'url' and !url
      throwAlert('Please provide url')
    else
      createNotification(notification)




