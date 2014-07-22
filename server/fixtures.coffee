zones1 = ['Reception', 'Estimote', 'Open Area', 'Roof', 'Member Zone', 'Classroom']
zones2 = ['Cyber Port', 'Garage', 'Cocoon']

if Meteor.users.find().count() is 0
  Accounts.createUser {username: 'joe', email: 'joe@j.com', password: '1'}

userId = Meteor.users.findOne(username: 'joe')._id

if Zones.find().count() is 0
  for i in zones1
    Zones.insert {text: i, userId: userId}
  for i in zones2
    Zones.insert {text: i, userId: userId}

if Beacons.find().count() is 0
  beacons1 = [
    {
      uuid: 'B9407F30-F5F8-466E-AFF9-25556B57FE6D'
      major: 9
      minor: 62353
      zones: ['Reception', 'Estimote']
      notes: 'Beacon placed at reception of 9/F Garage Society'
    }, {
      uuid: 'B9407F30-F5F8-466E-AFF9-25556B57FE6D'
      major: 9
      minor: 26057
      zones: ['Open Area', 'Estimote']
      notes: 'Beacon placed at the Open Area of 9/F Garage Society'
    }, {
      uuid: 'B9407F30-F5F8-466E-AFF9-25556B57FE6D'
      major: 9
      minor: 50549
      zones: ['Roof', 'Estimote']
      notes: 'Beacon placed at Roof (Outdoor) at 9/F Garage Society'
    }, {
      uuid: 'B9407F30-F5F8-466E-AFF9-25556B57FE6D'
      major: 8
      minor: 7102
      zones: ['Reception', 'Estimote']
      notes: 'Beacon placed at Reception at 8/F Garage Society'
    }, {
      uuid: 'B9407F30-F5F8-466E-AFF9-25556B57FE6D'
      major: 8
      minor: 31008
      zones: ['Member Zone', 'Estimote']
      notes: 'Beacon placed at Member Area at 8/F Garage Society'
    }, {
      uuid: 'B9407F30-F5F8-466E-AFF9-25556B57FE6D'
      major: 8
      minor: 31664
      zones: ['Classroom', 'Estimote']
      notes: 'Beacon placed inside GA Batman Classroom at 8/F Garage Society'
    }
  ]
  beacons2 = [
    {
      uuid: '884EBE62-891D-495A-AF57-17CA0CDA86B8'
      major: 1
      minor: 1
      zones: ['Cyber Port']
      notes: 'Cyber Port is so empty'
    }, {
      uuid: 'F5645C90-A5FD-4E46-8090-B39B42280372'
      major: 1
      minor: 2
      zones: ['Garage']
      notes: 'Garage needs more comfortable chairs'
    }, {
      uuid: '13662EC6-9FAA-49A4-B73B-2FC3B32CA012'
      major: 1
      minor: 3
      zones: ['Cocoon']
      notes: 'Cocoon is spacious'
    }
  ]
  for beacon in beacons1
    Beacons.insert (_.extend beacon, {userId: userId})
  for beacon in beacons2
    Beacons.insert (_.extend beacon, {userId: userId})

if MobileApps.find().count() is 0
  mobileApps = [
    {
      userId: userId
      name: 'KODW'
      appKey: 'jdFYjuCqWyCdrywPT'
      zones: _.pluck Zones.find(text: {$in: zones1}).fetch(), '_id'
    }, {
      userId: userId
      name: 'Garage'
      appKey: 'ff4d7e089391392c14547f2d'
      zones: _.pluck Zones.find(text: {$in: zones2}).fetch(), '_id'
    }
  ]
  for mobileApp in mobileApps
    MobileApps.insert mobileApp
  kodw = MobileApps.findOne(name: 'KODW')
  id = MobileAppUsers.findOne(appKey: kodw.appKey)
  MobileAppUsers.update id,
    $set:
      token: 'edf738034d2c903cba3a985bb466baedc22c7636ab976e9adb46d4480d8cec96'
      deviceType: 'iOS'

if Logs.find().count() is 0
  randomTimestamp = (momentObj, times) ->
    nextDay = moment(momentObj).endOf('day')
    momentObj.add 'milliseconds', Math.random() * Math.min(36000000 / times, nextDay.diff(momentObj))
  for app in MobileApps.find().fetch()
    for mobileAppUser in MobileAppUsers.find(appKey: app.appKey).fetch()
      for zone in Zones.find(_id: {$in: app.zones}).fetch()
        for beacon in Beacons.find(_id: {$in: zone.beacons}).fetch()
          for i in [10..1]
            timestamp = moment().subtract('days', i).hours(9)
            randomTimes = _.sample [0, 1, 3, 5, 7, 9]
            unless randomTimes is 0
              for j in [0..randomTimes]
                date = randomTimestamp(timestamp, randomTimes).valueOf()
                log =
                  time: date
                  uuid: beacon.uuid
                  major: beacon.major
                  minor: beacon.minor
                  appKey: app.appKey
                log.deviceId = mobileAppUser.deviceId
                Logs.insert log
if Areas.find().count() is 0
  for app in MobileApps.find().fetch()
    areas = ['A', 'B', 'C', 'D']
    for a in areas
      area =
        name: a
        appKey: app.appKey
      Areas.insert area