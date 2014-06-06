Template.tag.helpers
  count: ->
    Session.get "#{@_id}"

Template.tag.rendered = ->
  tagId = @data._id
  Meteor.call 'countByTag', tagId, (error, result) ->
    Session.set "#{tagId}", result