countTag = (tagId, memberId) ->
  Meteor.call 'countByTag', tagId, memberId, (error, result) ->
    Session.set "#{tagId}", result

Template.tag.helpers
  count: ->
    Session.get "#{@_id}"

Template.tag.rendered = ->
  tagId = @.data._id

  @tagDep = Deps.autorun ->
    deviceId = Members.findOne().deviceId
    count = Counts.findOne(deviceId)
    countTag(tagId, deviceId)

Template.tag.destroyed = ->
  if @tagDep
    @tagDep.stop()
