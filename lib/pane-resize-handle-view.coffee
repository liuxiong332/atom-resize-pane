
{$, View} = require 'atom-space-pen-views'

module.exports =
class PaneResizeHandleView extends View
  @content: ->
    @div class: 'pane-resize-handle'

  initialize: (state) ->
    @handleEvents()

  attached: ->
    @isHorizontal = @parent().hasClass("horizontal")
    @prevPane = @prev('atom-pane')
    @nextPane = @next('atom-pane')

  detached: ->

  handleEvents: ->
    @on 'dblclick', '.pane-resize-handle', =>
      @resizeToFitContent()
    @on 'mousedown', '.pane-resize-handle', (e) =>
      @resizeStarted(e)

  resizeToFitContent: ->
    # clear flex-grow css style of both pane
    @prevPane.css('flexGrow', '')
    @next.css('flexGrow', '')

  resizeStarted: ->
    e.stopPropagation()
    $(document).on('mousemove', @resizePane)
    $(document).on('mouseup', @resizeStopped)

  calcRatio: (ratio1, ratio2, total) ->
    allRatio = ratio1 + ratio2
    [total * ratio1 / allRatio, total * ratio2 / allRatio]

  getFlexGrow: (element) ->
    parseFloat element.css('flexGrow')

  setFlexGrow: (prevSize, nextSize) ->
    flexGrow = @getFlexGrow(@prevPane) + @getFlexGrow(@nextPane)
    flexGrows = @calcRatio(prevSize, nextSize, flexGrow)
    @prevPane.css('flexGrow', flexGrows[0].toString())
    @nextPane.css('flexGrow', flexGrows[1].toString())

  resizePane: ({pageX, pageY, which}) =>
    return @resizeStopped() unless which is 1

    if @isHorizontal
      totalWidth = @prevPane.outerWidth() + @nextPane.outerWidth()
      leftWidth = pageX - @prevPane.offset().left
      rightWidth = totalWidth - leftWidth
      @setFlexGrow(leftWidth, rightWidth)
    else
      totalHeight = @prevPane.outerHeight() + @nextPane.outerHeight()
      topHeight = pageY - @prevPane.offset().top
      bottomHeight = totalHeight - topHeight
      @setFlexGrow(topHeight, bottomHeight)

  resizeStopped: =>
    $(document).off('mousemove', @resizePane)
    $(document).off('mouseup', @resizeStopped)
