Template.newBeacon.helpers

Template.newBeacon.events
  'submit form': (e) ->
    e.preventDefault()
    beacon = setBeaconForm(e)
    Beacons.createBeacon beacon, (error, result) ->
      if error
        throwAlert(error.reason)
      else if Session.get 'walkthrough'
        Router.go('areas')
        throwAlert('Beacon successfully added! Next, update floor plan area\'s names and logos.')
      else
        Router.go('beacons')
        throwAlert('Beacon successfully added!')

Template.newBeacon.rendered = ->
  $('#zones').select2
    tags: _.pluck Zones.find().fetch(), 'text'