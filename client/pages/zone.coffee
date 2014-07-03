countZone = (zoneId, mobileAppUserId) ->
  Meteor.call 'countByZone', zoneId, mobileAppUserId, (error, result) ->
    Session.set "#{zoneId}", result

Template.zone.helpers
  count: ->
    Session.get "#{@_id}"

Template.zone.rendered = ->
  zoneId = @.data._id

  @zoneDep = Deps.autorun ->
    deviceId = MobileAppUsers.findOne().deviceId
    count = Counts.findOne(deviceId)
    countZone(zoneId, deviceId)

Template.zone.destroyed = ->
  if @zoneDep
    @zoneDep.stop()
