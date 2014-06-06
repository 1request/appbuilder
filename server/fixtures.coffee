if Meteor.users.find().count() is 0
  Accounts.createUser {username: 'joe', email: 'joe@j.com', password: '1'}

if Mobile.find().count() is 0
  mobiles = [
    {
      userId: Meteor.users.findOne(username: 'joe')._id
      title: 'initial'
      imageUrls: []
    }, {
      userId: Meteor.users.findOne(username: 'joe')._id
      title: 'initial2'
      imageUrls: []
    }
  ]
  for mobile in mobiles
    Mobile.insert mobile


if Members.find().count() is 0
  members = [
    {
      appId: Mobile.findOne(title: 'initial')._id
      username: 'harryng'
      deviceId: '3516AE72-4277-4783-93E8-CB5830E44ED2'
    }, {
      appId: Mobile.findOne(title: 'initial2')._id
      username: 'joseph'
      deviceId: 'A343F3D3-7BF6-4E3A-93B0-E562D99A82C8'
    }, {
      appId: Mobile.findOne(title: 'initial')._id
      username: 'kevin'
      deviceId: '7E8E5CA6-A7CC-4759-A4B6-D795D7E105F6'
    }
  ]
  for member in members
    Members.insert member


if Tags.find().count() is 0
  tags1 = ['Reception', 'Estimote', 'Open Area', 'Roof', 'Member Zone', 'Classroom']
  tags2 = ['Cyber Port', 'Garage', 'Cocoon']
  for i in tags1
    Tags.insert {name: i, appId: Mobile.findOne(title: 'initial')._id}
  for i in tags2
    Tags.insert {name: i, appId: Mobile.findOne(title: 'initial2')._id}

if Beacons.find().count() is 0
  beacons1 = [
    {
      uuid: 'B9407F30-F5F8-466E-AFF9-25556B57FE6D'
      major: '9'
      minor: '62353'
      tags: [Tags.findOne(name: 'Reception')._id, Tags.findOne(name: 'Estimote')._id]
      notes: 'Beacon placed at reception of 9/F Garage Society'
    }, {
      uuid: 'B9407F30-F5F8-466E-AFF9-25556B57FE6D'
      major: '9'
      minor: '26057'
      tags: [Tags.findOne(name: 'Open Area')._id, Tags.findOne(name: 'Estimote')._id]
      notes: 'Beacon placed at the Open Area of 9/F Garage Society'
    }, {
      uuid: 'B9407F30-F5F8-466E-AFF9-25556B57FE6D'
      major: '9'
      minor: '50549'
      tags: [Tags.findOne(name: 'Roof')._id, Tags.findOne(name: 'Estimote')._id]
      notes: 'Beacon placed at Roof (Outdoor) at 9/F Garage Society'
    }, {
      uuid: 'B9407F30-F5F8-466E-AFF9-25556B57FE6D'
      major: '8'
      minor: '7102'
      tags: [Tags.findOne(name: 'Reception')._id, Tags.findOne(name: 'Estimote')._id]
      notes: 'Beacon placed at Reception at 8/F Garage Society'
    }, {
      uuid: 'B9407F30-F5F8-466E-AFF9-25556B57FE6D'
      major: '8'
      minor: '31008'
      tags: [Tags.findOne(name: 'Member Zone')._id, Tags.findOne(name: 'Estimote')._id]
      notes: 'Beacon placed at Member Area at 8/F Garage Society'
    }, {
      uuid: 'B9407F30-F5F8-466E-AFF9-25556B57FE6D'
      major: '8'
      minor: '31664'
      tags: [Tags.findOne(name: 'Classroom')._id, Tags.findOne(name: 'Estimote')._id]
      notes: 'Beacon placed inside GA Batman Classroom at 8/F Garage Society'
    }
  ]
  beacons2 = [
    {
      uuid: '884EBE62-891D-495A-AF57-17CA0CDA86B8'
      major: '1'
      minor: '0001'
      tags: [Tags.findOne(name: 'Cyber Port')._id]
      notes: 'Cyber Port is so empty'
    }, {
      uuid: 'F5645C90-A5FD-4E46-8090-B39B42280372'
      major: '1'
      minor: '0002'
      tags: [Tags.findOne(name: 'Garage')._id]
      notes: 'Garage needs more comfortable chairs'
    }
  ]
  for beacon in beacons1
    Beacons.insert (_.extend beacon, {appId: Mobile.findOne(title: 'initial')._id})
  for beacon in beacons2
    Beacons.insert (_.extend beacon, {appId: Mobile.findOne(title: 'initial2')._id})

if Logs.find().count() is 0
  randomTimestamp = (momentObj, times) ->
    nextDay = moment(momentObj).endOf('day')
    momentObj.add 'milliseconds', Math.random() * Math.min(36000000 / times, nextDay.diff(momentObj))
  for app in Mobile.find().fetch()
    for member in Members.find(appId: app._id).fetch()
      for beacon in Beacons.find(appId: app._id).fetch()
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
              log.deviceId = member.deviceId
              Logs.insert log