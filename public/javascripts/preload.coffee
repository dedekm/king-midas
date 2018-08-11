module.exports = ->
  @load.setBaseURL('http://labs.phaser.io')
  
  @load.image('clown', 'assets/sprites/clown.png')
  @load.image('ball', 'assets/sprites/blue_ball.png')
  @load.image('eggplant', 'assets/sprites/eggplant.png')
  @load.image('melon', 'assets/sprites/melon.png')
  @load.image('tiles', 'assets/tilemaps/tiles/drawtiles-spaced.png')
  @load.tilemapCSV('map', 'assets/tilemaps/csv/grid.csv')
