Beacons.index = AppController.extend
  template: 'beacons'
  waitOn: ->
    Meteor.subscribe 'zones', {}
    Meteor.subscribe 'beacons', {}

Beacons.new = AppController.extend
  template: 'newBeacon'
  waitOn: ->
    Meteor.subscribe 'zones', {}

Beacons.edit = AppController.extend
  template: 'editBeacon'
  waitOn: ->
    Meteor.subscribe 'zones', {}
    Meteor.subscribe 'beacons', { beaconId: @params.id }

Beacons.createBeacon = (data, callback) ->
  Meteor.call('createBeacon', data, callback)

Beacons.updateBeacon = (data, callback) ->
  Meteor.call('updateBeacon', data, callback)

Beacons.destroyBeacon = (data, callback) ->
  Meteor.call('destroyBeacon', data, callback)
