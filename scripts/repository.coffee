###
Gitリポジトリ関連の機能
###

LayConfig = require './lay_config'
Exec = require('child_process').exec

module.exports = (robot) ->
  localRepositoryPath = process.env.HUBOT_LAY_LOCAL_REPOSITORY_PATH

  ###
  ヘルプ
  ###
  robot.respond /repository --help/i, (res) ->
    res.send '''
      repository refresh - repositoryを削除して再度cloneしなおす
      repository remote list - remote先の一覧を表示する
      repository remote add <name> <remotePath> - remote先を登録する
      repository remote rm <name> - remote先を削除する
    '''


  ###
  repositoryを削除して再度cloneしなおす
  ###
  robot.respond /repository refresh/i, (res) ->
    res.send "レディ target #{getRemotePath()}"

    if localRepositoryPath == null or localRepositoryPath == undefined or localRepositoryPath == '/'
      res.send "無効なパスが選択されています #{localRepositoryPath}"
      return

    Exec "rm -rf #{localRepositoryPath} && git clone #{getRemotePath()} #{localRepositoryPath}", (error, stdout, stderr) ->
      res.send "エラー #{stderr}" if stderr.length > 0
      res.send "refresh complete #{stdout}" if stdout != null


  ###
  remote先の一覧を表示する
  ###
  robot.respond /repository remote list/i, (res) ->
    Exec "cd #{localRepositoryPath} && git remote -v | grep \"fetch\"", (error, stdout, stderr) ->
      res.send "エラー #{stderr}" if stderr.length > 0
      res.send stdout if stdout != null


  ###
  remote先を登録する
  ###
  robot.respond /repository remote add (.*) (.*)/i, (res) ->
    name = res.match[1]
    remotePath = res.match[2]

    if name == undefined or name == 'origin'
      res.send "無効な名前です #{name}"
      return

    Exec "cd #{localRepositoryPath} && git remote add #{name} #{remotePath} && git remote -v  | grep \"fetch\"", (error, stdout, stderr) ->
      res.send "エラー #{stderr}" if stderr.length > 0
      res.send stdout if stdout != null


  ###
  remote先を削除する
  ###
  robot.respond /repository remote rm (.*)/i, (res) ->
    name = res.match[1]

    if name == undefined or name == 'origin'
      res.send "無効な名前です #{name}"
      return

    Exec "cd #{localRepositoryPath} && git remote rm #{name} && git remote -v  | grep \"fetch\"", (error, stdout, stderr) ->
      res.send "エラー #{stderr}" if stderr.length > 0
      res.send stdout if stdout != null


###
internal
###
getRemotePath = ->
  LayConfig.get 'repository_remote_path'
