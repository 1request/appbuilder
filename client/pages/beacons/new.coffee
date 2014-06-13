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
  $('#tags').select2
    tags: _.pluck Tags.find().fetch(), 'text'