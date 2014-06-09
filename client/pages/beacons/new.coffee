Template.newBeacon.helpers

Template.newBeacon.events
  'submit form': (e) ->
    e.preventDefault()
    post =
      uuid: $(e.target).find('[name=uuid]').val()
      major: $(e.target).find('[name=major]').val()
      minor: $(e.target).find('[name=minor]').val()
      notes: $(e.target).find('[name=notes]').val()
    console.log 'post', post

Template.newBeacon.rendered = ->