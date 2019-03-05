class ASTDistance
  class Forest
    def self.ast_to_forest(ast:)
      node_count, node_index_tbl = build_node_index_tbl(parent: ast)

      new(left: 0, right: node_count, node_index_tbl: node_index_tbl)
    end

    def self.build_node_index_tbl(parent:, order_number: 0, node_index_tbl: {})
      children_idx = parent.children.map do |child|
        next unless child.instance_of?(RubyVM::AbstractSyntaxTree::Node)

        order_number, node_index_tbl = build_node_index_tbl(
          parent: child,
          order_number: order_number,
          node_index_tbl: node_index_tbl
        )

        order_number - 1
      end.compact

      children_idx.each do |idx|
        node_index_tbl[idx].parent_index = order_number
      end

      node_index_tbl[order_number] = Node.new(
        index: order_number,
        type: parent.type,
      )

      [order_number + 1, node_index_tbl]
    end

    private_class_method :build_node_index_tbl

    attr_reader :left, :right, :node_index_tbl, :id

    def initialize(left:, right:, node_index_tbl: {})
      @left = left
      @right = right
      @node_index_tbl = node_index_tbl
      @id = "#{left}:#{right}"
    end

    def rightmost_forest
      v = root_index - 1

      while v > 0 && !node_index_tbl[v].root_node?
        v -= 1
      end

      Forest.new(left: v + 1, right: root_index, node_index_tbl: node_index_tbl)
    end

    def root_node
      node_index_tbl[root_index]
    end

    def node_count
      right - left
    end

    def root_index
      right - 1
    end

    def empty?
      left == right
    end
  end
end
