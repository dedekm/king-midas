Character = require './character.coffee'

class Hero extends Character
  constructor: (scene, x, y, key, frame) ->
    super scene, x, y, key, frame

  move: (x, y) ->
    super(x, y)
    
module.exports = Hero
