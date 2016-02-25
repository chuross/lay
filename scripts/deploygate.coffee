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
      `deploygate tasks` - 実行可能なDeployGateタスクを表示する
      `deploygate upload -remote <:remoteName> -banch <:branch> -flavor <:buildFlavor>` - DeployGateに指定したBuildFlavorでアップロードする\n特に指定がなければrepo=origin, branch=master, flavor=debug
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
    res.match[1].split(' -')
    .filter((option) ->
      option.split(' ')[0].length > 0
    ).map((option) ->
      obj = {}
      key = if option.split(' ')[0].startsWith('-') then option.split(' ')[0].substring 1 else option.split(' ')[0]
      val = option.split(' ')[1]
      obj[key] = val
      obj
    ).forEach (option) ->
      Merge(options, option)

    remoteName = 'origin'
    branch = 'master'
    flavor = 'debug'
    for key, value of options
      switch key
        when 'remote' then remoteName = value
        when 'branch' then branch = value
        when 'flavor' then flavor = value

    res.send "レディ #{remoteName} #{branch}のAPKをアップロードします"

    command = if branch.startsWith 'refs/tags' then getUploadTagApkCommand(branch) else getUploadBranchApkCommand(remoteName,
      branch)

    Exec "cd #{localRepositoryPath} && git checkout master && #{command} && ./gradlew uploadDeployGate#{flavor}", (error, stdout, stderr) ->
      res.send "エラー #{error}" if error != null

###
internal
###
getUploadBranchApkCommand = (remoteName, branch) ->
  localBranch = "#{remoteName}-#{branch}"
  "git fetch #{remoteName} #{branch}:#{localBranch} && git checkout #{localBranch}"


getUploadTagApkCommand = (tag) ->
  "git fetch origin #{tag} && git checkout #{tag}"
