Template.newBeacon.helpers

Template.newBeacon.events
  'submit form': (e) ->
    e.preventDefault()
    beacon = setBeaconForm(e)
    Beacons.createBeacon beacon, (error, result) ->
      if error
        throwAlert(error.reason)
      else
        Router.go('beacons')

Template.newBeacon.rendered = ->
  $('#zones').select2
    tags: _.pluck Zones.find().fetch(), 'text'