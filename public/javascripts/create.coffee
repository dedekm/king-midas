# Classes
Hero = require './game_objects/hero.coffee'
Enemy = require './game_objects/enemy.coffee'
Item = require './game_objects/item.coffee'
Gold = require './game_objects/gold.coffee'
Inventory = require './inventory/inventory.coffee'

# Functions
keydown = require './create/keydown.coffee'
buildMap = require './create/build_map.coffee'

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
  
  @add.customGroup = (klass, x, y, key, frame, amount) ->
    custom = @custom(Item, x, y, key, frame)
    for i in [0..amount - 1]
      custom.addItem new klass(@scene, 0, 0, key, frame)
      
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
  @add.custom(Gold, 5, 4, 50)

  @add.customGroup(Item, 8, 3, 'melon', null, 3)
  @add.customGroup(Item, 9, 3, 'green_ball', null, 4)
  
  @input.keyboard.on 'keydown', keydown
