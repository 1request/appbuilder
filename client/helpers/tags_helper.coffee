@runSelect2 = ->
  $('#tags').select2
    tags: _.pluck Tags.find().fetch(), 'text'
  $('#tags').select2('val', Session.get('selectedTags'))

@setSelectedTags = (tags) ->
  _.pluck(Tags.find(_id: {$in: tags}).fetch(), 'text')

@setBeaconForm = (e)->
  post =
    uuid: $(e.target).find('[name=uuid]').val()
    major: $(e.target).find('[name=major]').val()
    minor: $(e.target).find('[name=minor]').val()
    notes: $(e.target).find('[name=notes]').val()
    tags: $(e.target).find('[name=tags]').val()