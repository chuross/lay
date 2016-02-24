###
基本機能
###

LayConfig = require './lay_config'
RoboTalk = require './robotalk'

module.exports = (robot) ->

  ###
  help
  ###
  robot.respond /--help/i, (res) ->
    res.send '''
      `initialize` - botの設定を初期化する
      `restart` - botを再起動する
      `update` - botをアップデートする
      `config` - botの設定を操作する
      `repository` - repositoryを操作する
    '''


  ###
  設定を初期化
  ###
  initBuilder = new RoboTalk.Builder(robot)
  initBuilder.pattarn = /initialize/i
  initBuilder.message = 'レディ 現在の設定を初期化しますか？(Y/n)'
  initBuilder.timeout = 10 * 1000

  initBuilder.talks.push initializationTalk(robot)

  initBuilder.build().setup()


  ###
  再起動
  ###
  robot.respond /restart/i, (res) ->
    res.send 'レディ 再起動します'
    setTimeout ->
      process.exit()
    , 1000


  ###
  設定の確認
  ###
  robot.respond /config$/i, (res) ->
    res.send "レディ #{JSON.stringify(LayConfig.getAll())}"


  ###
  設定の登録
  ###
  robot.respond /config (.*) (.*)/i, (res) ->
    key = res.match[1]
    value = res.match[2]

    exists = false
    configs = LayConfig.getAll()
    for configKey of configs
      if configKey == key
        exists = true
        if LayConfig.put(key, value)
          res.send "レディ #{JSON.stringify(LayConfig.getAll())}"
        else
          res.send "失敗 `put config #{key} #{value}`"

    res.send '正しい値ではありません' if !exists


###
internal
###
initializationTalk = (robot) ->
  talk = new RoboTalk.Talk(robot)
  talk.errorMessage = "この操作は初期化シーケンスで使用します `@#{robot.name} initialize`"

  action1 = new RoboTalk.TalkAction
  action1.reaction = 'hear'
  action1.pattarn = /^Y$/
  action1.message = 'レディ 初期化しました'
  action1.timeout = 60 * 1000
  action1.call = (res) ->
    LayConfig.reset()
    configs = LayConfig.getAll()
    commandStr = ""
    for key of configs
      commandStr += "`@#{robot.name} config #{key} \<value\>`\n"
    res.send '各種設定項目を入力してください'
    res.send commandStr

  action2 = new RoboTalk.TalkAction
  action2.reaction = 'hear'
  action2.pattarn = /^n$/
  action2.message = 'レディ 初期化をキャンセルします'
  action2.timeout = 60 * 1000
  action2.call = (res, robotalk) ->
    robotalk.state.reset()

  talk.actions.push action1
  talk.actions.push action2

  return talk
