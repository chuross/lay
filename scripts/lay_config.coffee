#
# json管理のコンフィグファイルを管理する
#
Fs = require 'fs'
Path = require 'path'
Merge = require 'merge'

class LayConfig
  path = Path.resolve __dirname, '../lay-config.json'

  #
  # 設定ファイルの読み込み
  #
  @getAll = ->
    try
      @reset() if !Fs.existsSync(path)
      data = Fs.readFileSync(path, 'utf-8')
      if data.length == 0
        console.log 'data is empty'
        return
      JSON.parse data
    catch e
      console.log e
      null

  #
  # 設定ファイルの書き込み
  #
  @put = (key, value) ->
    try
      config = @getAll()

      diff = {}
      diff[key] = value

      Fs.writeFileSync(path, JSON.stringify(Merge(config, diff)))
      true
    catch e
      console.log e
      false

  #
  # 設定ファイルの初期化
  #
  @reset = ->
    Fs.writeFileSync(path, Fs.readFileSync(path + '.template'))

module.exports = LayConfig