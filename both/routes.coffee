Router.configure
  layoutTemplate: 'layout'
  loadingTemplate: 'loading'
  waitOn: ->
    Meteor.subscribe 'mobile'

Router.map ->
  @route 'edit', { path: '/' }
  @route 'ibeacon', { path: 'config-ibeacon' }
  @route 'mobile', { path: 'mobile' }

Router.onBeforeAction 'loading'