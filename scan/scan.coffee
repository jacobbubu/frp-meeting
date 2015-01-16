chalk = require 'chalk'
Bacon = require 'baconjs'

Bacon.fromArray ['c', 'a', 't']
    .scan '', (seed, curr) -> seed + curr
    .onValue console.log.bind console, chalk.red 'Joined string:'

Bacon.fromArray [1, 2, 3]
    .scan 0, (seed, curr) -> seed + curr
    .onValue console.log.bind console, chalk.green 'Summed numbers:'

Bacon.fromArray [1, 2, 3]
    .reduce 0, (seed, curr) -> seed + curr
    .onValue console.log.bind console, chalk.blue 'Reduced:'