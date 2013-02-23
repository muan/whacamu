class WhacAMu

  constructor: () ->
    @score = 0
    @scorePanel = $("#score")
    @createHoles()
    @createHammer()
    self = @
    setInterval () ->
      self.comingOut( {noTrigger: true} )
    , 5000
    @comingOut()

  createHoles: () ->
    i = 0
    while i < 16
      i++
      $("section.holes").append("<div class=\"hole\"></div>")

  comingOut: ( options ) ->
    val = _.random(0, $(".hole").length - 1 )
    mu = $(".hole").eq(val).addClass("hello")
    @bindWhack( mu, options )

  createHammer: () ->
    $(window).bind "mousemove", ( e ) ->
      $("#hammer").css( "top": e.pageY, "left": e.pageX )
    $(window).bind "click", ( e ) ->
      $("#hammer").addClass("smash")
      setTimeout () ->
        $("#hammer").removeClass("smash")
      , 200

  bindWhack: ( mu, options ) ->
    self = @
    options = $.extend {}, options
    newtime = setTimeout () ->
      mu.removeClass("hello").unbind "click"
      self.comingOut() unless options.noTrigger
      self.updateScore(-10)
    , 2000
    
    mu.bind "click", () ->
      mu.removeClass("hello").unbind "click"
      self.comingOut() unless options.noTrigger
      self.updateScore(+10)
      clearTimeout newtime
  
  updateScore: ( score ) ->
    @score = @score + score
    @scorePanel.html( @score )


jQuery -> 
  new WhacAMu