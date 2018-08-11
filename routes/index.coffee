express = require('express')
router = express.Router()

router.get '/', (req, res, next) ->
  res.render 'index', title: 'Full Dungeon'
  return
  
module.exports = router
