class Gold extends Phaser.GameObjects.Sprite
  constructor: (scene, x, y, amount) ->
    super scene, x, y, 'coin'
    
    @category = 'gold'
    @value = amount

module.exports = Gold
