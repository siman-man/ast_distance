class ASTDistance
  class Node
    attr_accessor :parent_index
    attr_reader :index, :type

    def initialize(index:, type:)
      @index = index
      @type = type
      @parent_index = nil
    end

    def root_node?
      parent_index.nil?
    end
  end
end
