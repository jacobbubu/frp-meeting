Bacon = require 'baconjs'

tick = Bacon.interval 1e3, 'tick'
counter = Bacon.interval 100, 1
    .scan 0, (seed, curr) -> seed + curr

counter.sampledBy(tick).log 'Sampled counter:'