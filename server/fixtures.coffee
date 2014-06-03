if Mobile.find().count() is 0
  Mobile.insert
    title: 'initial'
    imageUrls: []

if Tags.find().count() is 0
  tags = ['Reception', 'Estimote', 'Open Area', 'Roof', 'Member Zone', 'Classroom']
  for i in tags
    Tags.insert {name: i}

if Beacons.find().count() is 0
  beacons = [
    {
      uuid: 'B9407F30-F5F8-466E-AFF9-25556B57FE6D'
      major: '9'
      minor: '62353'
      tags: [Tags.findOne(name: 'Reception')._id, Tags.findOne(name: 'Estimote')._id]
      notes: 'Beacon placed at reception of 9/F Garage Society'
      count: 0
    }, {
      uuid: 'B9407F30-F5F8-466E-AFF9-25556B57FE6D'
      major: '9'
      minor: '26057'
      tags: [Tags.findOne(name: 'Open Area')._id, Tags.findOne(name: 'Estimote')._id]
      notes: 'Beacon placed at the Open Area of 9/F Garage Society'
      count: 0
    }, {
      uuid: 'B9407F30-F5F8-466E-AFF9-25556B57FE6D'
      major: '9'
      minor: '50549'
      tags: [Tags.findOne(name: 'Roof')._id, Tags.findOne(name: 'Estimote')._id]
      notes: 'Beacon placed at Roof (Outdoor) at 9/F Garage Society'
      count: 0
    }, {
      uuid: 'B9407F30-F5F8-466E-AFF9-25556B57FE6D'
      major: '8'
      minor: '7102'
      tags: [Tags.findOne(name: 'Reception')._id, Tags.findOne(name: 'Estimote')._id]
      notes: 'Beacon placed at Reception at 8/F Garage Society'
      count: 0
    }, {
      uuid: 'B9407F30-F5F8-466E-AFF9-25556B57FE6D'
      major: '8'
      minor: '31008'
      tags: [Tags.findOne(name: 'Member Zone')._id, Tags.findOne(name: 'Estimote')._id]
      notes: 'Beacon placed at Member Area at 8/F Garage Society'
      count: 0
    }, {
      uuid: 'B9407F30-F5F8-466E-AFF9-25556B57FE6D'
      major: '8'
      minor: '31664'
      tags: [Tags.findOne(name: 'Classroom')._id, Tags.findOne(name: 'Estimote')._id]
      notes: 'Beacon placed inside GA Batman Classroom at 8/F Garage Society'
      count: 0
    }
  ]
  for beacon in beacons
    Beacons.insert beacon

if Logs.find().count() is 0
  randomTimestamp = (momentObj, times) ->
    nextDay = moment(momentObj).endOf('day')
    momentObj.add 'milliseconds', Math.random() * Math.min(36000000 / times, nextDay.diff(momentObj))

  for beacon in Beacons.find().fetch()
    for i in [2..1]
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
            userId: 'harryng'
          Logs.insert log