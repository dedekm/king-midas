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
  @tileSize = 29
  @tileSizeHalf = @tileSize / 2
  
  @totalValue = 0
  @totalValueText = @add.text 1050, 140
  @totalValueText.depth = 1000
  @addToTotalValue = (value) ->
    @totalValue += value
    @totalValueText.setText(@totalValue)
  
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
      
  @add.item = (x, y, key) ->
    @custom(Item, x, y, key)
  
  buildMap(@)
  
  @steps = 0
  @enemies = new Phaser.Structs.List()
  @inventory = new Inventory(@)
  
  @hero = @add.custom(Hero, 17, 2, 'knight')
  @hero.attack = 50
  @hero.defense = 10
  
  @add.custom(Enemy, 4, 5)
  @add.custom(Enemy, 28, 16)
  @add.custom(Enemy, 3, 17)
  @add.custom(Enemy, 23, 13)
  
  @add.item(7, 8, 'axe2')
  @add.item(10, 10, 'gold1')
  @add.item(12, 15, 'goblet')
  @add.item(28, 3, 'gold2', null)
  
  @input.keyboard.on 'keydown', keydown
