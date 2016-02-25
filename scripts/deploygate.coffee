###
DeployGate実行用
###

Exec = require('child_process').exec
Merge = require 'merge'

module.exports = (robot) ->
  localRepositoryPath = process.env.HUBOT_LAY_LOCAL_REPOSITORY_PATH

  ###
  help
  ###
  robot.respond /deploygate --help/i, (res) ->
    res.send '''
      `deployGate tasks` - 実行可能なDeployGateタスクを表示する
      `deployGate upload -remote <:remoteName> -banch <:branch> -flavor <:buildFlavor>` - DeployGateに指定したBuildFlavorでアップロードする\n特に指定がなければrepo=origin, branch=master, flavor=production
    '''


  ###
  実行可能なDeployGateタスクを表示する
  ###
  robot.respond /deploygate tasks/i, (res) ->
    res.send 'レディ'

    Exec "cd #{localRepositoryPath} && ./gradlew tasks | grep \"uploadDeployGate\"", (error, stdout, stderr) ->
      res.send "エラー #{error}" if error != null
      res.send stdout if stdout != null


  ###
  DeployGateにAPKをアップロードする
  ###
  robot.respond /deploygate upload (.*)/i, (res) ->
    options = {}
    res.match[1].split('-')
    .filter((option) ->
      option.split(' ')[0].length > 0
    ).map((option) ->
      obj = {}
      obj[option.split(' ')[0]] = option.split(' ')[1]
      obj
    ).forEach (option) ->
      Merge(options, option)

    remoteName = 'origin'
    branch = 'master'
    flavor = 'production'

    for key, value of options
      switch key
        when 'remote' then remoteName = value
        when 'branch' then branch = value
        when 'flavor' then flavor = value

    res.send "レディ #{remoteName} #{branch}のAPKをアップロードします"

    localBranch = "#{remoteName}-#{branch}"
    Exec "cd #{localRepositoryPath} && git checkout master && git fetch #{remoteName} #{branch}:#{localBranch} && git checkout #{localBranch} && ./gradlew uploadDeployGate#{flavor}", (error, stdout, stderr) ->
      res.send "エラー #{error}" if error != null
