Template.newNotification.helpers

Template.newNotification.events
  'submit form': (e) ->
    e.preventDefault()
    message = $('input[name="message"]').val()
    url = $('input[name="url"]').val()
    unless !!message
      throwAlert('Please provide message')
    else
      Meteor.call 'createNotification', {appKey: Session.get('mobileAppKey'), message: message, url: url}, (error, result) ->
        if error
          throwAlert(error.reason)
        else
          Router.go 'newNotification'
          throwAlert("successfully send notification")