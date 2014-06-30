Template.newNotification.helpers
  notifications: -> 
    Notifications.find({appKey: Session.get 'mobileAppKey'}, {sort: {createdAt: -1}})
  dateFormat: (date) ->
    moment(date).format('MMM DD')
  outsideUrl: (url) ->
    if url.match("http://")
      url
    else
      "http://" + url

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