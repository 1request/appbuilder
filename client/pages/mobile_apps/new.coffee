Template.newMobileApp.helpers

Template.newMobileApp.events
  'submit form': (e) ->
    e.preventDefault()
    appName = $('input[name="name"]').val()
    unless !!appName
      throwAlert('Please provide app name')
    else
      Meteor.call 'createMobileApp', { name: appName }, (error, result) ->
        if error
          throwAlert(error.reason)
        else
          Router.go 'editMobileApp'
          throwAlert("successfully created #{appName}")
          Session.set 'mobileAppKey', result