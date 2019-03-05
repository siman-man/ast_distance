require 'ast_distance/version'
require 'ast_distance/node'
require 'ast_distance/forest'

class ASTDistance
  attr_reader :left_ast, :right_ast

  def self.tree_edit_distance(ast1, ast2)
    new(ast1, ast2).tree_edit_distance
  end

  def initialize(ast1, ast2)
    @left_ast = ast1
    @right_ast = ast2

    @f1 = Forest.ast_to_forest(ast: ast1)
    @f2 = Forest.ast_to_forest(ast: ast2)
  end

  def tree_edit_distance
    pre_proc
    forest_dist(@f1, @f2)
  end

  def forest_dist(f1, f2)
    return @memo[f1.id][f2.id] if @memo[f1.id][f2.id]

    return f2.node_count if f1.empty?
    return f1.node_count if f2.empty?

    f1_rmf = f1.rightmost_forest
    f2_rmf = f2.rightmost_forest

    a = forest_dist(
      Forest.new(
        left: f1_rmf.left,
        right: f1_rmf.right,
        node_index_tbl: f1.node_index_tbl
      ),
      Forest.new(
        left: f2_rmf.left,
        right: f2_rmf.right,
        node_index_tbl: f2_rmf.node_index_tbl
      )
    )

    b = forest_dist(
      Forest.new(
        left: f1.left,
        right: f1_rmf.left,
        node_index_tbl: f1.node_index_tbl
      ),
      Forest.new(
        left: f2.left,
        right: f2_rmf.left,
        node_index_tbl: f2.node_index_tbl
      )
    )

    c = f1.root_node.type == f2.root_node.type ? 0 : 1

    d1 = a + b + c

    d2 = forest_dist(
      f1,
      Forest.new(
        left: f2.left,
        right: f2_rmf.right,
        node_index_tbl: f2.node_index_tbl
      )
    ) + 1

    d3 = forest_dist(
      Forest.new(
        left: f1.left,
        right: f1_rmf.right,
        node_index_tbl: f1.node_index_tbl
      ),
      f2
    ) + 1

    @memo[f1.id][f2.id] = [d1, d2, d3].min
  end

  private

  def pre_proc
    @memo = Hash.new { |hash, key| hash[key] = {} }
  end
end
