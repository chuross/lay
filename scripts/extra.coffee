###
素敵機能集
###


module.exports = (robot) ->

  ###
  V-MAX発動
  ###
  robot.respond /V-MAX発動/, (res) ->
    res.send 'レディ'
    res.send 'http://chuross.github.io/lay/lay.gif'
