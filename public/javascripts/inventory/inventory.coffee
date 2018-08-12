InventoryItem = require './inventory_item.coffee'

class Inventory extends Phaser.Structs.List
  constructor: (scene)->
    super()
    @scene = scene
    @baseY = 480 - @scene.tileSizeHalf
    @baseX = @scene.tileSize + @scene.tileSizeHalf
    
  add: (item) ->
    item.destroy()
    
    for inventoryItem, j in @list
      if item.category == inventoryItem.category
        inventoryItem.add(item)
        
        return inventoryItem

    super(new InventoryItem(@, item, @length))

module.exports = Inventory
