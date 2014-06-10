Beacons.index = AppController.extend
  template: 'beacons'
  waitOn: ->
    [
      Meteor.subscribe 'tags', {}
      Meteor.subscribe 'beacons', {}
    ]

Beacons.new = AppController.extend
  template: 'newBeacon'

Beacons.show = AppController.extend
  template: 'showBeacon'

Beacons.edit = AppController.extend
  template: 'editBeacon'


Beacons.create = (data, callback) ->
  console.log('Fired Create Beacon', data)
  Meteor.call('createBeacon', data, callback)

Beacons.update = (data, callback) ->
  console.log('Fired Update Beacon', data)
  Meteor.call('Beacons.update', data, callback)

Beacons.destroy = (data, callback) ->
  console.log('Fired Destroy Beacon', data)
  Meteor.call('Beacons.destroy', data, callback)
