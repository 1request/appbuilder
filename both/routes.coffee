Router.configure
  layoutTemplate: 'layout'
  loadingTemplate: 'loading'

Router.map ->
  @route 'main', { path: '/' }
  @route 'editMobile',
    path: 'edit-apps'
    waitOn: ->
      Meteor.subscribe 'mobile', {}
      Meteor.subscribe 'mobileAppUsers', {}
      Meteor.subscribe 'tags', {}
  @route 'mobile',
    path: 'mobile/:deviceId'
    waitOn: ->
      [
        Meteor.subscribe 'mobileTags', { deviceId: @params.deviceId }
        Meteor.subscribe 'mobile', { deviceId: @params.deviceId }
        Meteor.subscribe 'mobileAppUsers', { deviceId: @params.deviceId }
        Meteor.subscribe 'counts-by-mobileAppUser', { deviceId: @params.deviceId }
      ]
  @route 'dashboard',
    path: 'dashboard'
    waitOn: ->
      [
        Meteor.subscribe 'mobile', {}
        Meteor.subscribe 'mobileAppUsers', {}
      ]

  @route 'beacons',    { path: '/beacons',          controller: Beacons.index }
  @route 'newBeacon',  { path: '/beacons/new',      controller: Beacons.new }
  @route 'showBeacon', { path: '/beacons/:id',      controller: Beacons.show }
  @route 'editBeacon', { path: '/beacons/edit/:id', controller: Beacons.edit }

requireLogin = (pause) ->
  unless Meteor.user()
    if Meteor.loggingIn()
      @render @loadingTemplate
    else
      Router.go 'main'
    pause()

afterLogin = (pause) ->
  if Meteor.user()
    Router.go 'editMobile'
    pause()

Router.onBeforeAction 'loading'
Router.onBeforeAction -> clearAlerts()
Router.onBeforeAction requireLogin, { except: ['main', 'mobile'] }
Router.onBeforeAction afterLogin, { only: 'main' }