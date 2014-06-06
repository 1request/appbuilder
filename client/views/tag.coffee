countTag = (tagId) ->
  Meteor.call 'countByTag', tagId, (error, result) ->
    Session.set "#{tagId}", result

Template.tag.helpers
  count: ->
    tagId = @_id
    console.log 'total log count: ', Logs.find().count()

    Session.get "#{@_id}"

Template.tag.rendered = ->
  tagId = @.data._id
  Deps.autorun ->
    countTag(tagId)