class Character extends Phaser.GameObjects.Sprite
  constructor: (scene, x, y, key, frame) ->
    super scene, x, y, key, frame
    
    @health = 100
    @attack = 0
    @defense = 0

module.exports = Character
