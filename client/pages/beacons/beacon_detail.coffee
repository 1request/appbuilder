Template.beaconDetail.helpers
  zones: ->
    _.pluck(Zones.find(_id: {$in: @zones}).fetch(), 'text').join(', ')
  rowId: ->
    this.uuid + "-" + this.major + "-" + this.minor

Template.beaconDetail.events
  'click a[data-remove]': (e) ->
    beacon = Beacons.findOne(e.target.dataset.remove)
    Beacons.destroyBeacon beacon._id, (error, result) ->
      if error
        throwAlert error.reason
      else
        throwAlert "Beacon is removed successfully"
