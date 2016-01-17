require './rdparse'
require './classes'

class Praket

	def initialize
		@praketParser = Parser.new("prAKET") do
			token(/\s+/) #remove whitespaces
			token(/#.+/) #remove comments
			token(/\/\*(.*)\*\//m) #remove multi-line comments
			token(/\d+/) {|m| m.to_i}	
			token(/for/) {|m| m}
			token(/while/) {|m| m}
			token(/equals/) {|m| m}
			token(/is not/) {|m| m}
			token(/greater than/) {|m| m}
			token(/greater or equal to/) {|m| m}
			token(/lesser than/) {|m| m}
			token(/lesser or equal to/) {|m| m}
			token(/plus/) {|m| m}
			token(/minus/) {|m| m}
			token(/times/) {|m| m}
			token(/divided by/) {|m| m}
			token(/\w+/) {|m| m}
			token(/==/) {|m| m}
			token(/<=/) {|m| m}
			token(/>=/) {|m| m}
			token(/!=/) {|m| m}
			token(/</) {|m| m}
			token(/>/) {|m| m}
			#token(/>=|<=|==|!=|<|>/) {|m| m}
			token(/\"[^\"]*\"/) {|m| m}
			token(/./) {|m| m }
		
			
			start :program do 
				match(:statements) {|statements| Statements.new(statements).eval }
			end
			
			rule :statements do
				match(:statement,:statements) {|statement, statement_list |
				Statements.new(statement, statement_list)}
				
				match(:statement) {|m| Statements.new(m)}
			end
	  
			rule :declare_var do
				match(:type, :ident, :assign, :expression) {|type, ident, _, expression|
				Declare_var.new(type,ident,expression)}
			end
			
			rule :assign_var do
				match(:ident, :assign, :expression) {|ident, _, expression|
				Assign_var.new(ident, expression)}
				#match(:ident, "equal", :ident) {|ident, _, ident2|
				#Assign_var.new(ident,ident2)}
				#todo fix a = b assignment 
			end
			
			rule :assign do
				match("equal")
				match("=")
				match("is")
			
			end
			
			rule :type do
				match("string")
				match("integer")
				match("float")
				match("bool")
			end
						
			rule :statement do
				match(:declare_var) {|m| m}
				match(:assign_var) {|m| m}

				match(:while) {|m| m}
				match(:for) {|m| m}
				match(:else) {|m| m}
				match(:if) {|m| m}

				match(:expression) {|m| m}
				match(:write) {|m| m}

			end
			rule :while do
				match("while", :bool_expr, "{", :statements, "}") {|_,bool_expr,_,statements,_|
				While.new(bool_expr, statements)}
			end
			
			rule :for do
				match("for", :declare_var, ";", :bool_expr,";", :assign_var, "{", :statements, "}") {|_,var,_, bool_expr,_, assignment,_,block,_|
				For.new(var, bool_expr, assignment, block)}
			end
			
			rule :write do
				match("write", :expression) {|_,expression|
				Write.new(expression)}
				
			end
			rule :if do
				match("if", :bool_expr, "{", :statements, "}") {|_,bool_expr,_,statements,_|
				If.new(bool_expr,statements)}
				#match(:elseif)
				#match(:else)
			end
			
			rule :else do
				match(:if, "else", "{", :statements, "}") {|if_statement,_,_,block,_|
				Else.new(if_statement,block)}
			end
			
			rule :ident do
				match(/\b([a-zA-Z0-9]+)\b(?<!if|else|while|write|for|greater than|equals)/) {|m| m}
			end
			
			rule :expression do
				match(:bool_expr)
				match(:aritm_expr)
			end
			
			rule :aritm_expr do
				match(:aritm_expr, :aritm_operand, :multi_expr) {|t1, o, t2|
					Aritm_expr.new(t1,o,t2)}
				match(:multi_expr)
			end
			
			rule :aritm_operand do
				match('+')
				match('-')
				match('plus')
				match('minus')
			end
			
			rule :multi_expr do
				match(:multi_expr, :multi_operand, :multi_expr) {|p1, o, p2|
					Multi_expr.new(p1, o, p2)}
				match(:atom)		
			end
			
			rule :atom do
				match(Float) {|val| Atom.new(val.to_f)}
				match("-",Float) {|_,val| Atom.new(val.to_f*-1)}
				match(Integer) {|val| Atom.new(val.to_i)}
				match("-", Integer) {|_,val| Atom.new(val.to_i*-1)}

				match(/\"[^\"]*\"/) {|val| Atom.new(val[1..-2])}
				match(:bool) {|val| Atom.new(val)} 
				match(:ident) {|m| Var.new(m)}
			end
			
			rule :bool do
				match("true")
				match("false")
			end
			
			rule :multi_operand do
				match('*')
				match('/')
				match('times')
				match('divided by')
			end

			rule :bool_expr do
				match(:logic_expr)
				match(:rel_expr)
				

			end
			
			rule :logic_expr do
				match(:rel_expr, :logic_operand, :rel_expr) {|expr1, operand, expr2|
				Logic_expr.new(expr1, operand, expr2)}
			end
			
			rule :logic_operand do			
				match("and")
				match("or")
			end
			
			rule :rel_expr do
				match(:aritm_expr, :rel_operand, :aritm_expr) {|expr1, operand, expr2|
				Rel_expr.new(expr1,operand,expr2)}
			end
			
			rule :rel_operand do
				match(">=")
				match("<=")
				match(">")
				match("<")
				match("==")				
				match("!=")
				match("equals")
				match("is not")
				match("greater than")
				match("greater or equal to")
				match("lesser than")
				match("lesser or equal to")
			end

		end
		def done(str)
			["quit","exit","bye",""].include?(str.chomp)
		end
		
		def run(file)
			@praketParser.parse(file)
		end
		def run_inter()
			print "[sPRAKET] "
			str = gets
			if done(str) then
				puts "Bye."
			else
				puts "=> #{@praketParser.parse str}"
				#result = @praketParser.parse(str)
				#puts result
				run_inter
			end
		end
	end
end

if ARGV.length == 1
	file = File.open(ARGV[0]).read
	Praket.new.run(file)
else
	Praket.new.run_inter
end

