#! coffeescript

# サルでもわかる jQuery ライヴコーディング
# [Yu Inao](http://twitter.com/japboy) in 2012

$ = jQuery

$ ->
  Window =
    width: 0
    height: 0
    update: ->
      @width = $(window).width()
      @height = $(window).height()
      $('#window').trigger('update')
    draw: ->
      $('#window').text("#{@width} x #{@height}")

  Mouse =
    cx: 0
    cy: 0
    px: 0
    py: 0
    move: 0
    center: 0
    update: (ev, win) ->
      center = win.width / 2
      @px = @cx
      @py = @cy
      @cx = ev.clientX
      @cy = ev.clientY
      @move = @cx - @px
      @center = @cx - center
      $('#mouse').trigger('draw')
      $('#filter').trigger('draw')
    draw: ->
      $('#mouse').text("(#{@cx}, #{@cy})")
      $('#move').text("#{@move}")
      $('#center').text("#{@center}")

  class Filter
    width: 0
    height: 0

    constructor: (@width, @height) ->
      @draw()

    update: (@width, @height) ->
      $('#filter').trigger('draw')

    draw: ->
      $('#filter').css
        backgroundImage: 'url(./img/dot.svg)'
        backgroundRepeat: 'repeat'
        width: "#{@width + 500}px"
        height: "#{@height}px"
        left: '-250px'
        position: 'absolute'
        top: '0'
        zIndex: '1000'
      @fadeOut()

    fadeOut: ->
      $('#filter').fadeOut(1000, @fadeIn)

    fadeIn: ->
      $('#filter').fadeIn(3000)

  class Ball
    width: 10
    height: 10
    types: [
      './img/gradient-ball-a.svg'
      './img/gradient-ball-b.svg'
      './img/gradient-ball-c.svg'
      './img/gradient-ball-d.svg'
    ]

    constructor: ->
      unit = Math.round(Math.random() * 125)
      @width = unit
      @height = unit

    destroy: ->
      mgr.pop(@)

    draw: (sy, dy, width) ->
      el = $(document.createElement('img'))
      el.attr
        src: @types[Math.round(Math.random() * 3)]
        width: @width
        height: @height
      .css
        position: 'absolute'
        top: "#{sy}px"
        left: '-125px'
      .animate
        left: "#{width + 250}px"
        top: "#{dy}px"
      ,
        duration: 6000 + width
        easing: 'easeInOutCirc'
        complete: ->
          $(@).fadeOut 'slow', ->
            $(@).remove()
      $('#playground').append(el)

  Window.update()

  fil = new Filter(Window.width, Window.height)

  setInterval ->
    rand = Math.ceil(Math.random() * 200) - Math.ceil(Math.random() * 200)
    sy = Mouse.py + rand
    dy = Mouse.cy + rand
    (new Ball()).draw(sy, dy, Window.width)
  , 300

  $('#mouse').on 'draw', (ev) ->
    Mouse.draw()

  $('#window').on 'update', (ev) ->
    Window.draw()
    fil.draw()

  $(window).on 'resize', (ev) ->
    Window.update()
    fil.update(Window.width, Window.height)

  $(document).on 'mousemove', (ev) ->
    Mouse.update(ev, Window)
    fil.draw()
