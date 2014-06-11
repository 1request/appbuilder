countTag = (tagId) ->
  Meteor.call 'countByTag', tagId, (error, result) ->
    Session.set "#{tagId}", result

Template.tag.helpers
  count: ->
    Session.get "#{@_id}"

Template.tag.rendered = ->
  tagId = @.data._id

  Deps.autorun ->
    logCount = Logs.find().count()
    countTag(tagId)