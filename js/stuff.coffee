class WhacAMu

  constructor: ( timeLimit ) ->
    @score = 0
    @timeLimit = @timeRemain = timeLimit
    @scorePanel = $("#score")
    @timerPanel = $("#timer")
    @field = $("section.holes")
    @createHoles()
    @createHammer()
    @bindControls()
    @pauseGame()
    @val = 0
    @timerPanel.html( timeLimit )

  timingDownFrom: ( secs ) ->
    self = @
    @countDown = setInterval () ->
      self.timeRemain = self.timeRemain  - 1
      self.timerPanel.html( self.timeRemain )
      self.timeOut() if self.timeRemain == 0
    , 850

  timeOut: () ->
    self = @
    @pauseGame()
    @timeRemain = @timeLimit
    _gaq.push ["_trackEvent", "Game played", "Got" + self.score + " points"]
    clearInterval @countDown

  bindControls: () ->
    self = @
    $("#startGame").click () -> self.startGame()
    $("#pauseGame").click () -> self.pauseGame()
    $("#reset").click () -> self.reset()

  changeButtonState: ( btn ) ->
    $(".btn").removeClass("disabled")
    $( btn ).addClass("disabled")

  startGame: ( ) ->
    self = @
    @updateScore ( (0 - @score) ) if @timeRemain == @timeLimit
    @gameStarted = true
    @muuuu()
    @randomMu = setInterval () ->
      self.muuuu( {noTrigger: true} )
    , 5000
    @changeButtonState( "#startGame" )
    @timerPanel.html( self.timeRemain )
    @timingDownFrom( @timeRemain )

  createHoles: () ->
    i = 0
    while i < 16
      i++
      @field.append("<div class=\"hole\"></div>")

  getRandom: ( last_muuu ) ->
    val = _.random(0, $(".hole").length - 1 )
    while val == last_muuu
      val = _.random(0, $(".hole").length - 1 )
    val

  muuuu: ( options ) ->
    self = @
    if @gameStarted
      @val = @getRandom( @val )
      mu = $(".hole").eq(self.val).addClass("out")
      @bindWhack( mu, options )

  createHammer: () ->
    self = @
    $(window).bind "mousemove", ( e ) ->
      inField = e.pageY > self.field.position().top && e.pageX > self.field.position().left && e.pageY < (self.field.position().top + self.field.height()) &&  e.pageX < (self.field.position().left + self.field.width())
      if inField
        $("#hammer").css( "top": e.pageY, "left": e.pageX )

    $(window).bind "click", ( e ) ->
      inField = e.pageY > self.field.position().top && e.pageX > self.field.position().left && e.pageY < (self.field.position().top + self.field.height()) &&  e.pageX < (self.field.position().left + self.field.width())
      if inField
        $("#hammer").addClass("smash").find("img").attr("src", "img/hammering.png")
        setTimeout () ->
          $("#hammer").removeClass("smash").find("img").attr("src", "img/hammer.png")
        , 200

  bindWhack: ( mu, options ) ->
    self = @
    options = $.extend {}, options
    newtime = setTimeout () ->
      self.updateScore(-10) if mu.is(".out")
      mu.removeClass("out").unbind "click"
      self.muuuu() unless options.noTrigger
    , 2000
    
    mu.bind "click", () ->
      mu.removeClass("out").unbind "click"
      self.muuuu() unless options.noTrigger
      self.updateScore(+10)
      clearTimeout newtime
  
  updateScore: ( score ) ->
    @score = @score + score
    @scorePanel.html( @score )

  pauseGame: ( ) ->
    self = @
    $(".hole").removeClass("out")
    clearInterval( self.randomMu )
    @gameStarted = false
    @changeButtonState( "#pauseGame" )
    clearInterval @countDown

  reset: ( ) ->
    self = @
    @updateScore( (0 - @score) )
    @timerPanel.html( self.timeRemain = self.timeLimit )
    @pauseGame()
    @changeButtonState( "#reset" )

jQuery -> 
  new WhacAMu 60

  $.each $("a[id]"), (index, ele) ->
    $(ele).click (e) ->
      e.stopImmediatePropagation()
      _gaq.push ["_trackEvent", "Game", e.target.id, "actions"]
  $.each $("a:not([id])"), (index, ele) ->
    $(ele).click (e) ->
      e.stopImmediatePropagation()
      _gaq.push ["_trackEvent", "Click links", e.currentTarget.href, "links"]

