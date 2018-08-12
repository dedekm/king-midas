class Item extends Phaser.GameObjects.Sprite
  constructor: (scene, x, y, key, frame) ->
    super scene, x, y, key, frame
    
    @type = 'item'
    @value = 10

module.exports = Item
