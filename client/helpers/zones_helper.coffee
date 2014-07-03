@runSelect2 = (val) ->
  if val
    console.log 'text: ', _.pluck(Zones.find().fetch(), 'text')
    $('#zones').select2
      tags: _.pluck(Zones.find().fetch(), 'text')
    $('#zones').select2('val', val)

@setSelectedZones = (zones) ->
  _.pluck(Zones.find(_id: {$in: zones}).fetch(), 'text')

@setBeaconForm = (e)->
  post =
    uuid: $(e.target).find('[name=uuid]').val()
    major: $(e.target).find('[name=major]').val()
    minor: $(e.target).find('[name=minor]').val()
    notes: $(e.target).find('[name=notes]').val()
    zones: $(e.target).find('[name=zones]').val()