Template.newBeacon.helpers

Template.newBeacon.events
  'submit form': (e) ->
    e.preventDefault()
    post =
      uuid: $(e.target).find('[name=uuid]').val()
      major: $(e.target).find('[name=major]').val()
      minor: $(e.target).find('[name=minor]').val()
      notes: $(e.target).find('[name=notes]').val()
    Beacons.create post, (error, result) ->
      if error
        throwAlert(error.reason)
      else
        Router.go('beacons')

Template.newBeacon.rendered = ->