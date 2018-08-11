module.exports = ->
  @tileSize = 32
  @steps = 0
  @items = []
  @inventory = []
  
  hero = @add.sprite(32 + 16, 32 + 16, 'clown')
  @items.push @add.sprite(32 * 5 + 16, 32 + 16, 'ball')
  @items.push @add.sprite(32 * 5 + 16, 32 * 3 + 16, 'ball')
  @items.push @add.sprite(32 * 5 + 16, 32 * 8 + 16, 'eggplant')
  @items.push @add.sprite(32 * 7 + 16, 32 * 3 + 16, 'eggplant')
  @items.push @add.sprite(32 * 8 + 16, 32 * 3 + 16, 'melon')
  
  map = @make.tilemap(key: 'map', tileWidth: 32, tileHeight: 32)
  tileset = map.addTilesetImage('tiles', null, 32, 32, 1, 2)
  layer = map.createStaticLayer(0, tileset, 0, 0)
  
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
    
    tile = layer.getTileAtWorldXY(newPos.x, newPos.y, true)
    unless tile.index == 2
      @scene.steps++
      hero.x = newPos.x
      hero.y = newPos.y

      for item, i in @scene.items
        if item.x == hero.x && item.y == hero.y
          owned = false
          for itemInInventory, j in @scene.inventory
            if item.texture.key == itemInInventory.texture.key
              owned = true

              @scene.items.splice(i, 1)
              # item.destroy()
              item.y = 480 - 32 / 2 - 6
              item.x = (j + 1) * 32 + 32 / 2
              break
            
          unless owned
            @scene.inventory.push item
            @scene.items.splice(i, 1)
            item.y = 480 - 32 / 2
            item.x = @scene.inventory.length * 32 + 32 / 2
          
          @scene.children.bringToTop(item);
          break
