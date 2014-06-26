Template.mobileApp.created = ->
  loadResources()

Template.mobileApp.helpers
  mobileApp: ->
    MobileApps.findOne()
  count: ->
    Session.get 'monthCount'
  path: ->
    if MobileAppUsers.findOne() and MobileApps.findOne()
      Router.routes['monthlyLog'].path({deviceId: MobileAppUsers.findOne().deviceId, appKey: MobileApps.findOne().appKey})

Template.mobileApp.rendered = ->
  $('nav#menu').mmenu
    searchfield : true
    slidingSubmenus: true

  @countDep = Deps.autorun ->
    Counts.findOne()
    Meteor.call 'monthlyCount', MobileAppUsers.findOne().deviceId, (error, result) ->
      Session.set 'monthCount', result

Template.mobileApp.destroyed = ->
  removeResources()
  location.reload()
  if @countDep
    @countDep.stop()
