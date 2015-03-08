$ = require 'jquery'

module.exports =

  activate: (state) ->
    atom.commands.add 'atom-workspace', "resize-panes:enlarge-active-pane", => @enlarge()
    atom.commands.add 'atom-workspace', "resize-panes:shrink-active-pane", => @shrink()

  enlarge: ->
    flexGrow = @getFlex()
    flexGrow *= 1.1
    @setFlex flexGrow

  shrink: ->
    flexGrow = @getFlex()
    flexGrow /= 1.1
    @setFlex flexGrow

  getFlex: ->
    parseFloat $('.pane.active').css('flexGrow')

  setFlex: (grow) ->
    $('.pane.active').css('flexGrow', grow.toString())

  deactivate: ->

  serialize: ->
