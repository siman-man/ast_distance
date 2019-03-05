RSpec.describe ASTDistance, :aggregate_failures do
  describe '.tree_edit_distance' do
    it 'test case 01' do
      code1 = <<~'CODE'
        puts 2 + 2
      CODE

      code2 = <<~'CODE'
        puts 2 + 2
      CODE

      ast1 = RubyVM::AbstractSyntaxTree.parse(code1)
      ast2 = RubyVM::AbstractSyntaxTree.parse(code2)

      expect(ASTDistance.tree_edit_distance(ast1, ast2)).to eq(0)
    end

    it 'test case 02' do
      code1 = <<~'CODE'
        puts 'Hello World'
      CODE

      code2 = <<~'CODE'
        puts 'Hello World'
        puts 'Hello World'
      CODE

      ast1 = RubyVM::AbstractSyntaxTree.parse(code1)
      ast2 = RubyVM::AbstractSyntaxTree.parse(code2)

      expect(ASTDistance.tree_edit_distance(ast1, ast2)).to eq(4)
    end

    it 'test case 03' do
      code1 = <<~'CODE'
        def add(a, b)
          a + b
        end
      CODE

      code2 = <<~'CODE'
        def sub(a, b)
          a - b
        end
      CODE

      ast1 = RubyVM::AbstractSyntaxTree.parse(code1)
      ast2 = RubyVM::AbstractSyntaxTree.parse(code2)

      expect(ASTDistance.tree_edit_distance(ast1, ast2)).to eq(0)
    end

    it 'test case 04' do
      code1 = <<~'CODE'
        class Foo
          attr_reader :bar

          def initialize
            @bar = 'bar'
          end
        end
      CODE

      code2 = <<~'CODE'
        class Bar
        end
      CODE

      ast1 = RubyVM::AbstractSyntaxTree.parse(code1)
      ast2 = RubyVM::AbstractSyntaxTree.parse(code2)

      expect(ASTDistance.tree_edit_distance(ast1, ast2)).to eq(9)
    end

    it 'test case 05' do
      code1 = <<~'CODE'
        100
      CODE

      code2 = <<~'CODE'
        200
      CODE

      ast1 = RubyVM::AbstractSyntaxTree.parse(code1)
      ast2 = RubyVM::AbstractSyntaxTree.parse(code2)

      expect(ASTDistance.tree_edit_distance(ast1, ast2)).to eq(0)
    end

    it 'test case 06' do
      code1 = <<~'CODE'
        fizz.buzz.fizz.buzz.fizzbuzz
      CODE

      code2 = <<~'CODE'
        fizz.buzz
      CODE

      ast1 = RubyVM::AbstractSyntaxTree.parse(code1)
      ast2 = RubyVM::AbstractSyntaxTree.parse(code2)

      expect(ASTDistance.tree_edit_distance(ast1, ast2)).to eq(3)
    end
  end
end
