# Renders a small, illustrative code change as a GitHub-style diff — used on
# the /demo case-study page's "Code" tab. Takes a flat spec of
# [:context|:add|:remove, "line content"] pairs and numbers lines
# sequentially — one column, not separate old/new counters — so a reader
# gets a single, unambiguous line reference instead of two numbering
# sequences that appear to restart and conflict with each other.
class DemoDiffFile
  Line = Struct.new(:type, :number, :content)

  attr_reader :filename, :lines

  def initialize(filename, spec)
    @filename = filename
    @lines = spec.each_with_index.map { |(type, content), index| Line.new(type, index + 1, content) }
  end

  def additions
    lines.count { |line| line.type == :add }
  end

  def removals
    lines.count { |line| line.type == :remove }
  end
end
