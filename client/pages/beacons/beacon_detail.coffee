Template.beaconDetail.helpers
  tags: ->
    _.pluck(Tags.find(_id: {$in: @tags}).fetch(), 'text').join(', ')

Template.beaconDetail.events
  'click a[data-remove]': (e) ->
    beacon = Beacons.findOne(e.target.dataset.remove)
    Beacons.destroyBeacon beacon._id, (error, result) ->
      if error
        throwAlert error.reason
      else
        throwAlert "Beacon is removed successfully"
