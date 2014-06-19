countTag = (tagId, mobileAppUserId) ->
  Meteor.call 'countByTag', tagId, mobileAppUserId, (error, result) ->
    Session.set "#{tagId}", result

Template.tag.helpers
  count: ->
    Session.get "#{@_id}"

Template.tag.rendered = ->
  tagId = @.data._id

  @tagDep = Deps.autorun ->
    deviceId = MobileAppUsers.findOne().deviceId
    count = Counts.findOne(deviceId)
    countTag(tagId, deviceId)

Template.tag.destroyed = ->
  if @tagDep
    @tagDep.stop()
