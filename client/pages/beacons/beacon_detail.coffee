Template.beaconDetail.helpers
  tags: ->
    _.pluck(Tags.find(_id: {$in: @tags}).fetch(), 'name').join(', ')