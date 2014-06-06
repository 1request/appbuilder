@Logs = new Meteor.Collection 'logs'

if Meteor.isServer
  Meteor.startup ->
    logsAPI = new CollectionAPI
    logsAPI.addCollection Logs, 'logs',
      methods: ['POST', 'GET']
    logsAPI.start()

Meteor.methods
  'getAppAnalytic': (appId, startDate, endDate, type) ->
    days = moment(endDate).diff(moment(startDate), 'days')
    _.map [0..days], (i) ->
      start = moment(startDate).add('days', i).valueOf()
      end = moment(startDate).add('days', i + 1).valueOf()
      members = Members.find(appId: appId).fetch()
      result = _.reduce members, (sum, member) ->
        count = Logs.find(deviceId: member.deviceId, time: { $gt: start, $lt: end }).count()
        sum + count
      , 0
      [i, result]

  'getMemberAnalytic': (memberDeviceId, startDate, endDate, type) ->
    days = moment(endDate).diff(moment(startDate), 'days')
    result = _.map [0..days], (i) ->
      start = moment(startDate).add('days', i).valueOf()
      end = moment(startDate).add('days', i + 1).valueOf()
      count = Logs.find(deviceId: memberDeviceId, time: { $gt: start, $lt: end }).count()
      [i, count]

  'countByTag': (tagId) ->
    tag = Tags.findOne(tagId)
    beacons = Beacons.find(_id: {$in: tag.beacons}).fetch()
    _.reduce beacons, (sum, beacon) ->
      count = Logs.find(uuid: beacon.uuid, major: beacon.major, minor: beacon.minor).count()
      sum + count
    , 0