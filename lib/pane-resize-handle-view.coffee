
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
    @prevPane.css('flexGrow', 1)
    @prevPane.css('flexGrow', 1)

  resizeStarted: ->
    e.stopPropagation()
    $(document).on('mousemove', @resizePane)
    $(document).on('mouseup', @resizeStopped)

  calcRatio: (ratio1, ratio2, total) ->
    allRatio = ratio1 + ratio2
    [total * ratio1 / allRatio, total * ratio2 / allRatio ]

  resizePane: ({pageX, pageY, which}) ->
    return @resizeStopped() unless which is 1

    flexGrow = @prevPane.css('flexGrow') + @nextPane.css('flexGrow')

    if @isHorizontal
      totalWidth = @prevPane.outerWidth() + @nextPane.outerWidth()
      leftWidth = pageX - @prevPane.offset().left
      rightWidth = totalWidth - leftWidth
      flexGrows = @calcRatio(leftWidth, rightWidth, flexGrow)
      @prevPane.css('flexGrow', flexGrows[0])
      @nextPane.css('flexGrow', flexGrows[1])
    else
      totalHeight = @prevPane.outerHeight() + @nextPane.outerHeight()
      topHeight = pageY - @prevPane.offset().top
      bottomHeight = totalHeight - topHeight
      flexGrows = @calcRatio(topHeight, bottomHeight, flexGrow)
      @prevPane.css('flexGrow', flexGrows[0])
      @nextPane.css('flexGrow', flexGrows[1])

  resizeStopped: ->
    $(document).off('mousemove', @resizePane)
    $(document).off('mouseup', @resizeStopped)
