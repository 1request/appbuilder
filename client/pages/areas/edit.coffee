Template.editArea.helpers
  area: ->
    Areas.findOne()
  url: ->
    Images.findOne().url() if !!Images.findOne(Session.get 'imageId')

Template.editArea.rendered = ->
  @subscribeImagesDep = Deps.autorun ->
    Meteor.subscribe 'images', id: Session.get('imageId')
    if Images.findOne()
      Session.set('url', Images.findOne().url())

Template.editArea.events
  'submit form': (e) ->
    e.preventDefault()
    imageId = Session.get('imageId')
    area =
      _id: Areas.findOne()._id
      name: $('input[name="name"]').val()
    if !!imageId then _.extend area, {imageId: imageId}
    Meteor.call 'updateArea', area, (error, result) ->
      if error
        throwAlert(error.reason)
      else
        throwAlert('sucessfully updated floor plan area')
        Router.go('areas')

Template.editArea.destroyed = ->
  if @subscribeImagesDep
    @subscribeImagesDep.stop()