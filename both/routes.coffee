Router.configure
  layoutTemplate: 'layout'
  loadingTemplate: 'loading'

Router.map ->
  @route 'main', { path: '/' }
  @route 'edit',
    path: 'edit'
    waitOn: ->
      Meteor.subscribe 'mobile', {}
      Meteor.subscribe 'members', {}
  @route 'mobile',
    path: 'mobile/:deviceId'
    waitOn: ->
      [
        Meteor.subscribe 'tags', { deviceId: @params.deviceId }
        Meteor.subscribe 'mobile', { deviceId: @params.deviceId }
        Meteor.subscribe 'members', { deviceId: @params.deviceId }
        Meteor.subscribe 'logs', { deviceId: @params.deviceId }
        Meteor.subscribe 'beacons', { deviceId: @params.deviceId }
      ]
  @route 'dashboard',
    path: 'dashboard'
    waitOn: ->
      [
        Meteor.subscribe 'logs', {}
        Meteor.subscribe 'mobile', {}
        Meteor.subscribe 'members', {}
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
    Router.go 'edit'
    pause()

Router.onBeforeAction 'loading'
Router.onBeforeAction -> clearAlerts()
Router.onBeforeAction requireLogin, { except: ['main', 'mobile'] }
Router.onBeforeAction afterLogin, { only: 'main' }