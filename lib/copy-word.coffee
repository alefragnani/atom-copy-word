module.exports =

  activate: (state) ->
    console.log "@activate"
    atom.workspaceView.command "copy-word:copy-word", => @copySelectedWord()
    atom.workspaceView.command "copy-word:cut-word", => @cutSelectedWord()

  selectWord: ->
    console.log "@selectWord"
    @prevPos = null
    @editor = atom.workspace.getActiveEditor()
    cursors = @editor.getCursors()
    if @hasNoSelection()
      @prevPos = ([cursor, cursor.getBufferPosition()] for cursor in cursors)
      @editor.selectWord()
      @editor.selections = @editor.getSelectionsOrderedByBufferPosition()
      return true;

  hasNoSelection: ->
    for selection in @editor.getSelections()
      return false unless selection.isEmpty()
    true

  copySelectedWord: ->
    console.log "@copySelectedWord"
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
    console.log "@cutSelectedWord"
    fullword = @selectWord()
    @editor.cutSelectedText()
    if fullword
      atom.clipboard.metadata = atom.clipboard.metadata || {}
      atom.clipboard.metadata.fullword = true
