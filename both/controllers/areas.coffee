Areas.index = AppController.extend
  template: 'areas'
  waitOn: ->
    Meteor.subscribe 'areas',
      appKey: Session.get('mobileAppKey')
    Meteor.subscribe 'images', {}

Areas.edit = AppController.extend
  template: 'editArea'
  onAfterAction: ->
    Session.set 'imageId', Areas.findOne().imageId
  waitOn: ->
    Meteor.subscribe 'areas',
      id: @params.id
  onStop: ->
    Session.set 'imageId', null


Areas.updateArea = (data, callback) ->
  Meteor.call('updateArea', data, callback)
