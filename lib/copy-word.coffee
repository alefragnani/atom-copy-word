{CompositeDisposable} = require 'atom'

module.exports = CopyWord =
  subscriptions: null

  activate: (state) ->
    @subscriptions = new CompositeDisposable

    @subscriptions.add atom.commands.add 'atom-workspace', 'copy-word:copy-word': => @copySelectedWord()
    @subscriptions.add atom.commands.add 'atom-workspace', 'copy-word:cut-word': => @cutSelectedWord()

  deactivate: ->
    @subscriptions.dispose()



  selectWord: ->
    # console.log "@selectWord"
    @prevPos = null
    @editor = atom.workspace.getActiveTextEditor()
    cursors = @editor.getCursors()
    if @hasNoSelection()
      @prevPos = ([cursor, cursor.getBufferPosition()] for cursor in cursors)

      # atom.workspace.getActiveTextEditor().selections[0].selectWord()
      @editor.selections[0].selectWord()

      @editor.selections = @editor.getSelectionsOrderedByBufferPosition()
      return true

  hasNoSelection: ->
    for selection in @editor.getSelections()
      return false unless selection.isEmpty()
    true

  copySelectedWord: ->
    # console.log "@copySelectedWord"
    fullword = @selectWord()
    @editor.copySelectedText()
    if fullword
      atom.clipboard.metadata = atom.clipboard.metadata || {}
      atom.clipboard.metadata.fullword = true
    if @prevPos
      for cursor in @prevPos
        cursor[0].clearSelection()
        cursor[0].setBufferPosition(cursor[1])

  cutSelectedWord: ->
    # console.log "@cutSelectedWord"
    fullword = @selectWord()
    @editor.cutSelectedText()
    if fullword
      atom.clipboard.metadata = atom.clipboard.metadata || {}
      atom.clipboard.metadata.fullword = true
