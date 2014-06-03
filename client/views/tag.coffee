Template.tag.helpers
  count: ->
    _.reduce @beacons, (sum, beacon) ->
      sum + Beacons.findOne(beacon).count
    , 0
