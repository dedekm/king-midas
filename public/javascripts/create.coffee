Hero = require './game_objects/hero.coffee'
Enemy = require './game_objects/enemy.coffee'
Item = require './game_objects/item.coffee'
Gold = require './game_objects/gold.coffee'
Inventory = require './inventory/inventory.coffee'
EasyStar = require 'easystarjs'

buildMap = (scene) ->
  map = scene.make.tilemap(key: 'map', tileWidth: 32, tileHeight: 32)
  tileset = map.addTilesetImage('tiles', null, 32, 32, 1, 2)
  scene.walls = map.createStaticLayer(0, tileset, 0, 0)
  
  scene.finder = new EasyStar.js();
  scene.grid = []
  y = 0
  while y < map.height
    col = []
    x = 0
    while x < map.width
      # In each cell we store the ID of the tile, which corresponds
      # to its index in the tileset of the map ("ID" field in Tiled)
      col.push map.getTileAt(x, y).index
      x++
    scene.grid.push col
    y++
  
  scene.finder.setGrid scene.grid
  scene.finder.setAcceptableTiles([0]);

module.exports = ->
  @totalValueDirty = true
  @totalValue = 0
  @getTotalValue = ->
    if @totalValueDirty
      @totalValue = 0
      for object in @objects.list
        @totalValue += object.value if object.type == 'item'
      for object in @inventory.list
        @totalValue += object.value
      @totalValueDirty = false
    return @totalValue
  
  @getTileAtXY = (x, y) ->
    @walls.getTileAtWorldXY(x * @tileSize, y * @tileSize, true)
  
  @getGrid = (x, y) ->
    @grid[y][x]
    
  @setGrid = (x, y, value) ->
    @grid[y][x] = value
      
  buildMap(@)
  
  @tileSize = 32
  @tileSizeHalf = @tileSize / 2
  @steps = 0
  @objects = new Phaser.Structs.List()
  @enemies = new Phaser.Structs.List()
  @inventory = new Inventory(@)
  
  @hero = @add.custom(Hero, 1, 1, 'clown')
  @hero.attack = 50
  @hero.defense = 10
  
  enemy = @add.custom(Enemy, 3, 3, 'ufo')
  enemy.attack = 15
  enemy.defense = 5
  
  @add.custom(Item, 5, 1, 'ball')
  @add.custom(Item, 5, 3, 'ball')
  @add.custom(Item, 6, 3, 'green_ball')
  @add.custom(Item, 5, 8, 'eggplant')
  @add.custom(Item, 7, 3, 'eggplant')
  @add.custom(Gold, 2, 4, 20)
  @add.custom(Gold, 3, 4, 30)
  @add.custom(Gold, 4, 4, 20)
  
  grouped = @add.custom(Item, 8, 3, 'melon')
  grouped.addItem new Item(@, 0, 0, 'melon')
  
  @input.keyboard.on 'keydown', (event) ->
    newPos = {
      x: @scene.hero.tileX
      y: @scene.hero.tileY
    }

    switch event.key
      when 'w'
        newPos.y -= 1
      when 's'
        newPos.y += 1
      when 'a'
        newPos.x -= 1
      when 'd'
        newPos.x += 1
      else
        return
    
    unless @scene.getTileAtXY(newPos.x, newPos.y, true).index == 2
      for enemy in @scene.enemies.list
        enemy.move()
      
      canMove = true

      for item, i in @scene.objects.list
        if item.tileX == newPos.x && item.tileY == newPos.y
          if item.type && item.type == 'enemy'
            item.health -= @scene.hero.attack - item.defense
            if item.health <= 0
              item.die()
            else
              @scene.hero.health -= item.attack - @scene.hero.defense
            canMove = false
            break
          else
            if @scene.inventory.addItem(item)
              @scene.objects.remove(item)
            else
              canMove = false
            break

      if canMove
        @scene.steps++
        @scene.hero.moveTo(newPos.x, newPos.y)
      
      @scene.finder.calculate()
