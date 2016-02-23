#
# robotとの対話式を実現するクラス
#
class RoboTalk
  constructor: (robot) ->
    @robot = robot
    @state = new TalkState
    @reaction = null
    @pattarn = null
    @message = null
    @timeout = null

  setup: ->
    parent = this
    call = (res) ->
      state = parent.state
      state.reset()
      state.next()

      res.send parent.message

      if @timeout != null
        setTimeout ->
          if state.value == 0
            res.send '操作はキャンセルされました'
            state.reset()
        , parent.timeout

    if @reaction == 'respond'
      @robot.respond @pattarn, (res) ->
        call(res)

    if @reaction == 'hear'
      @robot.hear @pattarn, (res) ->
        call(res)


  #
  # 対話状態の管理用
  #
  class TalkState
    constructor: ->
      @value = -1

    next: -> @value++
    reset: -> @value = -1


  #
  # 対話設定用
  #
  class @Talk
    constructor: (robot) ->
      @robot = robot
      @errorMessage = ''
      @actions = []

    setup: (index, robotalk) ->
      robot = @robot
      parent = this

      @actions.forEach (action) ->
        return if action.pattarn == null

        call = (res) ->
          if index != robotalk.state.value
            res.send parent.errorMessage
            return

          robotalk.state.next()
          res.send action.message
          action.call(res, robotalk)

          if action.timeout != null
            setTimeout ->
              if index == robotalk.state.value
                res.send '操作はキャンセルされました'
                robotalk.state.reset()
            , action.timeout

        if action.reaction == 'respond'
          robot.respond action.pattarn, (res) ->
            call(res)

        if action.reaction == 'hear'
          robot.hear action.pattarn, (res) ->
            call(res)


  #
  # 対話で取れる選択肢
  #
  class @TalkAction
    constructor: ->
      @reaction = 'respond'
      @pattarn = null
      @message = ''
      @call = null
      @timeout = null


  #
  # 対話シーケンスを構築する
  # 基本的にはこのクラスから対話式を構築する
  #
  class @Builder
    constructor: (robot) ->
      @robot = robot
      @pattarn = null
      @message = ''
      @reaction = 'respond'
      @timeout = null
      @talks = []

    build: ->
      robotalk = new RoboTalk(@robot)
      robotalk.pattarn = @pattarn
      robotalk.message = @message
      robotalk.reaction = @reaction
      robotalk.timeout = @timeout

      @talks.forEach (talk, i) ->
        talk.setup(i, robotalk)
      return robotalk

module.exports = RoboTalk
