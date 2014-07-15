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
          if Session.get 'walkthrough'
            Router.go 'newBeacon'
            throwAlert("successfully created app called #{appName}. Next, you can add a beacon and zone it belongs to.")
          else
            Router.go 'editMobileApp'
            throwAlert("successfully created #{appName}")
          Session.set 'mobileAppKey', result