Character = require './character.coffee'

class Hero extends Character
  constructor: (scene, x, y, key, frame) ->
    super scene, x, y, key, frame
  
  defend: (value) ->
    super value
    
    if @health <= 0
      console.log 'END!'
  
  move: (x, y) ->
    super(x, y)
    
module.exports = Hero
