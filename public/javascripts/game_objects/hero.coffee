Character = require './character.coffee'

class Hero extends Character
  constructor: (scene, x, y, key, frame) ->
    super scene, x, y, key, frame
    
  defend: (value) ->
    super value
    
    if @health <= 0
      @willDie = true
  
  move: (x, y) ->
    super(x, y)
  
  die: () ->
    @scene.add.image(@x, @y, 'things', 13)
    @destroy()
    
module.exports = Hero
