InventoryItem = require './inventory_item.coffee'


class Inventory extends Phaser.Structs.List
  constructor: ->
    super()
    
  add: (item) ->
    for inventoryItem, j in @list
      if item.texture.key == inventoryItem.type
        inventoryItem.add(item)
        item.y = 480 - 32 / 2 - 6 * inventoryItem.amount
        item.x = (j + 1) * 32 + 32 / 2
        return inventoryItem

    item.y = 480 - 32 / 2 - 6
    item.x = (j + 1) * 32 + 32 / 2
    super(new InventoryItem(item, 1))

module.exports = Inventory
