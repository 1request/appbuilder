@P12s = new FS.Collection 'p12s',
  stores: [new FS.Store.FileSystem('p12s', path: '~/uploads/p12s')]
  filter:
    maxSize: 4096
    allow:
      extensions: ['p12']
    onInvalid: (message) ->
      if Meteor.isClient
        throwAlert message

P12s.allow
  'insert': (userId, doc) ->
    true
  'update': (userId, doc) ->
    true

@Pems = new FS.Collection 'pems',
  stores: [new FS.Store.FileSystem('pems', path: '~/uploads/pems')]
  filter:
    maxSize: 4096
    allow:
      extensions: ['pem']
    onInvalid: (message) ->
      if Meteor.isClient
        throwAlert message

saveToCollection = (path, type, p12Id, mobileApp) ->
  fs = Npm.require 'fs'
  file = new FS.File(path)
  file.metadata =
    p12: p12Id
  Pems.insert file, (error, result) ->
    if error then console.log 'error: ' + error
    fs.unlink path
    modifier = {}
    modifier[type] = result._id
    MobileApps.update mobileApp._id,
      $set:
        modifier

processP12 = (id) ->
  if Meteor.isServer
    path        = Meteor.require 'path'
    exec        = Npm.require('child_process').exec
    Future      = Npm.require 'fibers/future'
    fs          = Npm.require 'fs'

    p12         = P12s.findOne(id)

    buffer      = ''

    fut         = new Future()
    p12         = P12s.findOne(id)
    p12Path     = Meteor.settings.storageDirectory + 'p12s/' + p12.copies.p12s.key
    certPemPath = Meteor.settings.storageDirectory + 'tmp/cert-' + p12._id + '.pem'
    keyPemPath  = Meteor.settings.storageDirectory + 'tmp/key-' + p12._id + '.pem'

    exec "openssl pkcs12 -in #{p12Path} -out #{certPemPath} -clcerts -nokeys -password pass:", { timeout: 100 }, (error, stdout, stderr) ->
      if /password/i.test stderr.toString()
        fut.return { error: 'p12 has passphrase, please upload one without passphrase'}
        fs.unlink certPemPath
      else
        exec "openssl pkcs12 -in #{p12Path} -out #{keyPemPath} -nodes -nocerts -password pass:", { timeout: 100 }, (error, stdout, stderr) ->
          fut.return { certPemPath: certPemPath, keyPemPath: keyPemPath, error: false }

    fut.wait()

Meteor.methods
  'transformP12': (id) ->
    mobileApp = MobileApps.findOne(p12: id)
    pem = Pems.findOne({'metadata.p12': id})
    unless pem
      result = processP12(id)
      if result
        unless result.error
          saveToCollection(result.certPemPath, 'cert', id, mobileApp)
          saveToCollection(result.keyPemPath, 'key', id, mobileApp)
          { response: 'pem successfully created'}
        else
          P12s.remove(id)
          result
