Areas.index = AppController.extend
  template: 'areas'
  waitOn: ->
    Meteor.subscribe 'areas',
      appKey: Session.get('mobileAppKey')
    Meteor.subscribe 'images', {}

Areas.edit = AppController.extend
  template: 'editArea'
  onAfterAction: ->
    Session.set 'image', Areas.findOne().image
  waitOn: ->
    Meteor.subscribe 'areas',
      id: @params.id
  onStop: ->
    Session.set 'imageId', null


Areas.updateArea = (data, callback) ->
  Meteor.call('updateArea', data, callback)
