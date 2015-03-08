$ = require 'jquery'
{CompositeDisposable, Emitter} = require 'event-kit'
PaneResizeHandleView = require './pane-resize-handle-view'

module.exports =

  activate: (state) ->
    @subscriptions = new CompositeDisposable
    atom.commands.add 'atom-workspace', "resize-panes:enlarge-active-pane", => @enlarge()
    atom.commands.add 'atom-workspace', "resize-panes:shrink-active-pane", => @shrink()

    @paneAxisSet = new WeakSet
    @subscriptions.add atom.workspace.observePanes @observePanes.bind(this)
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

  observePanes: (pane)->
    paneElement = atom.views.getView(pane)
    parent = paneElement.parentElement
    if parent?.nodeName is 'atom-pane-axis' and not @paneAxisSet.has(parent) and parent.children.length is 2
      @paneAxisSet.add(parent)
      console.log 'new parent'
      parent.insertBefore()

  deactivate: ->
    @subscriptions.dispose()

  serialize: ->
