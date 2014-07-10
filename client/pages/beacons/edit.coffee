Template.editBeacon.helpers
  uuid: ->
    beacon = Beacons.findOne().uuid
  major: ->
    beacon = Beacons.findOne().major
  minor: ->
    beacon = Beacons.findOne().minor
  notes: ->
    beacon = Beacons.findOne().notes

Template.editBeacon.events
  'submit form': (e) ->
    e.preventDefault()
    beacon = setBeaconForm(e)
    _.extend beacon, {_id: Beacons.findOne()._id}
    Beacons.updateBeacon beacon, (error, result) ->
      if error
        throwAlert(error.reason)
      else
        Router.go('beacons')

Template.editBeacon.rendered = ->
  beacon = Beacons.findOne()
  runSelect2(setSelectedZones(beacon.zones))