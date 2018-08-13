Hero = require './game_objects/hero.coffee'
Enemy = require './game_objects/enemy.coffee'
Item = require './game_objects/item.coffee'
Gold = require './game_objects/gold.coffee'
Inventory = require './inventory/inventory.coffee'
EasyStar = require 'easystarjs'

buildMap = (scene) ->
  map = scene.make.tilemap key: 'map',
                           tileWidth: scene.tileSize,
                           tileHeight: scene.tileSize
  tileset = map.addTilesetImage 'tiles', null,
                                scene.tileSize, scene.tileSize,
                                1, 2
  scene.walls = map.createStaticLayer(0, tileset, 0, 0)
  
  scene.finder = new EasyStar.js();
  scene.objects = []
  scene.grid = []
  y = 0
  while y < map.height
    scene.objects.push []
    
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
      for object in @objects
        @totalValue += object.value if object.type == 'item'
      for object in @inventory.list
        @totalValue += object.value
      @totalValueDirty = false
    return @totalValue
  
  @getTileXY = (x, y) ->
    {
      x: (x - @tileSizeHalf) / @tileSize,
      y: (y - @tileSizeHalf) / @tileSize
    }
    
  @getTileAtXY = (x, y) ->
    @walls.getTileAtWorldXY(x * @tileSize, y * @tileSize, true)
  
  @getItemAtXY = (x, y) ->
    @objects[y][x]
  
  @setItemAtXY = (x, y, item) ->
    @objects[y][x] = item
  
  @getGrid = (x, y) ->
    @grid[y][x]
    
  @setGrid = (x, y, value) ->
    @grid[y][x] = value
      
  @tileSize = 32
  @tileSizeHalf = @tileSize / 2
  
  buildMap(@)
  
  @steps = 0
  @enemies = new Phaser.Structs.List()
  @inventory = new Inventory(@)
  
  @hero = @add.custom(Hero, 1, 1, 'clown')
  @hero.attack = 50
  @hero.defense = 10
  
  enemy = @add.custom(Enemy, 3, 3, 'ufo')
  enemy.attack = 15
  enemy.defense = 5
  
  enemy = @add.custom(Enemy, 4, 3, 'ufo')
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

      
      if item = @scene.getItemAtXY(newPos.x, newPos.y)
        if item.type && item.type == 'enemy'
          item.defend(@scene.hero.attack)
          
          if item.health <= 0
            item.die()
          else
            item.wasAttacked = true
            @scene.hero.defend(item.attack)
          canMove = false
        else
          if @scene.inventory.addItem(item)
            @scene.setItemAtXY(item.tileX, item.tileY, undefined)
          else
            canMove = false

      if canMove
        @scene.steps++
        @scene.hero.moveTo(newPos.x, newPos.y)
      
      if @scene.input.dropzone
        @scene.inventory.setDropzonePosition()
      
      @scene.finder.calculate()
