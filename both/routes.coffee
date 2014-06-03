Router.configure
  layoutTemplate: 'layout'
  loadingTemplate: 'loading'
  waitOn: ->
    Meteor.subscribe 'mobile'

Router.map ->
  @route 'edit', { path: '/' }
  @route 'ibeacon', { path: 'config-ibeacon' }
  @route 'mobile',
    path: 'mobile'
    waitOn: ->
      Meteor.subscribe 'beacons'
      Meteor.subscribe 'tags'

Router.onBeforeAction 'loading'
Router.onBeforeAction -> clearAlerts()