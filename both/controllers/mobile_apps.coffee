MobileApps.index = AppController.extend
  template: 'mobileApps'
  waitOn: ->
    Meteor.subscribe 'zones', {}
    Meteor.subscribe 'mobileApps', {}

MobileApps.new = AppController.extend
  template: 'newMobileApp'
  waitOn: ->
    Meteor.subscribe 'zones', {}

MobileApps.edit = AppController.extend
  template: 'editMobileApp'
  waitOn: ->
    Meteor.subscribe 'mobileApps', {}
    Meteor.subscribe 'mobileAppUsers', {}
    Meteor.subscribe 'zones', {}
    Meteor.subscribe 'p12s', {}

MobileApps.createMobileApp = (data, callback) ->
  Meteor.call('createMobileApp', data, callback)

MobileApps.updateMobileApp = (data, callback) ->
  Meteor.call('updateMobileApp', data, callback)

MobileApps.destroyMobileApp = (data, callback) ->
  Meteor.call('destroyMobileApp', data, callback)
