Hero = require './game_objects/hero.coffee'
Enemy = require './game_objects/enemy.coffee'
Inventory = require './inventory/inventory.coffee'

module.exports = ->
  @tileSize = 32
  @steps = 0
  @items = []
  @inventory = new Inventory()
  
  hero = new Hero this, 32 + 16, 32 + 16, 'clown'
  hero.attack = 50
  hero.defense = 10
  @items.push @children.add(hero)
  
  enemy = new Enemy this, 32 * 3 + 16, 32 * 3 + 16, 'ufo'
  enemy.attack = 15
  enemy.defense = 5
  @items.push @children.add(enemy)
  
  @items.push @add.sprite(32 * 5 + 16, 32 + 16, 'ball')
  @items.push @add.sprite(32 * 5 + 16, 32 * 3 + 16, 'ball')
  @items.push @add.sprite(32 * 5 + 16, 32 * 8 + 16, 'eggplant')
  @items.push @add.sprite(32 * 7 + 16, 32 * 3 + 16, 'eggplant')
  @items.push @add.sprite(32 * 8 + 16, 32 * 3 + 16, 'melon')
  
  map = @make.tilemap(key: 'map', tileWidth: 32, tileHeight: 32)
  tileset = map.addTilesetImage('tiles', null, 32, 32, 1, 2)
  @walls = map.createStaticLayer(0, tileset, 0, 0)
  
  @input.keyboard.on 'keydown', (event) ->
    newPos = {
      x: hero.x
      y: hero.y
    }

    switch event.key
      when 'w'
        newPos.y -= @scene.tileSize
      when 's'
        newPos.y += @scene.tileSize
      when 'a'
        newPos.x -= @scene.tileSize
      when 'd'
        newPos.x += @scene.tileSize
    
    tile = @scene.walls.getTileAtWorldXY(newPos.x, newPos.y, true)
    unless tile.index == 2
      @scene.steps++
      canMove = true

      for item, i in @scene.items
        if item.x == newPos.x && item.y == newPos.y
          if item.type && item.type == 'enemy'
            item.health -= hero.attack - item.defense
            if item.health <= 0
              item.die(i)
            else
              hero.health -= item.attack - hero.defense
              console.log hero.health
            canMove = false
            break
          
          @scene.items.splice(i, 1)
          @scene.inventory.add(item)
          @scene.children.bringToTop(item);
          break

      if canMove
        hero.x = newPos.x
        hero.y = newPos.y
