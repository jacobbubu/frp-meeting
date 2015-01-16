_ = Bacon._

bindInputs = ->
    keys    = $(document).asEventStream('keydown').map '.keyCode'
    left    = keys.filter (x) -> return x is 37
    right   = keys.filter (x) -> return x is 39
    restart = keys.filter (x) -> return x is 82
    tick    = Bacon.interval 100
    { left, right, tick, restart }

getPosition = (input, tick) ->
    actions =
        input.left.map(-> rotateLeft).merge input.right.map -> rotateRight

    startDirection = new Vector2 0, 1
    startPosition = new Pos 0, 0
    direction = actions.scan startDirection, (curr, f) -> f curr

    direction
        .sampledBy input.tick
        .scan startPosition, (x,y) -> x.add y

apple = (snakeHead) ->
    applePos = randomPos()
    snakeHead
        .filter (p) -> p.equals applePos
        .take 1
        .flatMapLatest apple.bind null, snakeHead
        .toProperty applePos

game = (position) ->
    snakeHead = position()
    appl = apple snakeHead

    length = appl.map(1).scan 10, (x, y) -> x + y
    score  = appl.map(1).scan  0, (x, y) -> x + y
    snake  = snakeHead.slidingWindowBy length

    dead   = snake.filter (body) ->
        contains _.tail(body), _.head(body)

    game = Bacon.combineTemplate {
        snake: snake
        apple: appl
        score: score
    }

    game.takeUntil dead

repeated = (game, restart) ->
    gm = ->
        tmp = game()
        tmp.onEnd logRestart
        tmp
    restart.onValue logClear
    Bacon.separateBy restart, gm

drawGame size

inputs = bindInputs()
position = getPosition.bind null, inputs
newGame = game.bind null, position

repeated(newGame, inputs.restart).onValue (e) ->
    drawSnake e.snake
    drawApple [e.apple]
    setScore e.score