Character = require './character.coffee'

class Hero extends Character
  constructor: (scene, x, y, key, frame) ->
    super scene, x, y, key, frame

  move: (x, y) ->
    super(x, y)
    if @scene.input.dropzone
      @scene.inventory.setZonePosition()
    
module.exports = Hero
