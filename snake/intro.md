# snake
http://philipnilsson.github.io/badness/

先介绍 Map。

在介绍 Scan/Reduce。

介绍了 map 的 shortcut。

``` coffee
bindInputs = ->
    keys = $(document).asEventStream(‘keydown’).map ‘.keyCode’
    lefts   = keys.filter (x) -> return x is 37
    rights  = keys.filter (x) -> return x is 39
    restart = keys.filter (x) -> return x is 82
    tick    = Bacon.interval 100
    { left: lefts, right: rights, tick: tick, restart: restart }
```

左右方向函数，根据传入的方向向量，计算出左转或右转后新的方向向量。

```  
startDirection = new Vector2 0, 1

rotateRight = (vec) ->
    new Vector2 -vec.y, vec.x

rotateLeft = (vec) ->
    new Vector2 vec.y, -vec.x
```

```
    actions =
        input.left.map(-> rotateLeft).merge (input.right.map -> rotateRight)

```

将键盘事件流，转化为方向函数事件流。

从方向函数事件流获取最终方向：

```scan
	# 初始方向为 Y轴向下
   startDirection = new Vector2 0, 1
	direction = actions.scan startDirection, (curr, f) -> f(curr)
```

根据 100 毫秒的 tick 发生器来计算蛇头位置
```
    direction
        .sampledBy input.tick
        .scan startPosition, (x,y) -> x.add y
```


```

direction ----(0,1)----(1,0)----(0,-1)----(1,0)------>

tick      ---------t---------t---------t---------t--->

position  -------(0,1)-----(1,1)-----(1,0)-----(2,0)->	
```

下面我们来看看 apple 函数应该是怎样的。

```
	有初始的随机位置
	如果snake (蛇头) 吃了apple，那么就生成新的随机位置，继续等待被吃
```


```
apple = (snakePos) ->
    applePos = randomPos()
    snakePos
        .filter (p) -> p.equals applePos
        .take 1
        .flatMapLatest apple.bind null, snakePos
        .toProperty applePos

```

首先获取一个随机坐标作为初始位置
如果 snakePos 的位置和 applePos 相等了，则仅仅考虑第一个相等事件。

