#
# 基本機能
#
module.exports = (robot) ->
  
  #
  # help
  #
  robot.respond /--help/i, (res) ->
    res.send '''
    `initialize` - botの設定を初期化します
    `restart` - botを再起動します
    `update` - botをアップデートします
    '''

  #
  # 再起動
  #
  robot.respond /restart/i, (res) ->
    res.send 'レディ 再起動します'
    setTimeout ->
      process.exit()
    , 1000
