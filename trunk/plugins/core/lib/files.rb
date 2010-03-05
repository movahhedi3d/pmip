import org.apache.tools.ant.DirectoryScanner

class Files
  def initialize(context)
    @context = context
    @includes = []
    @excludes = []
  end

  def include(pattern)
    @includes << pattern
    self
  end

  def exclude(pattern)
    @excludes << pattern
    self
  end

#TODO: find a way to speed this up
  def find
    scanner = DirectoryScanner.new
    scanner.setBasedir(@context.root)
    scanner.setCaseSensitive(false)
    scanner.setIncludes(@includes.to_java :String) unless @includes.empty?
    scanner.setExcludes(@excludes.to_java :String) unless @excludes.empty?
    scanner.scan
    scanner.included_files.collect{|f| @context.filepath_from_root(f) }
  end

  def to_s
    "\nFiles: [includes: #{@includes}, excludes: #{@excludes}]"
  end
end
