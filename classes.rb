$variables = {}

class Statements
	def initialize(statement, statement_list=nil)
		@statement = statement
		@statement_list = statement_list
	end
	
	def eval()
		if(@statement_list)
			@statement.eval
			@statement_list.eval
		else
			@statement.eval
		end
	end
end

class Aritm_expr
	attr_accessor :term1, :term2, :operand
	def initialize(t1, o, t2)
		@term1 = t1
		@term2 = t2
		@operand = o
	end
	
	def eval()
		if @operand == "+" or @operand == "plus"
			return @term1.eval + @term2.eval
		else
			return @term1.eval - @term2.eval
		end
	end
end

class Multi_expr
	attr_accessor :product1, :product2, :operand
	def initialize(p1, o, p2)
		@product1 = p1
		@product2 = p2
		@operand = o
	end
	
	def eval()
		if @operand == "*" or @operand == "times"
			return @product1.eval * @product2.eval
		else
			return @product1.eval / @product2.eval
		end
	end
end

class Atom
	attr_accessor :value
	def initialize(val)
		@value = val
	end
	def eval()
		return @value
	end
end

class Rel_expr
	def initialize(expr1, operand, expr2)
		@expression1 = expr1
		@expression2 = expr2
		@operand = operand
	end
	def eval()
		case @operand
		when "<", "lesser than"
			return @expression1.eval < @expression2.eval
		when ">", "greater than"
			return @expression1.eval > @expression2.eval
		when "!=", "is not"
			return @expression1.eval != @expression2.eval
		when ">=", "greater or equal to"
			return @expression1.eval >= @expression2.eval
		when "<=", "lesser or equal to"
			return @expression1.eval <= @expression2.eval
		when "==", "equals"
			return @expression1.eval == @expression2.eval
		else nil
		end
	end
end

class Logic_expr
	def initialize(expr1, operand, expr2)
		@expr1 = expr1
		@operand = operand
		@expr2 = expr2
	end
	def eval()
		if @operand == "and"
			if @expr1.eval and @expr2.eval
				return true
			else
				return false
			end
		else
			if @expr1.eval or @expr2.eval
				return true
			else
				return false
			end
		end
	end
end
		

class Declare_var
	attr_accessor :value
	def initialize(type,ident,expression)
		@type = type
		@ident = ident
		@expression = expression
	end
	def eval()
		if $variables[@ident] != nil
			puts "Variable already exists"
		else
			$variables[@ident] = @expression.eval
		end
	end
end

class Assign_var
	def initialize(ident, expression)
		@ident = ident
		@expression = expression
	end
	
	def lookup(ident)
		if $variables[@ident] == nil
			return false
		else
			return true
		end
	end
	
	def eval()
		$variables[@ident] = @expression.eval	
	end
end

class If
	def initialize(if_statement, block)
		@if_statement = if_statement
		@block = block
	end
	def eval()
		if (@if_statement.eval)
			@block.eval()
			return true
		else
			return false
		end
	end
end

class Else
	def initialize(if_statement, block)
		@if_statement = if_statement
		@block = block
	end
	def eval()
		#result = @if_statement.eval
		if(@if_statement.eval)
			return true
		else
			return @block.eval
		end
	end
end

class Write
	def initialize(expression)
		@expression = expression
	end
	def eval()
		puts @expression.eval
	end
end
	
class While
	def initialize(bool_expr, statements)
		@bool_expr = bool_expr
		@statements = statements
	end
	
	def eval()
		while @bool_expr.eval do
			@statements.eval
		end
	end
end

class For
	def initialize(var, bool_expr, counter, statements)
		@var = var
		@bool_expr = bool_expr
		@counter = counter
		@statements = statements
	end
	def eval()
		@var.eval
		while @bool_expr.eval
			@statements.eval
			@counter.eval
		end
	end
end
		

class Var
	def initialize(name)
		@name = name
	end
	def eval()
		if $variables[@name] == nil
			puts "Variable doesn't exist"
		else
			return $variables[@name]
		end
	end
end