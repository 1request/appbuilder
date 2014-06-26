@Logs = new Meteor.Collection 'logs'

Meteor.methods
  'getAppAnalytic': (appKey, startDate, endDate, type) ->
    app = MobileApps.findOne(appKey: appKey)
    days = moment(endDate).diff(moment(startDate), 'days')
    _.map [0..days], (i) ->
      start = moment(startDate).add('days', i).valueOf()
      end = moment(startDate).add('days', i + 1).valueOf()
      mobileAppUsers = MobileAppUsers.find(appKey: app.appKey).fetch()
      result = _.reduce mobileAppUsers, (sum, member) ->
        count = Logs.find(deviceId: member.deviceId, time: { $gt: start, $lt: end }).count()
        sum + count
      , 0
      [i, result]

  'getMobileAppUserAnalytic': (memberDeviceId, startDate, endDate, type) ->
    days = moment(endDate).diff(moment(startDate), 'days')
    result = _.map [0..days], (i) ->
      start = moment(startDate).add('days', i).valueOf()
      end = moment(startDate).add('days', i + 1).valueOf()
      count = Logs.find(deviceId: memberDeviceId, time: { $gt: start, $lt: end }).count()
      [i, count]

  'countByTag': (tagId, deviceId) ->
    tag = Tags.findOne(tagId)
    beacons = Beacons.find(_id: {$in: tag.beacons}).fetch()
    _.reduce beacons, (sum, beacon) ->
      count = Logs.find(uuid: beacon.uuid, major: beacon.major, minor: beacon.minor, deviceId: deviceId).count()
      sum + count
    , 0

  'monthlyCount': (deviceId) ->
    daysInMonth = moment().daysInMonth()
    _.reduce [1..daysInMonth], (sum, date) ->
      start = moment().date(date).startOf('day').valueOf()
      end = moment().date(date).endOf('day').valueOf()
      sum += 1 if !!Logs.find(deviceId: deviceId, time: {$gt: start, $lt: end}).count()
      sum
    , 0

  'dayCount': (deviceId, date) ->
    start = moment().date(date).startOf('day').valueOf()
    end = moment().date(date).endOf('day').valueOf()
    !!Logs.find(deviceId: deviceId, time: {$gt: start, $lt: end}).count()