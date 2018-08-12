class InventoryItem
  constructor: (item, amount) ->
    @list = [item]
    @amount = amount
    @type = item.texture.key

module.exports = InventoryItem
