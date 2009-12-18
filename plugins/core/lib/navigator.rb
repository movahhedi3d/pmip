class Navigator
  def initialize(context)
    @context = context
  end

  def open(element)
    element.navigate(true)
    self
  end

  def move_to(line, column)
    editor = context.editor()
    #TODO: restore notNull
    #position = LogicalPosition.new(notNull(line, "line"), notNull(column, "column"))
    position = LogicalPosition.new(line, column)
    editor.getCaretModel.moveToLogicalPosition(position)
    editor.getScrollingModel.disableAnimation
    editor.getScrollingModel.scrollTo(position, ScrollType.CENTER)
    editor.getScrollingModel.enableAnimation
  end
end