# forge = Meteor.require 'node-forge'
# path = Meteor.require 'path'
# spawn = Npm.require('child_process').spawn
# Future = Npm.require 'fibers/future'

# throwP12Error = (result) ->
#   console.log 'cannot process p12 file. Maybe passphrase exists?', result

# Meteor.methods
#   'transformP12': (id, passphrase) ->
#     fut = new Future()
#     p12 = P12s.findOne(id)
#     p12Path = '~/uploads/p12s/' + p12.copies.p12s.key
#     pemPath = '~/uploads/p12s/' + id + '.pem'
#     openssl = spawn 'openssl', ['pkcs12', '-in', p12Path, '-out', pemPath, '-clcerts', '-nokeys']
#     openssl.stdout.on 'data', (data) ->
#       buffer += data
#     openssl.stderr.on 'data', (data) ->
#       if data
#         openssl.kill()
#         throwP12Error(buffer)
#     openssl.on 'close', (code) ->
#       fut.return buffer
#     fut.wait()

    # spawn "openssl pkcs12 -in #{p12Path} -out #{pemPath} -clcerts -nokeys", (error, stdout, stderr) ->
    #   console.log 'stdout: ', stdout
    #   console.log 'stderr: ', stderr
    #   if !!error
    #     console.log 'error: ', error
    #   else
    #     addPemsToCollection()




# processP12 = (id) ->
#   result = ''
#   if Meteor.isServer
#     forge = Meteor.require 'node-forge'
#     path = Meteor.require 'path'
#     spawn = Npm.require('child_process').spawn
#     Future = Npm.require 'fibers/future'
#     buffer = ''
#     error = ''
#     fut = new Future()
#     p12 = P12s.findOne(id)
#     p12Path = 'p12s/' + p12.copies.p12s.key
#     pemPath = 'pems/' + id + '.pem'
#     openssl = spawn 'openssl', ['pkcs12', '-in', p12Path, '-out', pemPath, '-clcerts', '-nokeys']
#     openssl.stdout.on 'data', (data) ->
#       buffer += data
#     openssl.stderr.on 'data', (data) ->
#       if data
#         openssl.kill()
#         error = data.toString()
#     openssl.on 'close', (code) ->
#       fut.return {error: error, buffer: buffer}
#     result = fut.wait()
#   result
