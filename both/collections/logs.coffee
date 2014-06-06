@Logs = new Meteor.Collection 'logs'

if Meteor.isServer
  Meteor.startup ->
    logsAPI = new CollectionAPI
    logsAPI.addCollection Logs, 'logs',
      methods: ['POST', 'GET']
    logsAPI.start()

Meteor.methods
  'getMemberAnalytic': (memberDeviceId, startDate, endDate, type) ->
    days = moment(endDate).diff(moment(startDate), 'days')
    result = _.map [0..days], (i) ->
      start = moment(startDate).add('days', i).valueOf()
      end = moment(startDate).add('days', i + 1).valueOf()
      count = Logs.find(deviceId: memberDeviceId, time: { $gt: start, $lt: end }).count()
      [i, count]
