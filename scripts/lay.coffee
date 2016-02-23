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