chalk = require 'chalk'
Bacon = require 'baconjs'

logResult = console.log.bind null, chalk.green 'Aggregated Results:'
logError = console.error.bind null, chalk.red 'Errors:'

asyncServer = (name, cb) ->
    setTimeout ->
        if Math.random() > 0.5
            cb name + ' errors'
        else
            cb null, name
    , Math.random() * 100

batchCall = Bacon.fromArray [1..10].map (n) -> 'server' + n
    .flatMap (server) ->
        Bacon.fromNodeCallback asyncServer.bind null, server
    # .endOnError() # end the stream on first error

results = batchCall.reduce [], (seed, value) ->
        seed.concat value
results.onValue logResult

errors = batchCall.errors()
    .mapError( (err) -> err )
    .reduce([],  '.concat')
errors.onValue logError