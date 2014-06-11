Template.newBeacon.helpers

Template.newBeacon.events
  'submit form': (e) ->
    e.preventDefault()
    post =
      uuid: $(e.target).find('[name=uuid]').val()
      major: $(e.target).find('[name=major]').val()
      minor: $(e.target).find('[name=minor]').val()
      notes: $(e.target).find('[name=notes]').val()
      tags: $(e.target).find('[name=tags]').val()
    Beacons.createBeacon post, (error, result) ->
      if error
        throwAlert(error.reason)
      else
        Router.go('beacons')

Template.newBeacon.rendered = ->
  $('#tags').select2
    tags: _.pluck Tags.find().fetch(), 'text'