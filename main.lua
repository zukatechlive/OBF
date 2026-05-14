local _ZukOfficial = { cache = {} }
do
	do
		local function __modImpl()
			local NAME = "ZukaTech"
			local REVISION = "V2"
			local VERSION = "v2.0"
			for _, currArg in pairs(arg or {}) do
				if currArg == "--CI" then
					local releaseName = string.gsub(string.format("%s %s %s", NAME, REVISION, VERSION), "%s", "-")
					print(releaseName)
				end
				if currArg == "--FullVersion" then
					print(VERSION)
				end
			end
			return {
				Name = NAME,
				NameUpper = string.upper(NAME),
				NameAndVersion = string.format("%s %s", NAME, VERSION),
				Version = VERSION,
				Revision = REVISION,
				IdentPrefix = "__ZukV2_",
				SPACE = " ",
				TAB = "\t",
			}
		end
		function _ZukOfficial.a()
			local v = _ZukOfficial.cache.a
			if not v then
				v = { c = __modImpl() }
				_ZukOfficial.cache.a = v
			end
			return v.c
		end
	end
	do
		local function __modImpl()
			local Ast = {}
			local AstKind = {
				TopNode = "TopNode",
				Block = "Block",
				ContinueStatement = "ContinueStatement",
				BreakStatement = "BreakStatement",
				DoStatement = "DoStatement",
				WhileStatement = "WhileStatement",
				ReturnStatement = "ReturnStatement",
				RepeatStatement = "RepeatStatement",
				ForInStatement = "ForInStatement",
				ForStatement = "ForStatement",
				IfStatement = "IfStatement",
				FunctionDeclaration = "FunctionDeclaration",
				LocalFunctionDeclaration = "LocalFunctionDeclaration",
				LocalVariableDeclaration = "LocalVariableDeclaration",
				FunctionCallStatement = "FunctionCallStatement",
				PassSelfFunctionCallStatement = "PassSelfFunctionCallStatement",
				AssignmentStatement = "AssignmentStatement",
				CompoundAddStatement = "CompoundAddStatement",
				CompoundSubStatement = "CompoundSubStatement",
				CompoundMulStatement = "CompoundMulStatement",
				CompoundDivStatement = "CompoundDivStatement",
				CompoundModStatement = "CompoundModStatement",
				CompoundPowStatement = "CompoundPowStatement",
				CompoundConcatStatement = "CompoundConcatStatement",
				AssignmentIndexing = "AssignmentIndexing",
				AssignmentVariable = "AssignmentVariable",
				BooleanExpression = "BooleanExpression",
				NumberExpression = "NumberExpression",
				StringExpression = "StringExpression",
				NilExpression = "NilExpression",
				VarargExpression = "VarargExpression",
				OrExpression = "OrExpression",
				AndExpression = "AndExpression",
				LessThanExpression = "LessThanExpression",
				GreaterThanExpression = "GreaterThanExpression",
				LessThanOrEqualsExpression = "LessThanOrEqualsExpression",
				GreaterThanOrEqualsExpression = "GreaterThanOrEqualsExpression",
				NotEqualsExpression = "NotEqualsExpression",
				EqualsExpression = "EqualsExpression",
				StrCatExpression = "StrCatExpression",
				AddExpression = "AddExpression",
				SubExpression = "SubExpression",
				MulExpression = "MulExpression",
				DivExpression = "DivExpression",
				ModExpression = "ModExpression",
				NotExpression = "NotExpression",
				LenExpression = "LenExpression",
				NegateExpression = "NegateExpression",
				PowExpression = "PowExpression",
				IndexExpression = "IndexExpression",
				FunctionCallExpression = "FunctionCallExpression",
				PassSelfFunctionCallExpression = "PassSelfFunctionCallExpression",
				VariableExpression = "VariableExpression",
				FunctionLiteralExpression = "FunctionLiteralExpression",
				TableConstructorExpression = "TableConstructorExpression",
				TableEntry = "TableEntry",
				KeyedTableEntry = "KeyedTableEntry",
				NopStatement = "NopStatement",
				IfElseExpression = "IfElseExpression",
			}
			local astKindExpressionLookup = {
				[AstKind.BooleanExpression] = 0,
				[AstKind.NumberExpression] = 0,
				[AstKind.StringExpression] = 0,
				[AstKind.NilExpression] = 0,
				[AstKind.VarargExpression] = 0,
				[AstKind.OrExpression] = 12,
				[AstKind.AndExpression] = 11,
				[AstKind.LessThanExpression] = 10,
				[AstKind.GreaterThanExpression] = 10,
				[AstKind.LessThanOrEqualsExpression] = 10,
				[AstKind.GreaterThanOrEqualsExpression] = 10,
				[AstKind.NotEqualsExpression] = 10,
				[AstKind.EqualsExpression] = 10,
				[AstKind.StrCatExpression] = 9,
				[AstKind.AddExpression] = 8,
				[AstKind.SubExpression] = 8,
				[AstKind.MulExpression] = 7,
				[AstKind.DivExpression] = 7,
				[AstKind.ModExpression] = 7,
				[AstKind.NotExpression] = 5,
				[AstKind.LenExpression] = 5,
				[AstKind.NegateExpression] = 5,
				[AstKind.PowExpression] = 4,
				[AstKind.IndexExpression] = 1,
				[AstKind.AssignmentIndexing] = 1,
				[AstKind.FunctionCallExpression] = 2,
				[AstKind.PassSelfFunctionCallExpression] = 2,
				[AstKind.VariableExpression] = 0,
				[AstKind.AssignmentVariable] = 0,
				[AstKind.FunctionLiteralExpression] = 3,
				[AstKind.TableConstructorExpression] = 3,
			}
			Ast.AstKind = AstKind
			function Ast.astKindExpressionToNumber(kind)
				return astKindExpressionLookup[kind] or 100
			end
			function Ast.ConstantNode(val)
				if type(val) == "nil" then
					return Ast.NilExpression()
				end
				if type(val) == "string" then
					return Ast.StringExpression(val)
				end
				if type(val) == "number" then
					return Ast.NumberExpression(val)
				end
				if type(val) == "boolean" then
					return Ast.BooleanExpression(val)
				end
			end
			function Ast.NopStatement()
				return {
					kind = AstKind.NopStatement,
				}
			end
			function Ast.IfElseExpression(condition, true_value, false_value)
				return {
					kind = AstKind.IfElseExpression,
					condition = condition,
					true_value = true_value,
					false_value = false_value,
				}
			end
			function Ast.TopNode(body, globalScope)
				return {
					kind = AstKind.TopNode,
					body = body,
					globalScope = globalScope,
				}
			end
			function Ast.TableEntry(value)
				return {
					kind = AstKind.TableEntry,
					value = value,
				}
			end
			function Ast.KeyedTableEntry(key, value)
				return {
					kind = AstKind.KeyedTableEntry,
					key = key,
					value = value,
				}
			end
			function Ast.TableConstructorExpression(entries)
				return {
					kind = AstKind.TableConstructorExpression,
					entries = entries,
				}
			end
			function Ast.Block(statements, scope)
				return {
					kind = AstKind.Block,
					statements = statements,
					scope = scope,
				}
			end
			function Ast.BreakStatement(loop, scope)
				return {
					kind = AstKind.BreakStatement,
					loop = loop,
					scope = scope,
				}
			end
			function Ast.ContinueStatement(loop, scope)
				return {
					kind = AstKind.ContinueStatement,
					loop = loop,
					scope = scope,
				}
			end
			function Ast.PassSelfFunctionCallStatement(base, passSelfFunctionName, args)
				return {
					kind = AstKind.PassSelfFunctionCallStatement,
					base = base,
					passSelfFunctionName = passSelfFunctionName,
					args = args,
				}
			end
			function Ast.AssignmentStatement(lhs, rhs)
				if #lhs < 1 then
					print(debug.traceback())
					error("Something went wrong!")
				end
				return {
					kind = AstKind.AssignmentStatement,
					lhs = lhs,
					rhs = rhs,
				}
			end
			function Ast.CompoundAddStatement(lhs, rhs)
				return {
					kind = AstKind.CompoundAddStatement,
					lhs = lhs,
					rhs = rhs,
				}
			end
			function Ast.CompoundSubStatement(lhs, rhs)
				return {
					kind = AstKind.CompoundSubStatement,
					lhs = lhs,
					rhs = rhs,
				}
			end
			function Ast.CompoundMulStatement(lhs, rhs)
				return {
					kind = AstKind.CompoundMulStatement,
					lhs = lhs,
					rhs = rhs,
				}
			end
			function Ast.CompoundDivStatement(lhs, rhs)
				return {
					kind = AstKind.CompoundDivStatement,
					lhs = lhs,
					rhs = rhs,
				}
			end
			function Ast.CompoundPowStatement(lhs, rhs)
				return {
					kind = AstKind.CompoundPowStatement,
					lhs = lhs,
					rhs = rhs,
				}
			end
			function Ast.CompoundModStatement(lhs, rhs)
				return {
					kind = AstKind.CompoundModStatement,
					lhs = lhs,
					rhs = rhs,
				}
			end
			function Ast.CompoundConcatStatement(lhs, rhs)
				return {
					kind = AstKind.CompoundConcatStatement,
					lhs = lhs,
					rhs = rhs,
				}
			end
			function Ast.FunctionCallStatement(base, args)
				return {
					kind = AstKind.FunctionCallStatement,
					base = base,
					args = args,
				}
			end
			function Ast.ReturnStatement(args)
				return {
					kind = AstKind.ReturnStatement,
					args = args,
				}
			end
			function Ast.DoStatement(body)
				return {
					kind = AstKind.DoStatement,
					body = body,
				}
			end
			function Ast.WhileStatement(body, condition, parentScope)
				return {
					kind = AstKind.WhileStatement,
					body = body,
					condition = condition,
					parentScope = parentScope,
				}
			end
			function Ast.ForInStatement(scope, vars, expressions, body, parentScope)
				return {
					kind = AstKind.ForInStatement,
					scope = scope,
					ids = vars,
					vars = vars,
					expressions = expressions,
					body = body,
					parentScope = parentScope,
				}
			end
			function Ast.ForStatement(scope, id, initialValue, finalValue, incrementBy, body, parentScope)
				return {
					kind = AstKind.ForStatement,
					scope = scope,
					id = id,
					initialValue = initialValue,
					finalValue = finalValue,
					incrementBy = incrementBy,
					body = body,
					parentScope = parentScope,
				}
			end
			function Ast.RepeatStatement(condition, body, parentScope)
				return {
					kind = AstKind.RepeatStatement,
					body = body,
					condition = condition,
					parentScope = parentScope,
				}
			end
			function Ast.IfStatement(condition, body, elseifs, elsebody)
				return {
					kind = AstKind.IfStatement,
					condition = condition,
					body = body,
					elseifs = elseifs,
					elsebody = elsebody,
				}
			end
			function Ast.FunctionDeclaration(scope, id, indices, args, body)
				return {
					kind = AstKind.FunctionDeclaration,
					scope = scope,
					baseScope = scope,
					id = id,
					baseId = id,
					indices = indices,
					args = args,
					body = body,
					getName = function(self)
						return self.scope:getVariableName(self.id)
					end,
				}
			end
			function Ast.LocalFunctionDeclaration(scope, id, args, body)
				return {
					kind = AstKind.LocalFunctionDeclaration,
					scope = scope,
					id = id,
					args = args,
					body = body,
					getName = function(self)
						return self.scope:getVariableName(self.id)
					end,
				}
			end
			function Ast.LocalVariableDeclaration(scope, ids, expressions)
				return {
					kind = AstKind.LocalVariableDeclaration,
					scope = scope,
					ids = ids,
					expressions = expressions,
				}
			end
			function Ast.VarargExpression()
				return {
					kind = AstKind.VarargExpression,
					isConstant = false,
				}
			end
			function Ast.BooleanExpression(value)
				return {
					kind = AstKind.BooleanExpression,
					isConstant = true,
					value = value,
				}
			end
			function Ast.NilExpression()
				return {
					kind = AstKind.NilExpression,
					isConstant = true,
					value = nil,
				}
			end
			function Ast.NumberExpression(value)
				return {
					kind = AstKind.NumberExpression,
					isConstant = true,
					value = value,
				}
			end
			function Ast.StringExpression(value)
				return {
					kind = AstKind.StringExpression,
					isConstant = true,
					value = value,
				}
			end
			function Ast.OrExpression(lhs, rhs, simplify)
				if simplify and rhs.isConstant and lhs.isConstant then
					local success, val = pcall(function()
						return lhs.value or rhs.value
					end)
					if success then
						return Ast.ConstantNode(val)
					end
				end
				return {
					kind = AstKind.OrExpression,
					lhs = lhs,
					rhs = rhs,
					isConstant = false,
				}
			end
			function Ast.AndExpression(lhs, rhs, simplify)
				if simplify and rhs.isConstant and lhs.isConstant then
					local success, val = pcall(function()
						return lhs.value and rhs.value
					end)
					if success then
						return Ast.ConstantNode(val)
					end
				end
				return {
					kind = AstKind.AndExpression,
					lhs = lhs,
					rhs = rhs,
					isConstant = false,
				}
			end
			function Ast.LessThanExpression(lhs, rhs, simplify)
				if simplify and rhs.isConstant and lhs.isConstant then
					local success, val = pcall(function()
						return lhs.value < rhs.value
					end)
					if success then
						return Ast.ConstantNode(val)
					end
				end
				return {
					kind = AstKind.LessThanExpression,
					lhs = lhs,
					rhs = rhs,
					isConstant = false,
				}
			end
			function Ast.GreaterThanExpression(lhs, rhs, simplify)
				if simplify and rhs.isConstant and lhs.isConstant then
					local success, val = pcall(function()
						return lhs.value > rhs.value
					end)
					if success then
						return Ast.ConstantNode(val)
					end
				end
				return {
					kind = AstKind.GreaterThanExpression,
					lhs = lhs,
					rhs = rhs,
					isConstant = false,
				}
			end
			function Ast.LessThanOrEqualsExpression(lhs, rhs, simplify)
				if simplify and rhs.isConstant and lhs.isConstant then
					local success, val = pcall(function()
						return lhs.value <= rhs.value
					end)
					if success then
						return Ast.ConstantNode(val)
					end
				end
				return {
					kind = AstKind.LessThanOrEqualsExpression,
					lhs = lhs,
					rhs = rhs,
					isConstant = false,
				}
			end
			function Ast.GreaterThanOrEqualsExpression(lhs, rhs, simplify)
				if simplify and rhs.isConstant and lhs.isConstant then
					local success, val = pcall(function()
						return lhs.value >= rhs.value
					end)
					if success then
						return Ast.ConstantNode(val)
					end
				end
				return {
					kind = AstKind.GreaterThanOrEqualsExpression,
					lhs = lhs,
					rhs = rhs,
					isConstant = false,
				}
			end
			function Ast.NotEqualsExpression(lhs, rhs, simplify)
				if simplify and rhs.isConstant and lhs.isConstant then
					local success, val = pcall(function()
						return lhs.value ~= rhs.value
					end)
					if success then
						return Ast.ConstantNode(val)
					end
				end
				return {
					kind = AstKind.NotEqualsExpression,
					lhs = lhs,
					rhs = rhs,
					isConstant = false,
				}
			end
			function Ast.EqualsExpression(lhs, rhs, simplify)
				if simplify and rhs.isConstant and lhs.isConstant then
					local success, val = pcall(function()
						return lhs.value == rhs.value
					end)
					if success then
						return Ast.ConstantNode(val)
					end
				end
				return {
					kind = AstKind.EqualsExpression,
					lhs = lhs,
					rhs = rhs,
					isConstant = false,
				}
			end
			function Ast.StrCatExpression(lhs, rhs, simplify)
				if simplify and rhs.isConstant and lhs.isConstant then
					local success, val = pcall(function()
						return lhs.value .. rhs.value
					end)
					if success then
						return Ast.ConstantNode(val)
					end
				end
				return {
					kind = AstKind.StrCatExpression,
					lhs = lhs,
					rhs = rhs,
					isConstant = false,
				}
			end
			function Ast.AddExpression(lhs, rhs, simplify)
				if simplify and rhs.isConstant and lhs.isConstant then
					local success, val = pcall(function()
						return lhs.value + rhs.value
					end)
					if success then
						return Ast.ConstantNode(val)
					end
				end
				return {
					kind = AstKind.AddExpression,
					lhs = lhs,
					rhs = rhs,
					isConstant = false,
				}
			end
			function Ast.SubExpression(lhs, rhs, simplify)
				if simplify and rhs.isConstant and lhs.isConstant then
					local success, val = pcall(function()
						return lhs.value - rhs.value
					end)
					if success then
						return Ast.ConstantNode(val)
					end
				end
				return {
					kind = AstKind.SubExpression,
					lhs = lhs,
					rhs = rhs,
					isConstant = false,
				}
			end
			function Ast.MulExpression(lhs, rhs, simplify)
				if simplify and rhs.isConstant and lhs.isConstant then
					local success, val = pcall(function()
						return lhs.value * rhs.value
					end)
					if success then
						return Ast.ConstantNode(val)
					end
				end
				return {
					kind = AstKind.MulExpression,
					lhs = lhs,
					rhs = rhs,
					isConstant = false,
				}
			end
			function Ast.DivExpression(lhs, rhs, simplify)
				if simplify and rhs.isConstant and lhs.isConstant and rhs.value ~= 0 then
					local success, val = pcall(function()
						return lhs.value / rhs.value
					end)
					if success then
						return Ast.ConstantNode(val)
					end
				end
				return {
					kind = AstKind.DivExpression,
					lhs = lhs,
					rhs = rhs,
					isConstant = false,
				}
			end
			function Ast.ModExpression(lhs, rhs, simplify)
				if simplify and rhs.isConstant and lhs.isConstant then
					local success, val = pcall(function()
						return lhs.value % rhs.value
					end)
					if success then
						return Ast.ConstantNode(val)
					end
				end
				return {
					kind = AstKind.ModExpression,
					lhs = lhs,
					rhs = rhs,
					isConstant = false,
				}
			end
			function Ast.NotExpression(rhs, simplify)
				if simplify and rhs.isConstant then
					local success, val = pcall(function()
						return not rhs.value
					end)
					if success then
						return Ast.ConstantNode(val)
					end
				end
				return {
					kind = AstKind.NotExpression,
					rhs = rhs,
					isConstant = false,
				}
			end
			function Ast.NegateExpression(rhs, simplify)
				if simplify and rhs.isConstant then
					local success, val = pcall(function()
						return -rhs.value
					end)
					if success then
						return Ast.ConstantNode(val)
					end
				end
				return {
					kind = AstKind.NegateExpression,
					rhs = rhs,
					isConstant = false,
				}
			end
			function Ast.LenExpression(rhs, simplify)
				if simplify and rhs.isConstant then
					local success, val = pcall(function()
						return #rhs.value
					end)
					if success then
						return Ast.ConstantNode(val)
					end
				end
				return {
					kind = AstKind.LenExpression,
					rhs = rhs,
					isConstant = false,
				}
			end
			function Ast.PowExpression(lhs, rhs, simplify)
				if simplify and rhs.isConstant and lhs.isConstant then
					local success, val = pcall(function()
						return lhs.value ^ rhs.value
					end)
					if success then
						return Ast.ConstantNode(val)
					end
				end
				return {
					kind = AstKind.PowExpression,
					lhs = lhs,
					rhs = rhs,
					isConstant = false,
				}
			end
			function Ast.IndexExpression(base, index)
				return {
					kind = AstKind.IndexExpression,
					base = base,
					index = index,
					isConstant = false,
				}
			end
			function Ast.AssignmentIndexing(base, index)
				return {
					kind = AstKind.AssignmentIndexing,
					base = base,
					index = index,
					isConstant = false,
				}
			end
			function Ast.PassSelfFunctionCallExpression(base, passSelfFunctionName, args)
				return {
					kind = AstKind.PassSelfFunctionCallExpression,
					base = base,
					passSelfFunctionName = passSelfFunctionName,
					args = args,
				}
			end
			function Ast.FunctionCallExpression(base, args)
				return {
					kind = AstKind.FunctionCallExpression,
					base = base,
					args = args,
				}
			end
			function Ast.VariableExpression(scope, id)
				scope:addReference(id)
				return {
					kind = AstKind.VariableExpression,
					scope = scope,
					id = id,
					getName = function(self)
						return self.scope:getVariableName(self.id)
					end,
				}
			end
			function Ast.AssignmentVariable(scope, id)
				scope:addReference(id)
				return {
					kind = AstKind.AssignmentVariable,
					scope = scope,
					id = id,
					getName = function(self)
						return self.scope:getVariableName(self.id)
					end,
				}
			end
			function Ast.FunctionLiteralExpression(args, body)
				return {
					kind = AstKind.FunctionLiteralExpression,
					args = args,
					body = body,
				}
			end
			return Ast
		end
		function _ZukOfficial.b()
			local v = _ZukOfficial.cache.b
			if not v then
				v = { c = __modImpl() }
				_ZukOfficial.cache.b = v
			end
			return v.c
		end
	end
	do
		local function __modImpl()
			local keys = {
				reset = 0,
				bright = 1,
				dim = 2,
				underline = 4,
				blink = 5,
				reverse = 7,
				hidden = 8,
				black = 30,
				pink = 91,
				red = 31,
				green = 32,
				yellow = 33,
				blue = 34,
				magenta = 35,
				cyan = 36,
				grey = 37,
				gray = 37,
				white = 97,
				blackbg = 40,
				redbg = 41,
				greenbg = 42,
				yellowbg = 43,
				bluebg = 44,
				magentabg = 45,
				cyanbg = 46,
				greybg = 47,
				graybg = 47,
				whitebg = 107,
			}
			local escapeString = string.char(27) .. "[%dm"
			local function escapeNumber(number)
				return escapeString:format(number)
			end
			local settings = {
				enabled = true,
			}
			local function colors(str, ...)
				if not settings.enabled then
					return str
				end
				str = tostring(str or "")
				local escapes = {}
				for i, name in ipairs({ ... }) do
					table.insert(escapes, escapeNumber(keys[name]))
				end
				return escapeNumber(keys.reset) .. table.concat(escapes) .. str .. escapeNumber(keys.reset)
			end
			return setmetatable(settings, {
				__call = function(_, ...)
					return colors(...)
				end,
			})
		end
		function _ZukOfficial.c()
			local v = _ZukOfficial.cache.c
			if not v then
				v = { c = __modImpl() }
				_ZukOfficial.cache.c = v
			end
			return v.c
		end
	end
	do
		local function __modImpl()
			local logger = {}
			local config = _ZukOfficial.a()
			local colors = _ZukOfficial.c()
			logger.LogLevel = {
				Error = 0,
				Warn = 1,
				Log = 2,
				Info = 2,
				Debug = 3,
			}
			logger.logLevel = logger.LogLevel.Log
			logger.debugCallback = function(...)
				print(colors(config.NameUpper .. ": " .. ..., "grey"))
			end
			function logger:debug(...)
				if self.logLevel >= self.LogLevel.Debug then
					self.debugCallback(...)
				end
			end
			logger.logCallback = function(...)
				print(colors(config.NameUpper .. ": ", "magenta") .. ...)
			end
			function logger:log(...)
				if self.logLevel >= self.LogLevel.Log then
					self.logCallback(...)
				end
			end
			function logger:info(...)
				if self.logLevel >= self.LogLevel.Log then
					self.logCallback(...)
				end
			end
			logger.warnCallback = function(...)
				print(colors(config.NameUpper .. ": " .. ..., "yellow"))
			end
			function logger:warn(...)
				if self.logLevel >= self.LogLevel.Warn then
					self.warnCallback(...)
				end
			end
			logger.errorCallback = function(...)
				print(colors(config.NameUpper .. ": " .. ..., "red"))
				error(...)
			end
			function logger:error(...)
				self.errorCallback(...)
				error(config.NameUpper .. ": logger.errorCallback did not throw an Error!")
			end
			return logger
		end
		function _ZukOfficial.d()
			local v = _ZukOfficial.cache.d
			if not v then
				v = { c = __modImpl() }
				_ZukOfficial.cache.d = v
			end
			return v.c
		end
	end
	do
		local function __modImpl()
			local M = { _TYPE = "module", _NAME = "bit.numberlua", _VERSION = "0.3.1.20120131" }
			local floor = math.floor
			local MOD = 2 ^ 32
			local MODM = MOD - 1
			local function memoize(f)
				local mt = {}
				local t = setmetatable({}, mt)
				function mt:__index(k)
					local v = f(k)
					t[k] = v
					return v
				end
				return t
			end
			local function make_bitop_uncached(t, m)
				local function bitop(a, b)
					local res, p = 0, 1
					while a ~= 0 and b ~= 0 do
						local am, bm = a % m, b % m
						res = res + t[am][bm] * p
						a = (a - am) / m
						b = (b - bm) / m
						p = p * m
					end
					res = res + (a + b) * p
					return res
				end
				return bitop
			end
			local function make_bitop(t)
				local op1 = make_bitop_uncached(t, 2 ^ 1)
				local op2 = memoize(function(a)
					return memoize(function(b)
						return op1(a, b)
					end)
				end)
				return make_bitop_uncached(op2, 2 ^ (t.n or 1))
			end
			function M.tobit(x)
				return x % 2 ^ 32
			end
			M.bxor = make_bitop({ [0] = { [0] = 0, [1] = 1 }, [1] = { [0] = 1, [1] = 0 }, n = 4 })
			local bxor = M.bxor
			function M.bnot(a)
				return MODM - a
			end
			local bnot = M.bnot
			function M.band(a, b)
				return ((a + b) - bxor(a, b)) / 2
			end
			local band = M.band
			function M.bor(a, b)
				return MODM - band(MODM - a, MODM - b)
			end
			local bor = M.bor
			local lshift, rshift
			function M.rshift(a, disp)
				if disp < 0 then
					return lshift(a, -disp)
				end
				return floor(a % 2 ^ 32 / 2 ^ disp)
			end
			rshift = M.rshift
			function M.lshift(a, disp)
				if disp < 0 then
					return rshift(a, -disp)
				end
				return (a * 2 ^ disp) % 2 ^ 32
			end
			lshift = M.lshift
			function M.tohex(x, n)
				n = n or 8
				local up
				if n <= 0 then
					if n == 0 then
						return ""
					end
					up = true
					n = -n
				end
				x = band(x, 16 ^ n - 1)
				return ("%0" .. n .. (up and "X" or "x")):format(x)
			end
			local tohex = M.tohex
			function M.extract(n, field, width)
				width = width or 1
				return band(rshift(n, field), 2 ^ width - 1)
			end
			local extract = M.extract
			function M.replace(n, v, field, width)
				width = width or 1
				local mask1 = 2 ^ width - 1
				v = band(v, mask1)
				local mask = bnot(lshift(mask1, field))
				return band(n, mask) + lshift(v, field)
			end
			local replace = M.replace
			function M.bswap(x)
				local a = band(x, 0xff)
				x = rshift(x, 8)
				local b = band(x, 0xff)
				x = rshift(x, 8)
				local c = band(x, 0xff)
				x = rshift(x, 8)
				local d = band(x, 0xff)
				return lshift(lshift(lshift(a, 8) + b, 8) + c, 8) + d
			end
			local bswap = M.bswap
			function M.rrotate(x, disp)
				disp = disp % 32
				local low = band(x, 2 ^ disp - 1)
				return rshift(x, disp) + lshift(low, 32 - disp)
			end
			local rrotate = M.rrotate
			function M.lrotate(x, disp)
				return rrotate(x, -disp)
			end
			local lrotate = M.lrotate
			M.rol = M.lrotate
			M.ror = M.rrotate
			function M.arshift(x, disp)
				local z = rshift(x, disp)
				if x >= 0x80000000 then
					z = z + lshift(2 ^ disp - 1, 32 - disp)
				end
				return z
			end
			local arshift = M.arshift
			function M.btest(x, y)
				return band(x, y) ~= 0
			end
			M.bit32 = {}
			local function bit32_bnot(x)
				return (-1 - x) % MOD
			end
			M.bit32.bnot = bit32_bnot
			local function bit32_bxor(a, b, c, ...)
				local z
				if b then
					a = a % MOD
					b = b % MOD
					z = bxor(a, b)
					if c then
						z = bit32_bxor(z, c, ...)
					end
					return z
				elseif a then
					return a % MOD
				else
					return 0
				end
			end
			M.bit32.bxor = bit32_bxor
			local function bit32_band(a, b, c, ...)
				local z
				if b then
					a = a % MOD
					b = b % MOD
					z = ((a + b) - bxor(a, b)) / 2
					if c then
						z = bit32_band(z, c, ...)
					end
					return z
				elseif a then
					return a % MOD
				else
					return MODM
				end
			end
			M.bit32.band = bit32_band
			local function bit32_bor(a, b, c, ...)
				local z
				if b then
					a = a % MOD
					b = b % MOD
					z = MODM - band(MODM - a, MODM - b)
					if c then
						z = bit32_bor(z, c, ...)
					end
					return z
				elseif a then
					return a % MOD
				else
					return 0
				end
			end
			M.bit32.bor = bit32_bor
			function M.bit32.btest(...)
				return bit32_band(...) ~= 0
			end
			function M.bit32.lrotate(x, disp)
				return lrotate(x % MOD, disp)
			end
			function M.bit32.rrotate(x, disp)
				return rrotate(x % MOD, disp)
			end
			function M.bit32.lshift(x, disp)
				if disp > 31 or disp < -31 then
					return 0
				end
				return lshift(x % MOD, disp)
			end
			function M.bit32.rshift(x, disp)
				if disp > 31 or disp < -31 then
					return 0
				end
				return rshift(x % MOD, disp)
			end
			function M.bit32.arshift(x, disp)
				x = x % MOD
				if disp >= 0 then
					if disp > 31 then
						return (x >= 0x80000000) and MODM or 0
					else
						local z = rshift(x, disp)
						if x >= 0x80000000 then
							z = z + lshift(2 ^ disp - 1, 32 - disp)
						end
						return z
					end
				else
					return lshift(x, -disp)
				end
			end
			function M.bit32.extract(x, field, ...)
				local width = ... or 1
				if field < 0 or field > 31 or width < 0 or field + width > 32 then
					error("out of range")
				end
				x = x % MOD
				return extract(x, field, ...)
			end
			function M.bit32.replace(x, v, field, ...)
				local width = ... or 1
				if field < 0 or field > 31 or width < 0 or field + width > 32 then
					error("out of range")
				end
				x = x % MOD
				v = v % MOD
				return replace(x, v, field, ...)
			end
			M.bit = {}
			function M.bit.tobit(x)
				x = x % MOD
				if x >= 0x80000000 then
					x = x - MOD
				end
				return x
			end
			local bit_tobit = M.bit.tobit
			function M.bit.tohex(x, ...)
				return tohex(x % MOD, ...)
			end
			function M.bit.bnot(x)
				return bit_tobit(bnot(x % MOD))
			end
			local function bit_bor(a, b, c, ...)
				if c then
					return bit_bor(bit_bor(a, b), c, ...)
				elseif b then
					return bit_tobit(bor(a % MOD, b % MOD))
				else
					return bit_tobit(a)
				end
			end
			M.bit.bor = bit_bor
			local function bit_band(a, b, c, ...)
				if c then
					return bit_band(bit_band(a, b), c, ...)
				elseif b then
					return bit_tobit(band(a % MOD, b % MOD))
				else
					return bit_tobit(a)
				end
			end
			M.bit.band = bit_band
			local function bit_bxor(a, b, c, ...)
				if c then
					return bit_bxor(bit_bxor(a, b), c, ...)
				elseif b then
					return bit_tobit(bxor(a % MOD, b % MOD))
				else
					return bit_tobit(a)
				end
			end
			M.bit.bxor = bit_bxor
			function M.bit.lshift(x, n)
				return bit_tobit(lshift(x % MOD, n % 32))
			end
			function M.bit.rshift(x, n)
				return bit_tobit(rshift(x % MOD, n % 32))
			end
			function M.bit.arshift(x, n)
				return bit_tobit(arshift(x % MOD, n % 32))
			end
			function M.bit.rol(x, n)
				return bit_tobit(lrotate(x % MOD, n % 32))
			end
			function M.bit.ror(x, n)
				return bit_tobit(rrotate(x % MOD, n % 32))
			end
			function M.bit.bswap(x)
				return bit_tobit(bswap(x % MOD))
			end
			return M
		end
		function _ZukOfficial.e()
			local v = _ZukOfficial.cache.e
			if not v then
				v = { c = __modImpl() }
				_ZukOfficial.cache.e = v
			end
			return v.c
		end
	end
	do
		local function __modImpl()
			table.unpack = table.unpack or unpack
			local logger = _ZukOfficial.d()
			local bit32 = _ZukOfficial.e().bit32
			local MAX_UNPACK_COUNT = 195
			local function lookupify(tb)
				local tb2 = {}
				for _, v in ipairs(tb) do
					tb2[v] = true
				end
				return tb2
			end
			local function unlookupify(tb)
				local tb2 = {}
				for v, _ in pairs(tb) do
					table.insert(tb2, v)
				end
				return tb2
			end
			local function escape(str)
				return str:gsub(".", function(char)
					local byte = string.byte(char)
					if byte >= 32 and byte <= 126 and char ~= "\\" and char ~= '"' and char ~= "'" then
						return char
					end
					if char == "\\" then
						return "\\\\"
					end
					if char == "\n" then
						return "\\n"
					end
					if char == "\r" then
						return "\\r"
					end
					if char == '"' then
						return '\\"'
					end
					if char == "'" then
						return "\\'"
					end
					return string.format("\\%03d", byte)
				end)
			end
			local function chararray(str)
				local tb = {}
				for i = 1, str:len(), 1 do
					table.insert(tb, str:sub(i, i))
				end
				return tb
			end
			local function keys(tb)
				local keyset = {}
				local n = 0
				for k, v in pairs(tb) do
					n = n + 1
					keyset[n] = k
				end
				return keyset
			end
			local utf8char
			do
				local string_char = string.char
				function utf8char(cp)
					if cp < 128 then
						return string_char(cp)
					end
					local suffix = cp % 64
					local c4 = 128 + suffix
					cp = (cp - suffix) / 64
					if cp < 32 then
						return string_char(192 + cp, c4)
					end
					suffix = cp % 64
					local c3 = 128 + suffix
					cp = (cp - suffix) / 64
					if cp < 16 then
						return string_char(224 + cp, c3, c4)
					end
					suffix = cp % 64
					cp = (cp - suffix) / 64
					return string_char(240 + cp, 128 + suffix, c3, c4)
				end
			end
			local function shuffle(tb)
				for i = #tb, 2, -1 do
					local j = math.random(i)
					tb[i], tb[j] = tb[j], tb[i]
				end
				return tb
			end
			local function shuffle_string(str)
				local len = #str
				local t = {}
				for i = 1, len do
					t[i] = string.sub(str, i, i)
				end
				for i = 1, len do
					local j = math.random(i, len)
					t[i], t[j] = t[j], t[i]
				end
				return table.concat(t)
			end
			local function readDouble(bytes)
				local sign = 1
				local mantissa = bytes[2] % 2 ^ 4
				for i = 3, 8 do
					mantissa = mantissa * 256 + bytes[i]
				end
				if bytes[1] > 127 then
					sign = -1
				end
				local exponent = (bytes[1] % 128) * 2 ^ 4 + math.floor(bytes[2] / 2 ^ 4)
				if exponent == 0 then
					return 0
				end
				mantissa = (math.ldexp(mantissa, -52) + 1) * sign
				return math.ldexp(mantissa, exponent - 1023)
			end
			local function writeDouble(num)
				local bytes = { 0, 0, 0, 0, 0, 0, 0, 0 }
				if num == 0 then
					return bytes
				end
				local anum = math.abs(num)
				local mantissa, exponent = math.frexp(anum)
				exponent = exponent - 1
				mantissa = mantissa * 2 - 1
				local sign = num ~= anum and 128 or 0
				exponent = exponent + 1023
				bytes[1] = sign + math.floor(exponent / 2 ^ 4)
				mantissa = mantissa * 2 ^ 4
				local currentmantissa = math.floor(mantissa)
				mantissa = mantissa - currentmantissa
				bytes[2] = (exponent % 2 ^ 4) * 2 ^ 4 + currentmantissa
				for i = 3, 8 do
					mantissa = mantissa * 2 ^ 8
					currentmantissa = math.floor(mantissa)
					mantissa = mantissa - currentmantissa
					bytes[i] = currentmantissa
				end
				return bytes
			end
			local function writeU16(u16)
				if u16 < 0 or u16 > 65535 then
					logger:error(string.format("u16 out of bounds: %d", u16))
				end
				local lower = bit32.band(u16, 255)
				local upper = bit32.rshift(u16, 8)
				return { lower, upper }
			end
			local function readU16(arr)
				return bit32.bor(arr[1], bit32.lshift(arr[2], 8))
			end
			local function writeU24(u24)
				if u24 < 0 or u24 > 16777215 then
					logger:error(string.format("u24 out of bounds: %d", u24))
				end
				local arr = {}
				for i = 0, 2 do
					arr[i + 1] = bit32.band(bit32.rshift(u24, 8 * i), 255)
				end
				return arr
			end
			local function readU24(arr)
				local val = 0
				for i = 0, 2 do
					val = bit32.bor(val, bit32.lshift(arr[i + 1], 8 * i))
				end
				return val
			end
			local function writeU32(u32)
				if u32 < 0 or u32 > 4294967295 then
					logger:error(string.format("u32 out of bounds: %d", u32))
				end
				local arr = {}
				for i = 0, 3 do
					arr[i + 1] = bit32.band(bit32.rshift(u32, 8 * i), 255)
				end
				return arr
			end
			local function readU32(arr)
				local val = 0
				for i = 0, 3 do
					val = bit32.bor(val, bit32.lshift(arr[i + 1], 8 * i))
				end
				return val
			end
			local function bytesToString(arr)
				local length = arr.n or #arr
				if length < MAX_UNPACK_COUNT then
					return string.char(table.unpack(arr))
				end
				local str = ""
				local overflow = length % MAX_UNPACK_COUNT
				for i = 1, (#arr - overflow) / MAX_UNPACK_COUNT do
					str = str .. string.char(table.unpack(arr, (i - 1) * MAX_UNPACK_COUNT + 1, i * MAX_UNPACK_COUNT))
				end
				return str .. (overflow > 0 and string.char(table.unpack(arr, length - overflow + 1, length)) or "")
			end
			local function isNaN(n)
				return type(n) == "number" and n ~= n
			end
			local function isInt(n)
				return math.floor(n) == n
			end
			local function isU32(n)
				return n >= 0 and n <= 4294967295 and isInt(n)
			end
			local function toBits(num)
				local t = {}
				local rest
				while num > 0 do
					rest = math.fmod(num, 2)
					t[#t + 1] = rest
					num = (num - rest) / 2
				end
				return t
			end
			local function readonly(obj)
				local r = newproxy(true)
				getmetatable(r).__index = obj
				return r
			end
			return {
				lookupify = lookupify,
				unlookupify = unlookupify,
				escape = escape,
				chararray = chararray,
				keys = keys,
				shuffle = shuffle,
				readDouble = readDouble,
				writeDouble = writeDouble,
				readU16 = readU16,
				writeU16 = writeU16,
				readU32 = readU32,
				writeU32 = writeU32,
				readU24 = readU24,
				writeU24 = writeU24,
				isNaN = isNaN,
				isU32 = isU32,
				isInt = isInt,
				utf8char = utf8char,
				toBits = toBits,
				bytesToString = bytesToString,
				readonly = readonly,
			}
		end
		function _ZukOfficial.f()
			local v = _ZukOfficial.cache.f
			if not v then
				v = { c = __modImpl() }
				_ZukOfficial.cache.f = v
			end
			return v.c
		end
	end
	do
		local function __modImpl()
			local Enums = {}
			local chararray = _ZukOfficial.f().chararray
			Enums.LuaVersion = {
				LuaU = "LuaU",
				Lua51 = "Lua51",
			}
			Enums.Conventions = {
				[Enums.LuaVersion.Lua51] = {
					Keywords = {
						"and",
						"break",
						"do",
						"else",
						"elseif",
						"end",
						"false",
						"for",
						"function",
						"if",
						"in",
						"local",
						"nil",
						"not",
						"or",
						"repeat",
						"return",
						"then",
						"true",
						"until",
						"while",
					},
					SymbolChars = chararray("+-*/%^#=~<>(){}[];:,."),
					MaxSymbolLength = 3,
					Symbols = {
						"+",
						"-",
						"*",
						"/",
						"%",
						"^",
						"#",
						"==",
						"~=",
						"<=",
						">=",
						"<",
						">",
						"=",
						"(",
						")",
						"{",
						"}",
						"[",
						"]",
						";",
						":",
						",",
						".",
						"..",
						"...",
					},
					IdentChars = chararray("abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ_0123456789"),
					NumberChars = chararray("0123456789"),
					HexNumberChars = chararray("0123456789abcdefABCDEF"),
					BinaryNumberChars = { "0", "1" },
					DecimalExponent = { "e", "E" },
					HexadecimalNums = { "x", "X" },
					BinaryNums = { "b", "B" },
					DecimalSeperators = false,
					EscapeSequences = {
						["a"] = "\a",
						["b"] = "\b",
						["f"] = "\f",
						["n"] = "\n",
						["r"] = "\r",
						["t"] = "\t",
						["v"] = "\v",
						["\\"] = "\\",
						['"'] = '"',
						["'"] = "'",
					},
					NumericalEscapes = true,
					EscapeZIgnoreNextWhitespace = true,
					HexEscapes = true,
					UnicodeEscapes = true,
				},
				[Enums.LuaVersion.LuaU] = {
					Keywords = {
						"and",
						"break",
						"do",
						"else",
						"elseif",
						"continue",
						"end",
						"false",
						"for",
						"function",
						"if",
						"in",
						"local",
						"nil",
						"not",
						"or",
						"repeat",
						"return",
						"then",
						"true",
						"until",
						"while",
					},
					SymbolChars = chararray("+-*/%^#=~<>(){}[];:,."),
					MaxSymbolLength = 3,
					Symbols = {
						"+",
						"-",
						"*",
						"/",
						"%",
						"^",
						"#",
						"==",
						"~=",
						"<=",
						">=",
						"<",
						">",
						"=",
						"+=",
						"-=",
						"/=",
						"%=",
						"^=",
						"..=",
						"*=",
						"(",
						")",
						"{",
						"}",
						"[",
						"]",
						";",
						":",
						",",
						".",
						"..",
						"...",
						"::",
						"->",
						"?",
						"|",
						"&",
					},
					IdentChars = chararray("abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ_0123456789"),
					NumberChars = chararray("0123456789"),
					HexNumberChars = chararray("0123456789abcdefABCDEF"),
					BinaryNumberChars = { "0", "1" },
					DecimalExponent = { "e", "E" },
					HexadecimalNums = { "x", "X" },
					BinaryNums = { "b", "B" },
					DecimalSeperators = { "_" },
					EscapeSequences = {
						["a"] = "\a",
						["b"] = "\b",
						["f"] = "\f",
						["n"] = "\n",
						["r"] = "\r",
						["t"] = "\t",
						["v"] = "\v",
						["\\"] = "\\",
						['"'] = '"',
						["'"] = "'",
					},
					NumericalEscapes = true,
					EscapeZIgnoreNextWhitespace = true,
					HexEscapes = true,
					UnicodeEscapes = true,
				},
			}
			return Enums
		end
		function _ZukOfficial.g()
			local v = _ZukOfficial.cache.g
			if not v then
				v = { c = __modImpl() }
				_ZukOfficial.cache.g = v
			end
			return v.c
		end
	end
	do
		local function __modImpl()
			local Enums = _ZukOfficial.g()
			local util = _ZukOfficial.f()
			local logger = _ZukOfficial.d()
			local config = _ZukOfficial.a()
			local LuaVersion = Enums.LuaVersion
			local lookupify = util.lookupify
			local unlookupify = util.unlookupify
			local escape = util.escape
			local chararray = util.chararray
			local keys = util.keys
			local Tokenizer = {}
			Tokenizer.EOF_CHAR = "<EOF>"
			Tokenizer.WHITESPACE_CHARS = lookupify({
				" ",
				"\t",
				"\n",
				"\r",
			})
			Tokenizer.ANNOTATION_CHARS =
				lookupify(chararray("abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789-_"))
			Tokenizer.ANNOTATION_START_CHARS = lookupify(chararray("!@"))
			Tokenizer.Conventions = Enums.Conventions
			Tokenizer.TokenKind = {
				Eof = "Eof",
				Keyword = "Keyword",
				Symbol = "Symbol",
				Ident = "Identifier",
				Number = "Number",
				String = "String",
			}
			Tokenizer.EOF_TOKEN = {
				kind = Tokenizer.TokenKind.Eof,
				value = "<EOF>",
				startPos = -1,
				endPos = -1,
				source = "<EOF>",
			}
			local function token(self, startPos, kind, value)
				local line, linePos = self:getPosition(self.index)
				local annotations = self.annotations
				self.annotations = {}
				return {
					kind = kind,
					value = value,
					startPos = startPos,
					endPos = self.index,
					source = self.source:sub(startPos + 1, self.index),
					line = line,
					linePos = linePos,
					annotations = annotations,
				}
			end
			local function generateError(self, message)
				local line, linePos = self:getPosition(self.index)
				return "Lexing Error at Position " .. tostring(line) .. ":" .. tostring(linePos) .. ", " .. message
			end
			local function generateWarning(token, message)
				return "Warning at Position "
					.. tostring(token.line)
					.. ":"
					.. tostring(token.linePos)
					.. ", "
					.. message
			end
			function Tokenizer:getPosition(i)
				self:ensureColumnMap()
				local column = self.columnMap[i]
				if not column then
					column = self.columnMap[#self.columnMap]
				end
				return column.id, column.charMap[i]
			end
			function Tokenizer:prepareGetPosition()
				local columnMap, column = {}, { charMap = {}, id = 1, length = 0 }
				for index = 1, self.length do
					local character = string.sub(self.source, index, index)
					local columnLength = column.length + 1
					column.length = columnLength
					column.charMap[index] = columnLength
					if character == "\n" then
						column = { charMap = {}, id = column.id + 1, length = 0 }
					end
					columnMap[index] = column
				end
				self.columnMap = columnMap
			end
			function Tokenizer:new(settings)
				local luaVersion = (settings and (settings.luaVersion or settings.LuaVersion)) or LuaVersion.LuaU
				local conventions = Tokenizer.Conventions[luaVersion]
				if conventions == nil then
					logger:error(
						'The Lua Version "'
							.. luaVersion
							.. '" is not recognised by the Tokenizer! Please use one of the following: "'
							.. table.concat(keys(Tokenizer.Conventions), '","')
							.. '"'
					)
				end
				local tokenizer = {
					index = 0,
					length = 0,
					source = "",
					luaVersion = luaVersion,
					conventions = conventions,
					NumberChars = conventions.NumberChars,
					NumberCharsLookup = lookupify(conventions.NumberChars),
					Keywords = conventions.Keywords,
					KeywordsLookup = lookupify(conventions.Keywords),
					BinaryNumberChars = conventions.BinaryNumberChars,
					BinaryNumberCharsLookup = lookupify(conventions.BinaryNumberChars),
					BinaryNums = conventions.BinaryNums,
					HexadecimalNums = conventions.HexadecimalNums,
					HexNumberChars = conventions.HexNumberChars,
					HexNumberCharsLookup = lookupify(conventions.HexNumberChars),
					DecimalExponent = conventions.DecimalExponent,
					DecimalSeperators = conventions.DecimalSeperators,
					IdentChars = conventions.IdentChars,
					IdentCharsLookup = lookupify(conventions.IdentChars),
					EscapeSequences = conventions.EscapeSequences,
					NumericalEscapes = conventions.NumericalEscapes,
					EscapeZIgnoreNextWhitespace = conventions.EscapeZIgnoreNextWhitespace,
					HexEscapes = conventions.HexEscapes,
					UnicodeEscapes = conventions.UnicodeEscapes,
					SymbolChars = conventions.SymbolChars,
					SymbolCharsLookup = lookupify(conventions.SymbolChars),
					MaxSymbolLength = conventions.MaxSymbolLength,
					Symbols = conventions.Symbols,
					SymbolsLookup = lookupify(conventions.Symbols),
					StringStartLookup = lookupify({ '"', "'" }),
					annotations = {},
				}
				setmetatable(tokenizer, self)
				self.__index = self
				return tokenizer
			end
			function Tokenizer:reset()
				self.index = 0
				self.length = 0
				self.source = ""
				self.annotations = {}
				self.columnMap = {}
				self._columnMapDirty = false
			end
			function Tokenizer:append(code)
				self.source = self.source .. code
				self.length = self.length + code:len()
				self._columnMapDirty = true
			end
			function Tokenizer:ensureColumnMap()
				if self._columnMapDirty then
					self:prepareGetPosition()
					self._columnMapDirty = false
				end
			end
			local function peek(self, n)
				n = n or 0
				local i = self.index + n + 1
				if i > self.length then
					return Tokenizer.EOF_CHAR
				end
				return self.source:sub(i, i)
			end
			local function get(self)
				local i = self.index + 1
				if i > self.length then
					logger:error(generateError(self, "Unexpected end of Input"))
				end
				self.index = self.index + 1
				return self.source:sub(i, i)
			end
			local function expect(self, charOrLookup)
				if type(charOrLookup) == "string" then
					charOrLookup = { [charOrLookup] = true }
				end
				local char = peek(self)
				if charOrLookup[char] ~= true then
					local etb = unlookupify(charOrLookup)
					for i, v in ipairs(etb) do
						etb[i] = escape(v)
					end
					local errorMessage = 'Unexpected char "'
						.. escape(char)
						.. '"! Expected one of "'
						.. table.concat(etb, '","')
						.. '"'
					logger:error(generateError(self, errorMessage))
				end
				self.index = self.index + 1
				return char
			end
			local function is(self, charOrLookup, n)
				local char = peek(self, n)
				if type(charOrLookup) == "string" then
					return char == charOrLookup
				end
				return charOrLookup[char]
			end
			function Tokenizer:parseAnnotation()
				if is(self, Tokenizer.ANNOTATION_START_CHARS) then
					self.index = self.index + 1
					local source, length = {}, 0
					while is(self, Tokenizer.ANNOTATION_CHARS) do
						source[length + 1] = get(self)
						length = #source
					end
					if length > 0 then
						self.annotations[string.lower(table.concat(source))] = true
					end
					return nil
				end
				return get(self)
			end
			function Tokenizer:skipComment()
				if is(self, "-", 0) and is(self, "-", 1) then
					self.index = self.index + 2
					if is(self, "[") then
						self.index = self.index + 1
						local eqCount = 0
						while is(self, "=") do
							self.index = self.index + 1
							eqCount = eqCount + 1
						end
						if is(self, "[") then
							while true do
								if self:parseAnnotation() == "]" then
									local eqCount2 = 0
									while is(self, "=") do
										self.index = self.index + 1
										eqCount2 = eqCount2 + 1
									end
									if is(self, "]") then
										if eqCount2 == eqCount then
											self.index = self.index + 1
											return true
										end
									end
								end
							end
						end
					end
					while self.index < self.length and self:parseAnnotation() ~= "\n" do
					end
					return true
				end
				return false
			end
			function Tokenizer:skipWhitespaceAndComments()
				while self:skipComment() do
				end
				while is(self, Tokenizer.WHITESPACE_CHARS) do
					self.index = self.index + 1
					while self:skipComment() do
					end
				end
			end
			local function int(self, chars, seperators)
				local buffer = {}
				while true do
					if is(self, chars) then
						buffer[#buffer + 1] = get(self)
					elseif is(self, seperators) then
						self.index = self.index + 1
					else
						break
					end
				end
				return table.concat(buffer)
			end
			function Tokenizer:number()
				local startPos = self.index
				local source = expect(self, setmetatable({ ["."] = true }, { __index = self.NumberCharsLookup }))
				if source == "0" then
					if self.BinaryNums and is(self, lookupify(self.BinaryNums)) then
						self.index = self.index + 1
						source = int(self, self.BinaryNumberCharsLookup, lookupify(self.DecimalSeperators or {}))
						local value = tonumber(source, 2)
						return token(self, startPos, Tokenizer.TokenKind.Number, value)
					end
					if self.HexadecimalNums and is(self, lookupify(self.HexadecimalNums)) then
						self.index = self.index + 1
						source = int(self, self.HexNumberCharsLookup, lookupify(self.DecimalSeperators or {}))
						local value = tonumber(source, 16)
						return token(self, startPos, Tokenizer.TokenKind.Number, value)
					end
				end
				if source == "." then
					source = source .. int(self, self.NumberCharsLookup, lookupify(self.DecimalSeperators or {}))
				else
					source = source .. int(self, self.NumberCharsLookup, lookupify(self.DecimalSeperators or {}))
					if is(self, ".") then
						source = source
							.. get(self)
							.. int(self, self.NumberCharsLookup, lookupify(self.DecimalSeperators or {}))
					end
				end
				if self.DecimalExponent and is(self, lookupify(self.DecimalExponent)) then
					source = source .. get(self)
					if is(self, lookupify({ "+", "-" })) then
						source = source .. get(self)
					end
					local v = int(self, self.NumberCharsLookup, lookupify(self.DecimalSeperators or {}))
					if v:len() < 1 then
						logger:error(generateError(self, "Expected a Valid Exponent!"))
					end
					source = source .. v
				end
				local value = tonumber(source)
				return token(self, startPos, Tokenizer.TokenKind.Number, value)
			end
			function Tokenizer:ident()
				local startPos = self.index
				local source = expect(self, self.IdentCharsLookup)
				local sourceAddContent = { source }
				while is(self, self.IdentCharsLookup) do
					table.insert(sourceAddContent, get(self))
				end
				source = table.concat(sourceAddContent)
				if self.KeywordsLookup[source] then
					return token(self, startPos, Tokenizer.TokenKind.Keyword, source)
				end
				local tk = token(self, startPos, Tokenizer.TokenKind.Ident, source)
				if string.sub(source, 1, string.len(config.IdentPrefix)) == config.IdentPrefix then
					logger:warn(
						generateWarning(
							tk,
							string.format(
								'identifiers should not start with "%s" as this may break the program',
								config.IdentPrefix
							)
						)
					)
				end
				return tk
			end
			function Tokenizer:singleLineString()
				local startPos = self.index
				local startChar = expect(self, self.StringStartLookup)
				local buffer = {}
				while not is(self, startChar) do
					local char = get(self)
					if char == "\n" then
						self.index = self.index - 1
						logger:error(generateError(self, "Unterminated String"))
					end
					if char == "\\" then
						char = get(self)
						local escape = self.EscapeSequences[char]
						if type(escape) == "string" then
							char = escape
						elseif self.NumericalEscapes and self.NumberCharsLookup[char] then
							local numstr = char
							if is(self, self.NumberCharsLookup) then
								char = get(self)
								numstr = numstr .. char
							end
							if is(self, self.NumberCharsLookup) then
								char = get(self)
								numstr = numstr .. char
							end
							char = string.char(tonumber(numstr))
						elseif self.UnicodeEscapes and char == "u" then
							expect(self, "{")
							local num = ""
							while is(self, self.HexNumberCharsLookup) do
								num = num .. get(self)
							end
							expect(self, "}")
							char = util.utf8char(tonumber(num, 16))
						elseif self.HexEscapes and char == "x" then
							local hex = expect(self, self.HexNumberCharsLookup)
								.. expect(self, self.HexNumberCharsLookup)
							char = string.char(tonumber(hex, 16))
						elseif self.EscapeZIgnoreNextWhitespace and char == "z" then
							char = ""
							while is(self, Tokenizer.WHITESPACE_CHARS) do
								self.index = self.index + 1
							end
						end
					end
					buffer[#buffer + 1] = char
				end
				expect(self, startChar)
				return token(self, startPos, Tokenizer.TokenKind.String, table.concat(buffer))
			end
			function Tokenizer:multiLineString()
				local startPos = self.index
				if is(self, "[") then
					self.index = self.index + 1
					local eqCount = 0
					while is(self, "=") do
						self.index = self.index + 1
						eqCount = eqCount + 1
					end
					if is(self, "[") then
						self.index = self.index + 1
						if is(self, "\n") then
							self.index = self.index + 1
						end
						local value = ""
						while true do
							local char = get(self)
							if char == "]" then
								local eqCount2 = 0
								while is(self, "=") do
									char = char .. get(self)
									eqCount2 = eqCount2 + 1
								end
								if is(self, "]") then
									if eqCount2 == eqCount then
										self.index = self.index + 1
										return token(self, startPos, Tokenizer.TokenKind.String, value), true
									end
								end
							end
							value = value .. char
						end
					end
				end
				self.index = startPos
				return nil, false
			end
			function Tokenizer:symbol()
				local startPos = self.index
				for len = self.MaxSymbolLength, 1, -1 do
					local str = self.source:sub(self.index + 1, self.index + len)
					if self.SymbolsLookup[str] then
						self.index = self.index + len
						return token(self, startPos, Tokenizer.TokenKind.Symbol, str)
					end
				end
				logger:error(generateError(self, "Unknown Symbol"))
			end
			function Tokenizer:next()
				self:skipWhitespaceAndComments()
				local startPos = self.index
				if startPos >= self.length then
					return token(self, startPos, Tokenizer.TokenKind.Eof)
				end
				if is(self, self.NumberCharsLookup) then
					return self:number()
				end
				if is(self, self.IdentCharsLookup) then
					return self:ident()
				end
				if is(self, self.StringStartLookup) then
					return self:singleLineString()
				end
				if is(self, "[", 0) then
					local value, isString = self:multiLineString()
					if isString then
						return value
					end
				end
				if is(self, ".") and is(self, self.NumberCharsLookup, 1) then
					return self:number()
				end
				if is(self, self.SymbolCharsLookup) then
					return self:symbol()
				end
				logger:error(generateError(self, 'Unexpected char "' .. escape(peek(self)) .. '"!'))
			end
			function Tokenizer:scanAll()
				local tb = {}
				repeat
					local token = self:next()
					table.insert(tb, token)
				until token.kind == Tokenizer.TokenKind.Eof
				return tb
			end
			return Tokenizer
		end
		function _ZukOfficial.h()
			local v = _ZukOfficial.cache.h
			if not v then
				v = { c = __modImpl() }
				_ZukOfficial.cache.h = v
			end
			return v.c
		end
	end
	do
		local function __modImpl()
			local logger = _ZukOfficial.d()
			local config = _ZukOfficial.a()
			local Scope = {}
			local scopeI = 0
			local function nextName()
				scopeI = scopeI + 1
				return "local_scope_" .. tostring(scopeI)
			end
			local function generateWarning(token, message)
				return "Warning at Position "
					.. tostring(token.line)
					.. ":"
					.. tostring(token.linePos)
					.. ", "
					.. message
			end
			function Scope:new(parentScope, name)
				local scope = {
					isGlobal = false,
					parentScope = parentScope,
					variables = {},
					referenceCounts = {},
					variablesLookup = {},
					variablesFromHigherScopes = {},
					skipIdLookup = {},
					name = name or nextName(),
					children = {},
					level = parentScope.level and (parentScope.level + 1) or 1,
				}
				setmetatable(scope, self)
				self.__index = self
				parentScope:addChild(scope)
				return scope
			end
			function Scope:newGlobal()
				local scope = {
					isGlobal = true,
					parentScope = nil,
					variables = {},
					variablesLookup = {},
					referenceCounts = {},
					skipIdLookup = {},
					name = "global_scope",
					children = {},
					level = 0,
				}
				setmetatable(scope, self)
				self.__index = self
				return scope
			end
			function Scope:getParent()
				return self.parentScope
			end
			function Scope:setParent(parentScope)
				self.parentScope:removeChild(self)
				parentScope:addChild(self)
				self.parentScope = parentScope
				self.level = parentScope.level + 1
			end
			local next_name_i = 1
			function Scope:addVariable(name, token)
				if not name then
					name = string.format("%s%i", config.IdentPrefix, next_name_i)
					next_name_i = next_name_i + 1
				end
				if self.variablesLookup[name] ~= nil then
					if token then
						logger:warn(
							generateWarning(token, 'the variable "' .. name .. '" is already defined in that scope')
						)
					else
						logger:error(
							string.format(
								'A variable with the name "%s" was already defined, you should have no variables starting with "%s"',
								name,
								config.IdentPrefix
							)
						)
					end
				end
				table.insert(self.variables, name)
				local id = #self.variables
				self.variablesLookup[name] = id
				return id
			end
			function Scope:enableVariable(id)
				local name = self.variables[id]
				self.variablesLookup[name] = id
			end
			function Scope:addDisabledVariable(name, token)
				if not name then
					name = string.format("%s%i", config.IdentPrefix, next_name_i)
					next_name_i = next_name_i + 1
				end
				if self.variablesLookup[name] ~= nil then
					if token then
						logger:warn(
							generateWarning(token, 'the variable "' .. name .. '" is already defined in that scope')
						)
					else
						logger:warn(string.format('a variable with the name "%s" was already defined', name))
					end
				end
				table.insert(self.variables, name)
				local id = #self.variables
				return id
			end
			function Scope:addIfNotExists(id)
				if not self.variables[id] then
					local name = string.format("%s%i", config.IdentPrefix, next_name_i)
					next_name_i = next_name_i + 1
					self.variables[id] = name
					self.variablesLookup[name] = id
				end
				return id
			end
			function Scope:hasVariable(name)
				if self.isGlobal then
					if self.variablesLookup[name] == nil then
						self:addVariable(name)
					end
					return true
				end
				return self.variablesLookup[name] ~= nil
			end
			function Scope:getVariables()
				return self.variables
			end
			function Scope:resetReferences(id)
				self.referenceCounts[id] = 0
			end
			function Scope:getReferences(id)
				return self.referenceCounts[id] or 0
			end
			function Scope:removeReference(id)
				self.referenceCounts[id] = (self.referenceCounts[id] or 0) - 1
			end
			function Scope:addReference(id)
				self.referenceCounts[id] = (self.referenceCounts[id] or 0) + 1
			end
			function Scope:resolve(name)
				if self:hasVariable(name) then
					return self, self.variablesLookup[name]
				end
				assert(self.parentScope, "No Global Variable Scope was Created! This should not be Possible!")
				local scope, id = self.parentScope:resolve(name)
				self:addReferenceToHigherScope(scope, id, nil, true)
				return scope, id
			end
			function Scope:resolveGlobal(name)
				if self.isGlobal and self:hasVariable(name) then
					return self, self.variablesLookup[name]
				end
				assert(self.parentScope, "No Global Variable Scope was Created! This should not be Possible!")
				local scope, id = self.parentScope:resolveGlobal(name)
				self:addReferenceToHigherScope(scope, id, nil, true)
				return scope, id
			end
			function Scope:getVariableName(id)
				return self.variables[id]
			end
			function Scope:removeVariable(id)
				local name = self.variables[id]
				self.variables[id] = nil
				self.variablesLookup[name] = nil
				self.skipIdLookup[id] = true
			end
			function Scope:addChild(scope)
				for scope, ids in pairs(scope.variablesFromHigherScopes) do
					for id, count in pairs(ids) do
						if count and count > 0 then
							self:addReferenceToHigherScope(scope, id, count)
						end
					end
				end
				table.insert(self.children, scope)
			end
			function Scope:clearReferences()
				self.referenceCounts = {}
				self.variablesFromHigherScopes = {}
			end
			function Scope:removeChild(child)
				for i, v in ipairs(self.children) do
					if v == child then
						for scope, ids in pairs(v.variablesFromHigherScopes) do
							for id, count in pairs(ids) do
								if count and count > 0 then
									self:removeReferenceToHigherScope(scope, id, count)
								end
							end
						end
						return table.remove(self.children, i)
					end
				end
			end
			function Scope:getMaxId()
				return #self.variables
			end
			function Scope:addReferenceToHigherScope(scope, id, n, b)
				n = n or 1
				if self.isGlobal then
					if not scope.isGlobal then
						logger:error(string.format('Could not resolve Scope "%s"', scope.name))
					end
					return
				end
				if scope == self then
					self.referenceCounts[id] = (self.referenceCounts[id] or 0) + n
					return
				end
				if not self.variablesFromHigherScopes[scope] then
					self.variablesFromHigherScopes[scope] = {}
				end
				local scopeReferences = self.variablesFromHigherScopes[scope]
				if scopeReferences[id] then
					scopeReferences[id] = scopeReferences[id] + n
				else
					scopeReferences[id] = n
				end
				if not b then
					self.parentScope:addReferenceToHigherScope(scope, id, n)
				end
			end
			function Scope:removeReferenceToHigherScope(scope, id, n, b)
				n = n or 1
				if self.isGlobal then
					return
				end
				if scope == self then
					self.referenceCounts[id] = (self.referenceCounts[id] or 0) - n
					return
				end
				if not self.variablesFromHigherScopes[scope] then
					self.variablesFromHigherScopes[scope] = {}
				end
				local scopeReferences = self.variablesFromHigherScopes[scope]
				if scopeReferences[id] then
					scopeReferences[id] = scopeReferences[id] - n
				else
					scopeReferences[id] = 0
				end
				if not b then
					self.parentScope:removeReferenceToHigherScope(scope, id, n)
				end
			end
			function Scope:renameVariables(settings)
				if not self.isGlobal then
					local prefix = settings.prefix or ""
					local forbiddenNamesLookup = {}
					for _, keyword in pairs(settings.Keywords) do
						forbiddenNamesLookup[keyword] = true
					end
					for scope, ids in pairs(self.variablesFromHigherScopes) do
						for id, count in pairs(ids) do
							if count and count > 0 then
								local name = scope:getVariableName(id)
								forbiddenNamesLookup[name] = true
							end
						end
					end
					self.variablesLookup = {}
					local i = 0
					for id, originalName in ipairs(self.variables) do
						if not self.skipIdLookup[id] and (self.referenceCounts[id] or 0) >= 0 then
							local name
							repeat
								name = prefix .. settings.generateName(i, self, originalName)
								if name == nil then
									name = originalName
								end
								i = i + 1
							until not forbiddenNamesLookup[name]
							self.variables[id] = name
							self.variablesLookup[name] = id
						end
					end
				end
				for _, scope in pairs(self.children) do
					scope:renameVariables(settings)
				end
			end
			return Scope
		end
		function _ZukOfficial.i()
			local v = _ZukOfficial.cache.i
			if not v then
				v = { c = __modImpl() }
				_ZukOfficial.cache.i = v
			end
			return v.c
		end
	end
	do
		local function __modImpl()
			local Tokenizer = _ZukOfficial.h()
			local Enums = _ZukOfficial.g()
			local util = _ZukOfficial.f()
			local Ast = _ZukOfficial.b()
			local Scope = _ZukOfficial.i()
			local logger = _ZukOfficial.d()
			local AstKind = Ast.AstKind
			local LuaVersion = Enums.LuaVersion
			local lookupify = util.lookupify
			local unlookupify = util.unlookupify
			local escape = util.escape
			local chararray = util.chararray
			local keys = util.keys
			local TokenKind = Tokenizer.TokenKind
			local Parser = {}
			local ASSIGNMENT_NO_WARN_LOOKUP = lookupify({
				AstKind.NilExpression,
				AstKind.FunctionCallExpression,
				AstKind.PassSelfFunctionCallExpression,
				AstKind.VarargExpression,
			})
			local CALLABLE_PREFIX_EXPRESSION_LOOKUP = lookupify({
				AstKind.VariableExpression,
				AstKind.IndexExpression,
				AstKind.FunctionCallExpression,
				AstKind.PassSelfFunctionCallExpression,
			})
			local function generateError(self, message)
				local token
				if self.index > self.length then
					token = self.tokens[self.length]
				elseif self.index < 1 then
					return "Parsing Error at Position 0:0, " .. message
				else
					token = self.tokens[self.index]
				end
				return "Parsing Error at Position "
					.. tostring(token.line)
					.. ":"
					.. tostring(token.linePos)
					.. ", "
					.. message
			end
			local function generateWarning(token, message)
				return "Warning at Position "
					.. tostring(token.line)
					.. ":"
					.. tostring(token.linePos)
					.. ", "
					.. message
			end
			function Parser:new(settings)
				local luaVersion = (settings and (settings.luaVersion or settings.LuaVersion)) or LuaVersion.LuaU
				local parser = {
					luaVersion = luaVersion,
					tokenizer = Tokenizer:new({
						luaVersion = luaVersion,
					}),
					tokens = {},
					length = 0,
					index = 0,
				}
				setmetatable(parser, self)
				self.__index = self
				return parser
			end
			local function peek(self, n)
				n = n or 0
				local i = self.index + n + 1
				if i > self.length then
					return Tokenizer.EOF_TOKEN
				end
				return self.tokens[i]
			end
			local function get(self)
				local i = self.index + 1
				if i > self.length then
					error(generateError(self, "Unexpected end of Input"))
				end
				self.index = self.index + 1
				local tk = self.tokens[i]
				return tk
			end
			local function is(self, kind, sourceOrN, n)
				local token = peek(self, n)
				local source = nil
				if type(sourceOrN) == "string" then
					source = sourceOrN
				else
					n = sourceOrN
				end
				n = n or 0
				if token.kind == kind then
					if source == nil or token.source == source then
						return true
					end
				end
				return false
			end
			local function consume(self, kind, source)
				if is(self, kind, source) then
					self.index = self.index + 1
					return true
				end
				return false
			end
			local function expect(self, kind, source)
				if is(self, kind, source, 0) then
					return get(self)
				end
				local token = peek(self)
				if self.disableLog then
					error()
				end
				if source then
					logger:error(
						generateError(
							self,
							string.format(
								'unexpected token <%s> "%s", expected <%s> "%s"',
								token.kind,
								token.source,
								kind,
								source
							)
						)
					)
				else
					logger:error(
						generateError(
							self,
							string.format('unexpected token <%s> "%s", expected <%s>', token.kind, token.source, kind)
						)
					)
				end
			end
			function Parser:parse(code)
				self.tokenizer:append(code)
				self.tokens = self.tokenizer:scanAll()
				self.length = #self.tokens
				local globalScope = Scope:newGlobal()
				local ast = Ast.TopNode(self:block(globalScope, false), globalScope)
				expect(self, TokenKind.Eof)
				logger:debug("Cleaning up Parser for next Use ...")
				self.tokenizer:reset()
				self.tokens = {}
				self.index = 0
				self.length = 0
				logger:debug("Cleanup Done")
				return ast
			end
			function Parser:block(parentScope, currentLoop, scope)
				scope = scope or Scope:new(parentScope)
				local statements = {}
				repeat
					local statement, isTerminatingStatement = self:statement(scope, currentLoop)
					table.insert(statements, statement)
				until isTerminatingStatement or not statement
				consume(self, TokenKind.Symbol, ";")
				return Ast.Block(statements, scope)
			end
			function Parser:statement(scope, currentLoop)
				while consume(self, TokenKind.Symbol, ";") do
				end
				if consume(self, TokenKind.Keyword, "break") then
					if not currentLoop then
						if self.disableLog then
							error()
						end
						logger:error(generateError(self, "the break Statement is only valid inside of loops"))
					end
					return Ast.BreakStatement(currentLoop, scope), true
				end
				if self.luaVersion == LuaVersion.LuaU and consume(self, TokenKind.Keyword, "continue") then
					if not currentLoop then
						if self.disableLog then
							error()
						end
						logger:error(generateError(self, "the continue Statement is only valid inside of loops"))
					end
					return Ast.ContinueStatement(currentLoop, scope), true
				end
				if consume(self, TokenKind.Keyword, "do") then
					local body = self:block(scope, currentLoop)
					expect(self, TokenKind.Keyword, "end")
					return Ast.DoStatement(body)
				end
				if consume(self, TokenKind.Keyword, "while") then
					local condition = self:expression(scope)
					expect(self, TokenKind.Keyword, "do")
					local stat = Ast.WhileStatement(nil, condition, scope)
					stat.body = self:block(scope, stat)
					expect(self, TokenKind.Keyword, "end")
					return stat
				end
				if consume(self, TokenKind.Keyword, "repeat") then
					local repeatScope = Scope:new(scope)
					local stat = Ast.RepeatStatement(nil, nil, scope)
					stat.body = self:block(nil, stat, repeatScope)
					expect(self, TokenKind.Keyword, "until")
					stat.condition = self:expression(repeatScope)
					return stat
				end
				if consume(self, TokenKind.Keyword, "return") then
					local args = {}
					if
						not is(self, TokenKind.Keyword, "end")
						and not is(self, TokenKind.Keyword, "elseif")
						and not is(self, TokenKind.Keyword, "else")
						and not is(self, TokenKind.Symbol, ";")
						and not is(self, TokenKind.Eof)
					then
						args = self:exprList(scope)
					end
					return Ast.ReturnStatement(args), true
				end
				if consume(self, TokenKind.Keyword, "if") then
					local condition = self:expression(scope)
					expect(self, TokenKind.Keyword, "then")
					local body = self:block(scope, currentLoop)
					local elseifs = {}
					while consume(self, TokenKind.Keyword, "elseif") do
						local condition = self:expression(scope)
						expect(self, TokenKind.Keyword, "then")
						local body = self:block(scope, currentLoop)
						table.insert(elseifs, {
							condition = condition,
							body = body,
						})
					end
					local elsebody = nil
					if consume(self, TokenKind.Keyword, "else") then
						elsebody = self:block(scope, currentLoop)
					end
					expect(self, TokenKind.Keyword, "end")
					return Ast.IfStatement(condition, body, elseifs, elsebody)
				end
				if consume(self, TokenKind.Keyword, "function") then
					local obj = self:funcName(scope)
					local baseScope = obj.scope
					local baseId = obj.id
					local indices = obj.indices
					local funcScope = Scope:new(scope)
					expect(self, TokenKind.Symbol, "(")
					local args = self:functionArgList(funcScope)
					expect(self, TokenKind.Symbol, ")")
					if obj.passSelf then
						local id = funcScope:addVariable("self", obj.token)
						table.insert(args, 1, Ast.VariableExpression(funcScope, id))
					end
					local body = self:block(nil, false, funcScope)
					expect(self, TokenKind.Keyword, "end")
					return Ast.FunctionDeclaration(baseScope, baseId, indices, args, body)
				end
				if consume(self, TokenKind.Keyword, "local") then
					if consume(self, TokenKind.Keyword, "function") then
						local ident = expect(self, TokenKind.Ident)
						local name = ident.value
						local id = scope:addVariable(name, ident)
						local funcScope = Scope:new(scope)
						expect(self, TokenKind.Symbol, "(")
						local args = self:functionArgList(funcScope)
						expect(self, TokenKind.Symbol, ")")
						local body = self:block(nil, false, funcScope)
						expect(self, TokenKind.Keyword, "end")
						return Ast.LocalFunctionDeclaration(scope, id, args, body)
					end
					local ids = self:nameList(scope)
					local expressions = {}
					if consume(self, TokenKind.Symbol, "=") then
						expressions = self:exprList(scope)
					end
					self:enableNameList(scope, ids)
					if #expressions > #ids then
						logger:warn(
							generateWarning(
								peek(self, -1),
								string.format(
									"assigning %d values to %d variable" .. ((#ids > 1 and "s") or ""),
									#expressions,
									#ids
								)
							)
						)
					elseif
						#ids > #expressions
						and #expressions > 0
						and not ASSIGNMENT_NO_WARN_LOOKUP[expressions[#expressions].kind]
					then
						logger:warn(
							generateWarning(
								peek(self, -1),
								string.format(
									"assigning %d value"
										.. ((#expressions > 1 and "s") or "")
										.. " to %d variables initializes extra variables with nil, add a nil value to silence",
									#expressions,
									#ids
								)
							)
						)
					end
					return Ast.LocalVariableDeclaration(scope, ids, expressions)
				end
				if consume(self, TokenKind.Keyword, "for") then
					if is(self, TokenKind.Symbol, "=", 1) then
						local forScope = Scope:new(scope)
						local ident = expect(self, TokenKind.Ident)
						local varId = forScope:addDisabledVariable(ident.value, ident)
						expect(self, TokenKind.Symbol, "=")
						local initialValue = self:expression(scope)
						expect(self, TokenKind.Symbol, ",")
						local finalValue = self:expression(scope)
						local incrementBy = Ast.NumberExpression(1)
						if consume(self, TokenKind.Symbol, ",") then
							incrementBy = self:expression(scope)
						end
						local stat =
							Ast.ForStatement(forScope, varId, initialValue, finalValue, incrementBy, nil, scope)
						forScope:enableVariable(varId)
						expect(self, TokenKind.Keyword, "do")
						stat.body = self:block(nil, stat, forScope)
						expect(self, TokenKind.Keyword, "end")
						return stat
					end
					local forScope = Scope:new(scope)
					local ids = self:nameList(forScope)
					expect(self, TokenKind.Keyword, "in")
					local expressions = self:exprList(scope)
					self:enableNameList(forScope, ids)
					expect(self, TokenKind.Keyword, "do")
					local stat = Ast.ForInStatement(forScope, ids, expressions, nil, scope)
					stat.body = self:block(nil, stat, forScope)
					expect(self, TokenKind.Keyword, "end")
					return stat
				end
				local expr = self:primaryExpression(scope)
				if expr then
					if expr.kind == AstKind.FunctionCallExpression then
						return Ast.FunctionCallStatement(expr.base, expr.args)
					end
					if expr.kind == AstKind.PassSelfFunctionCallExpression then
						return Ast.PassSelfFunctionCallStatement(expr.base, expr.passSelfFunctionName, expr.args)
					end
					if expr.kind == AstKind.IndexExpression or expr.kind == AstKind.VariableExpression then
						if expr.kind == AstKind.IndexExpression then
							expr.kind = AstKind.AssignmentIndexing
						end
						if expr.kind == AstKind.VariableExpression then
							expr.kind = AstKind.AssignmentVariable
						end
						local compoundOps = { "+=", "-=", "*=", "/=", "%=", "^=", "..=" }
						local isCompound = false
						for _, op in ipairs(compoundOps) do
							if is(self, TokenKind.Symbol, op) then
								isCompound = true
								break
							end
						end
						if isCompound then
							if self.luaVersion ~= LuaVersion.LuaU then
								if self.disableLog then
									error()
								end
								logger:error(
									generateError(
										self,
										"compound assignment operators (+=, -=, etc.) are only supported in LuaU mode. Use Lua51 = false or switch to LuaU in your obfuscator settings"
									)
								)
							end
							if consume(self, TokenKind.Symbol, "+=") then
								local rhs = self:expression(scope)
								return Ast.CompoundAddStatement(expr, rhs)
							end
							if consume(self, TokenKind.Symbol, "-=") then
								local rhs = self:expression(scope)
								return Ast.CompoundSubStatement(expr, rhs)
							end
							if consume(self, TokenKind.Symbol, "*=") then
								local rhs = self:expression(scope)
								return Ast.CompoundMulStatement(expr, rhs)
							end
							if consume(self, TokenKind.Symbol, "/=") then
								local rhs = self:expression(scope)
								return Ast.CompoundDivStatement(expr, rhs)
							end
							if consume(self, TokenKind.Symbol, "%=") then
								local rhs = self:expression(scope)
								return Ast.CompoundModStatement(expr, rhs)
							end
							if consume(self, TokenKind.Symbol, "^=") then
								local rhs = self:expression(scope)
								return Ast.CompoundPowStatement(expr, rhs)
							end
							if consume(self, TokenKind.Symbol, "..=") then
								local rhs = self:expression(scope)
								return Ast.CompoundConcatStatement(expr, rhs)
							end
						end
						local lhs = {
							expr,
						}
						while consume(self, TokenKind.Symbol, ",") do
							expr = self:primaryExpression(scope)
							if not expr then
								if self.disableLog then
									error()
								end
								logger:error(
									generateError(
										self,
										string.format("expected a valid assignment statement lhs part but got nil")
									)
								)
							end
							if expr.kind == AstKind.IndexExpression or expr.kind == AstKind.VariableExpression then
								if expr.kind == AstKind.IndexExpression then
									expr.kind = AstKind.AssignmentIndexing
								end
								if expr.kind == AstKind.VariableExpression then
									expr.kind = AstKind.AssignmentVariable
								end
								table.insert(lhs, expr)
							else
								if self.disableLog then
									error()
								end
								logger:error(
									generateError(
										self,
										string.format(
											"expected a valid assignment statement lhs part but got <%s>",
											expr.kind
										)
									)
								)
							end
						end
						expect(self, TokenKind.Symbol, "=")
						local rhs = self:exprList(scope)
						return Ast.AssignmentStatement(lhs, rhs)
					end
					if self.disableLog then
						error()
					end
					logger:error(generateError(self, "expressions are not valid statements!"))
				end
				return nil
			end
			function Parser:primaryExpression(scope)
				local i = self.index
				local s = self
				self.disableLog = true
				local status, val = pcall(self.expressionFunctionCall, self, scope)
				self.disableLog = false
				if status then
					return val
				else
					self.index = i
					return nil
				end
			end
			function Parser:exprList(scope)
				local expressions = {
					self:expression(scope),
				}
				while consume(self, TokenKind.Symbol, ",") do
					table.insert(expressions, self:expression(scope))
				end
				return expressions
			end
			function Parser:nameList(scope)
				local ids = {}
				local ident = expect(self, TokenKind.Ident)
				local id = scope:addDisabledVariable(ident.value, ident)
				table.insert(ids, id)
				while consume(self, TokenKind.Symbol, ",") do
					ident = expect(self, TokenKind.Ident)
					id = scope:addDisabledVariable(ident.value, ident)
					table.insert(ids, id)
				end
				return ids
			end
			function Parser:enableNameList(scope, list)
				for i, id in ipairs(list) do
					scope:enableVariable(id)
				end
			end
			function Parser:funcName(scope)
				local ident = expect(self, TokenKind.Ident)
				local baseName = ident.value
				local baseScope, baseId = scope:resolve(baseName)
				local indices = {}
				local passSelf = false
				while consume(self, TokenKind.Symbol, ".") do
					table.insert(indices, expect(self, TokenKind.Ident).value)
				end
				if consume(self, TokenKind.Symbol, ":") then
					table.insert(indices, expect(self, TokenKind.Ident).value)
					passSelf = true
				end
				return {
					scope = baseScope,
					id = baseId,
					indices = indices,
					passSelf = passSelf,
					token = ident,
				}
			end
			function Parser:expression(scope)
				return self:expressionOr(scope)
			end
			function Parser:expressionOr(scope)
				local lhs = self:expressionAnd(scope)
				if consume(self, TokenKind.Keyword, "or") then
					local rhs = self:expressionOr(scope)
					return Ast.OrExpression(lhs, rhs, true)
				end
				return lhs
			end
			function Parser:expressionAnd(scope)
				local lhs = self:expressionComparision(scope)
				if consume(self, TokenKind.Keyword, "and") then
					local rhs = self:expressionAnd(scope)
					return Ast.AndExpression(lhs, rhs, true)
				end
				return lhs
			end
			function Parser:expressionComparision(scope)
				local curr = self:expressionStrCat(scope)
				repeat
					local found = false
					if consume(self, TokenKind.Symbol, "<") then
						local rhs = self:expressionStrCat(scope)
						curr = Ast.LessThanExpression(curr, rhs, true)
						found = true
					end
					if consume(self, TokenKind.Symbol, ">") then
						local rhs = self:expressionStrCat(scope)
						curr = Ast.GreaterThanExpression(curr, rhs, true)
						found = true
					end
					if consume(self, TokenKind.Symbol, "<=") then
						local rhs = self:expressionStrCat(scope)
						curr = Ast.LessThanOrEqualsExpression(curr, rhs, true)
						found = true
					end
					if consume(self, TokenKind.Symbol, ">=") then
						local rhs = self:expressionStrCat(scope)
						curr = Ast.GreaterThanOrEqualsExpression(curr, rhs, true)
						found = true
					end
					if consume(self, TokenKind.Symbol, "~=") then
						local rhs = self:expressionStrCat(scope)
						curr = Ast.NotEqualsExpression(curr, rhs, true)
						found = true
					end
					if consume(self, TokenKind.Symbol, "==") then
						local rhs = self:expressionStrCat(scope)
						curr = Ast.EqualsExpression(curr, rhs, true)
						found = true
					end
				until not found
				return curr
			end
			function Parser:expressionStrCat(scope)
				local lhs = self:expressionAddSub(scope)
				if consume(self, TokenKind.Symbol, "..") then
					local rhs = self:expressionStrCat(scope)
					return Ast.StrCatExpression(lhs, rhs, true)
				end
				return lhs
			end
			function Parser:expressionAddSub(scope)
				local curr = self:expressionMulDivMod(scope)
				repeat
					local found = false
					if consume(self, TokenKind.Symbol, "+") then
						local rhs = self:expressionMulDivMod(scope)
						curr = Ast.AddExpression(curr, rhs, true)
						found = true
					end
					if consume(self, TokenKind.Symbol, "-") then
						local rhs = self:expressionMulDivMod(scope)
						curr = Ast.SubExpression(curr, rhs, true)
						found = true
					end
				until not found
				return curr
			end
			function Parser:expressionMulDivMod(scope)
				local curr = self:expressionUnary(scope)
				repeat
					local found = false
					if consume(self, TokenKind.Symbol, "*") then
						local rhs = self:expressionUnary(scope)
						curr = Ast.MulExpression(curr, rhs, true)
						found = true
					end
					if consume(self, TokenKind.Symbol, "/") then
						local rhs = self:expressionUnary(scope)
						curr = Ast.DivExpression(curr, rhs, true)
						found = true
					end
					if consume(self, TokenKind.Symbol, "%") then
						local rhs = self:expressionUnary(scope)
						curr = Ast.ModExpression(curr, rhs, true)
						found = true
					end
				until not found
				return curr
			end
			function Parser:expressionUnary(scope)
				if consume(self, TokenKind.Keyword, "not") then
					local rhs = self:expressionUnary(scope)
					return Ast.NotExpression(rhs, true)
				end
				if consume(self, TokenKind.Symbol, "#") then
					local rhs = self:expressionUnary(scope)
					return Ast.LenExpression(rhs, true)
				end
				if consume(self, TokenKind.Symbol, "-") then
					local rhs = self:expressionUnary(scope)
					return Ast.NegateExpression(rhs, true)
				end
				return self:expressionPow(scope)
			end
			function Parser:expressionPow(scope)
				local lhs = self:tableOrFunctionLiteral(scope)
				if consume(self, TokenKind.Symbol, "^") then
					local rhs = self:expressionPow(scope)
					return Ast.PowExpression(lhs, rhs, true)
				end
				return lhs
			end
			function Parser:tableOrFunctionLiteral(scope)
				if is(self, TokenKind.Symbol, "{") then
					return self:tableConstructor(scope)
				end
				if is(self, TokenKind.Keyword, "function") then
					return self:expressionFunctionLiteral(scope)
				end
				return self:expressionFunctionCall(scope)
			end
			function Parser:expressionFunctionLiteral(parentScope)
				local scope = Scope:new(parentScope)
				expect(self, TokenKind.Keyword, "function")
				expect(self, TokenKind.Symbol, "(")
				local args = self:functionArgList(scope)
				expect(self, TokenKind.Symbol, ")")
				local body = self:block(nil, false, scope)
				expect(self, TokenKind.Keyword, "end")
				return Ast.FunctionLiteralExpression(args, body)
			end
			function Parser:functionArgList(scope)
				local args = {}
				if consume(self, TokenKind.Symbol, "...") then
					table.insert(args, Ast.VarargExpression())
					return args
				end
				if is(self, TokenKind.Ident) then
					local ident = get(self)
					local name = ident.value
					local id = scope:addVariable(name, ident)
					table.insert(args, Ast.VariableExpression(scope, id))
					while consume(self, TokenKind.Symbol, ",") do
						if consume(self, TokenKind.Symbol, "...") then
							table.insert(args, Ast.VarargExpression())
							return args
						end
						ident = get(self)
						name = ident.value
						id = scope:addVariable(name, ident)
						table.insert(args, Ast.VariableExpression(scope, id))
					end
				end
				return args
			end
			function Parser:expressionFunctionCall(scope, base)
				base = base or self:expressionIndex(scope)
				if not (base and (CALLABLE_PREFIX_EXPRESSION_LOOKUP[base.kind] or base.isParenthesizedExpression)) then
					return base
				end
				local args = {}
				if is(self, TokenKind.String) then
					args = {
						Ast.StringExpression(get(self).value),
					}
				elseif is(self, TokenKind.Symbol, "{") then
					args = {
						self:tableConstructor(scope),
					}
				elseif consume(self, TokenKind.Symbol, "(") then
					if not is(self, TokenKind.Symbol, ")") then
						args = self:exprList(scope)
					end
					expect(self, TokenKind.Symbol, ")")
				else
					return base
				end
				local node = Ast.FunctionCallExpression(base, args)
				if
					is(self, TokenKind.Symbol, ".")
					or is(self, TokenKind.Symbol, "[")
					or is(self, TokenKind.Symbol, ":")
				then
					return self:expressionIndex(scope, node)
				end
				if is(self, TokenKind.Symbol, "(") or is(self, TokenKind.Symbol, "{") or is(self, TokenKind.String) then
					return self:expressionFunctionCall(scope, node)
				end
				return node
			end
			function Parser:expressionIndex(scope, base)
				base = base or self:expressionLiteral(scope)
				while consume(self, TokenKind.Symbol, "[") do
					local expr = self:expression(scope)
					expect(self, TokenKind.Symbol, "]")
					base = Ast.IndexExpression(base, expr)
				end
				while consume(self, TokenKind.Symbol, ".") do
					local ident = expect(self, TokenKind.Ident)
					base = Ast.IndexExpression(base, Ast.StringExpression(ident.value))
					while consume(self, TokenKind.Symbol, "[") do
						local expr = self:expression(scope)
						expect(self, TokenKind.Symbol, "]")
						base = Ast.IndexExpression(base, expr)
					end
				end
				if consume(self, TokenKind.Symbol, ":") then
					local passSelfFunctionName = expect(self, TokenKind.Ident).value
					local args = {}
					if is(self, TokenKind.String) then
						args = {
							Ast.StringExpression(get(self).value),
						}
					elseif is(self, TokenKind.Symbol, "{") then
						args = {
							self:tableConstructor(scope),
						}
					else
						expect(self, TokenKind.Symbol, "(")
						if not is(self, TokenKind.Symbol, ")") then
							args = self:exprList(scope)
						end
						expect(self, TokenKind.Symbol, ")")
					end
					local node = Ast.PassSelfFunctionCallExpression(base, passSelfFunctionName, args)
					if
						is(self, TokenKind.Symbol, ".")
						or is(self, TokenKind.Symbol, "[")
						or is(self, TokenKind.Symbol, ":")
					then
						return self:expressionIndex(scope, node)
					end
					if
						is(self, TokenKind.Symbol, "(")
						or is(self, TokenKind.Symbol, "{")
						or is(self, TokenKind.String)
					then
						return self:expressionFunctionCall(scope, node)
					end
					return node
				end
				if is(self, TokenKind.Symbol, "(") or is(self, TokenKind.Symbol, "{") or is(self, TokenKind.String) then
					return self:expressionFunctionCall(scope, base)
				end
				return base
			end
			function Parser:expressionLiteral(scope)
				if consume(self, TokenKind.Symbol, "(") then
					local expr = self:expression(scope)
					expect(self, TokenKind.Symbol, ")")
					if expr then
						expr.isParenthesizedExpression = true
					end
					return expr
				end
				if is(self, TokenKind.String) then
					return Ast.StringExpression(get(self).value)
				end
				if is(self, TokenKind.Number) then
					return Ast.NumberExpression(get(self).value)
				end
				if consume(self, TokenKind.Keyword, "true") then
					return Ast.BooleanExpression(true)
				end
				if consume(self, TokenKind.Keyword, "false") then
					return Ast.BooleanExpression(false)
				end
				if consume(self, TokenKind.Keyword, "nil") then
					return Ast.NilExpression()
				end
				if consume(self, TokenKind.Symbol, "...") then
					return Ast.VarargExpression()
				end
				if is(self, TokenKind.Ident) then
					local ident = get(self)
					local name = ident.value
					local scope, id = scope:resolve(name)
					return Ast.VariableExpression(scope, id)
				end
				if self.luaVersion == LuaVersion.LuaU then
					if consume(self, TokenKind.Keyword, "if") then
						local condition = self:expression(scope)
						expect(self, TokenKind.Keyword, "then")
						local true_value = self:expression(scope)
						expect(self, TokenKind.Keyword, "else")
						local false_value = self:expression(scope)
						return Ast.IfElseExpression(condition, true_value, false_value)
					end
				end
				if self.disableLog then
					error()
				end
				logger:error(
					generateError(self, 'Unexpected Token "' .. peek(self).source .. '". Expected a Expression!')
				)
			end
			function Parser:tableConstructor(scope)
				local entries = {}
				expect(self, TokenKind.Symbol, "{")
				while not consume(self, TokenKind.Symbol, "}") do
					if consume(self, TokenKind.Symbol, "[") then
						local key = self:expression(scope)
						expect(self, TokenKind.Symbol, "]")
						expect(self, TokenKind.Symbol, "=")
						local value = self:expression(scope)
						table.insert(entries, Ast.KeyedTableEntry(key, value))
					elseif is(self, TokenKind.Ident, 0) and is(self, TokenKind.Symbol, "=", 1) then
						local key = Ast.StringExpression(get(self).value)
						expect(self, TokenKind.Symbol, "=")
						local value = self:expression(scope)
						table.insert(entries, Ast.KeyedTableEntry(key, value))
					else
						local value = self:expression(scope)
						table.insert(entries, Ast.TableEntry(value))
					end
					if
						not consume(self, TokenKind.Symbol, ";")
						and not consume(self, TokenKind.Symbol, ",")
						and not is(self, TokenKind.Symbol, "}")
					then
						if self.disableLog then
							error()
						end
						logger:error(generateError(self, 'expected a ";" or a ","'))
					end
				end
				return Ast.TableConstructorExpression(entries)
			end
			return Parser
		end
		function _ZukOfficial.j()
			local v = _ZukOfficial.cache.j
			if not v then
				v = { c = __modImpl() }
				_ZukOfficial.cache.j = v
			end
			return v.c
		end
	end
	do
		local function __modImpl()
			local config = _ZukOfficial.a()
			local Ast = _ZukOfficial.b()
			local Enums = _ZukOfficial.g()
			local util = _ZukOfficial.f()
			local logger = _ZukOfficial.d()
			local lookupify = util.lookupify
			local LuaVersion = Enums.LuaVersion
			local AstKind = Ast.AstKind
			local Unparser = {}
			Unparser.SPACE = config.SPACE
			Unparser.TAB = config.TAB
			local function escapeString(str)
				str = util.escape(str)
				return str
			end
			function Unparser:new(settings)
				local luaVersion = settings.LuaVersion or LuaVersion.LuaU
				local conventions = Enums.Conventions[luaVersion]
				local unparser = {
					luaVersion = luaVersion,
					conventions = conventions,
					identCharsLookup = lookupify(conventions.IdentChars),
					numberCharsLookup = lookupify(conventions.NumberChars),
					prettyPrint = settings and settings.PrettyPrint or false,
					notIdentPattern = "[^" .. table.concat(conventions.IdentChars, "") .. "]",
					numberPattern = "^[" .. table.concat(conventions.NumberChars, "") .. "]",
					highlight = settings and settings.Highlight or false,
					keywordsLookup = lookupify(conventions.Keywords),
				}
				setmetatable(unparser, self)
				self.__index = self
				return unparser
			end
			function Unparser:isValidIdentifier(source)
				if string.find(source, self.notIdentPattern) then
					return false
				end
				if string.find(source, self.numberPattern) then
					return false
				end
				if self.keywordsLookup[source] then
					return false
				end
				return #source > 0
			end
			function Unparser:setPrettyPrint(prettyPrint)
				self.prettyPrint = prettyPrint
			end
			function Unparser:getPrettyPrint()
				return self.prettyPrint
			end
			function Unparser:tabs(i, ws_needed)
				return self.prettyPrint and string.rep(self.TAB, i) or ws_needed and self.SPACE or ""
			end
			function Unparser:newline(ws_needed)
				return self.prettyPrint and "\n" or ws_needed and self.SPACE or ""
			end
			function Unparser:whitespaceIfNeeded(following, ws)
				if self.prettyPrint or self.identCharsLookup[string.sub(following, 1, 1)] then
					return ws or self.SPACE
				end
				return ""
			end
			function Unparser:whitespaceIfNeeded2(leading, ws)
				local lastChar = string.sub(leading, #leading, #leading)
				if self.prettyPrint or self.identCharsLookup[lastChar] or self.numberCharsLookup[lastChar] then
					return ws or self.SPACE
				end
				return ""
			end
			function Unparser:optionalWhitespace(ws)
				return self.prettyPrint and (ws or self.SPACE) or ""
			end
			function Unparser:whitespace(ws)
				return self.SPACE or ws
			end
			function Unparser:unparse(ast)
				if ast.kind ~= AstKind.TopNode then
					logger:error("Unparser:unparse expects a TopNode as first argument")
				end
				return self:unparseBlock(ast.body)
			end
			function Unparser:unparseBlock(block, tabbing)
				local code = ""
				if #block.statements < 1 then
					return self:whitespace()
				end
				for i, statement in ipairs(block.statements) do
					if statement.kind ~= AstKind.NopStatement then
						local statementCode = self:unparseStatement(statement, tabbing)
						if not self.prettyPrint and #code > 0 and string.sub(statementCode, 1, 1) == "(" then
							statementCode = ";" .. statementCode
						end
						local ws =
							self:whitespaceIfNeeded2(code, self:whitespaceIfNeeded(statementCode, self:newline(true)))
						if i ~= 1 then
							code = code .. ws
						end
						if self.prettyPrint then
							statementCode = statementCode .. ";"
						end
						code = code .. statementCode
					end
				end
				return code
			end
			function Unparser:unparseStatement(statement, tabbing)
				tabbing = tabbing and tabbing + 1 or 0
				local code = ""
				if statement.kind == AstKind.ContinueStatement then
					code = "continue"
				elseif statement.kind == AstKind.BreakStatement then
					code = "break"
				elseif statement.kind == AstKind.DoStatement then
					local bodyCode = self:unparseBlock(statement.body, tabbing)
					code = "do"
						.. self:whitespaceIfNeeded(bodyCode, self:newline(true))
						.. bodyCode
						.. self:newline(false)
						.. self:whitespaceIfNeeded2(bodyCode, self:tabs(tabbing, true))
						.. "end"
				elseif statement.kind == AstKind.WhileStatement then
					local expressionCode = self:unparseExpression(statement.condition, tabbing)
					local bodyCode = self:unparseBlock(statement.body, tabbing)
					code = "while"
						.. self:whitespaceIfNeeded(expressionCode)
						.. expressionCode
						.. self:whitespaceIfNeeded2(expressionCode)
						.. "do"
						.. self:whitespaceIfNeeded(bodyCode, self:newline(true))
						.. bodyCode
						.. self:newline(false)
						.. self:whitespaceIfNeeded2(bodyCode, self:tabs(tabbing, true))
						.. "end"
				elseif statement.kind == AstKind.RepeatStatement then
					local expressionCode = self:unparseExpression(statement.condition, tabbing)
					local bodyCode = self:unparseBlock(statement.body, tabbing)
					code = "repeat"
						.. self:whitespaceIfNeeded(bodyCode, self:newline(true))
						.. bodyCode
						.. self:whitespaceIfNeeded2(bodyCode, self:newline() .. self:tabs(tabbing, true))
						.. "until"
						.. self:whitespaceIfNeeded(expressionCode)
						.. expressionCode
				elseif statement.kind == AstKind.ForStatement then
					local bodyCode = self:unparseBlock(statement.body, tabbing)
					code = "for"
						.. self:whitespace()
						.. statement.scope:getVariableName(statement.id)
						.. self:optionalWhitespace()
						.. "="
					code = code
						.. self:optionalWhitespace()
						.. self:unparseExpression(statement.initialValue, tabbing)
						.. ","
					code = code
						.. self:optionalWhitespace()
						.. self:unparseExpression(statement.finalValue, tabbing)
						.. ","
					local incrementByCode = statement.incrementBy
							and self:unparseExpression(statement.incrementBy, tabbing)
						or "1"
					code = code
						.. self:optionalWhitespace()
						.. incrementByCode
						.. self:whitespaceIfNeeded2(incrementByCode)
						.. "do"
						.. self:whitespaceIfNeeded(bodyCode, self:newline(true))
						.. bodyCode
						.. self:newline(false)
						.. self:whitespaceIfNeeded2(bodyCode, self:tabs(tabbing, true))
						.. "end"
				elseif statement.kind == AstKind.ForInStatement then
					code = "for" .. self:whitespace()
					for i, id in ipairs(statement.ids) do
						if i ~= 1 then
							code = code .. "," .. self:optionalWhitespace()
						end
						code = code .. statement.scope:getVariableName(id)
					end
					code = code .. self:whitespace() .. "in"
					local exprcode = self:unparseExpression(statement.expressions[1], tabbing)
					code = code .. self:whitespaceIfNeeded(exprcode) .. exprcode
					for i = 2, #statement.expressions, 1 do
						exprcode = self:unparseExpression(statement.expressions[i], tabbing)
						code = code .. "," .. self:optionalWhitespace() .. exprcode
					end
					local bodyCode = self:unparseBlock(statement.body, tabbing)
					code = code
						.. self:whitespaceIfNeeded2(code)
						.. "do"
						.. self:whitespaceIfNeeded(bodyCode, self:newline(true))
						.. bodyCode
						.. self:newline(false)
						.. self:whitespaceIfNeeded2(bodyCode, self:tabs(tabbing, true))
						.. "end"
				elseif statement.kind == AstKind.IfStatement then
					local exprcode = self:unparseExpression(statement.condition, tabbing)
					local bodyCode = self:unparseBlock(statement.body, tabbing)
					code = "if"
						.. self:whitespaceIfNeeded(exprcode)
						.. exprcode
						.. self:whitespaceIfNeeded2(exprcode)
						.. "then"
						.. self:whitespaceIfNeeded(bodyCode, self:newline(true))
						.. bodyCode
					for i, eif in ipairs(statement.elseifs) do
						exprcode = self:unparseExpression(eif.condition, tabbing)
						bodyCode = self:unparseBlock(eif.body, tabbing)
						code = code
							.. self:newline(false)
							.. self:whitespaceIfNeeded2(code, self:tabs(tabbing, true))
							.. "elseif"
							.. self:whitespaceIfNeeded(exprcode)
							.. exprcode
							.. self:whitespaceIfNeeded2(exprcode)
							.. "then"
							.. self:whitespaceIfNeeded(bodyCode, self:newline(true))
							.. bodyCode
					end
					if statement.elsebody then
						bodyCode = self:unparseBlock(statement.elsebody, tabbing)
						code = code
							.. self:newline(false)
							.. self:whitespaceIfNeeded2(code, self:tabs(tabbing, true))
							.. "else"
							.. self:whitespaceIfNeeded(bodyCode, self:newline(true))
							.. bodyCode
					end
					code = code
						.. self:newline(false)
						.. self:whitespaceIfNeeded2(bodyCode, self:tabs(tabbing, true))
						.. "end"
				elseif statement.kind == AstKind.FunctionDeclaration then
					local funcname = statement.scope:getVariableName(statement.id)
					for _, index in ipairs(statement.indices) do
						funcname = funcname .. "." .. index
					end
					code = "function" .. self:whitespace() .. funcname .. "("
					for i, arg in ipairs(statement.args) do
						if i > 1 then
							code = code .. "," .. self:optionalWhitespace()
						end
						if arg.kind == AstKind.VarargExpression then
							code = code .. "..."
						else
							code = code .. arg.scope:getVariableName(arg.id)
						end
					end
					code = code .. ")"
					local bodyCode = self:unparseBlock(statement.body, tabbing)
					code = code
						.. self:newline(false)
						.. bodyCode
						.. self:newline(false)
						.. self:whitespaceIfNeeded2(bodyCode, self:tabs(tabbing, true))
						.. "end"
				elseif statement.kind == AstKind.LocalFunctionDeclaration then
					local funcname = statement.scope:getVariableName(statement.id)
					code = "local" .. self:whitespace() .. "function" .. self:whitespace() .. funcname .. "("
					for i, arg in ipairs(statement.args) do
						if i > 1 then
							code = code .. "," .. self:optionalWhitespace()
						end
						if arg.kind == AstKind.VarargExpression then
							code = code .. "..."
						else
							code = code .. arg.scope:getVariableName(arg.id)
						end
					end
					code = code .. ")"
					local bodyCode = self:unparseBlock(statement.body, tabbing)
					code = code
						.. self:newline(false)
						.. bodyCode
						.. self:newline(false)
						.. self:whitespaceIfNeeded2(bodyCode, self:tabs(tabbing, true))
						.. "end"
				elseif statement.kind == AstKind.LocalVariableDeclaration then
					code = "local" .. self:whitespace()
					for i, id in ipairs(statement.ids) do
						if i > 1 then
							code = code .. "," .. self:optionalWhitespace()
						end
						code = code .. statement.scope:getVariableName(id)
					end
					if #statement.expressions > 0 then
						code = code .. self:optionalWhitespace() .. "=" .. self:optionalWhitespace()
						for i, expr in ipairs(statement.expressions) do
							if i > 1 then
								code = code .. "," .. self:optionalWhitespace()
							end
							code = code .. self:unparseExpression(expr, tabbing + 1)
						end
					end
				elseif statement.kind == AstKind.FunctionCallStatement then
					if
						not (
							statement.base.kind == AstKind.IndexExpression
							or statement.base.kind == AstKind.VariableExpression
						)
					then
						code = "(" .. self:unparseExpression(statement.base, tabbing) .. ")"
					else
						code = self:unparseExpression(statement.base, tabbing)
					end
					code = code .. "("
					for i, arg in ipairs(statement.args) do
						if i > 1 then
							code = code .. "," .. self:optionalWhitespace()
						end
						code = code .. self:unparseExpression(arg, tabbing)
					end
					code = code .. ")"
				elseif statement.kind == AstKind.PassSelfFunctionCallStatement then
					if
						not (
							statement.base.kind == AstKind.IndexExpression
							or statement.base.kind == AstKind.VariableExpression
						)
					then
						code = "(" .. self:unparseExpression(statement.base, tabbing) .. ")"
					else
						code = self:unparseExpression(statement.base, tabbing)
					end
					code = code .. ":" .. statement.passSelfFunctionName
					code = code .. "("
					for i, arg in ipairs(statement.args) do
						if i > 1 then
							code = code .. "," .. self:optionalWhitespace()
						end
						code = code .. self:unparseExpression(arg, tabbing)
					end
					code = code .. ")"
				elseif statement.kind == AstKind.AssignmentStatement then
					for i, primary_expr in ipairs(statement.lhs) do
						if i > 1 then
							code = code .. "," .. self:optionalWhitespace()
						end
						code = code .. self:unparseExpression(primary_expr, tabbing)
					end
					code = code .. self:optionalWhitespace() .. "=" .. self:optionalWhitespace()
					for i, expr in ipairs(statement.rhs) do
						if i > 1 then
							code = code .. "," .. self:optionalWhitespace()
						end
						code = code .. self:unparseExpression(expr, tabbing + 1)
					end
				elseif statement.kind == AstKind.ReturnStatement then
					code = "return"
					if #statement.args > 0 then
						local exprcode = self:unparseExpression(statement.args[1], tabbing)
						code = code .. self:whitespaceIfNeeded(exprcode) .. exprcode
						for i = 2, #statement.args, 1 do
							exprcode = self:unparseExpression(statement.args[i], tabbing)
							code = code .. "," .. self:optionalWhitespace() .. exprcode
						end
					end
				elseif self.luaVersion == LuaVersion.LuaU then
					local compoundOperators = {
						[AstKind.CompoundAddStatement] = "+=",
						[AstKind.CompoundSubStatement] = "-=",
						[AstKind.CompoundMulStatement] = "*=",
						[AstKind.CompoundDivStatement] = "/=",
						[AstKind.CompoundModStatement] = "%=",
						[AstKind.CompoundPowStatement] = "^=",
						[AstKind.CompoundConcatStatement] = "..=",
					}
					local operator = compoundOperators[statement.kind]
					if operator then
						code = code
							.. self:unparseExpression(statement.lhs, tabbing)
							.. self:optionalWhitespace()
							.. operator
							.. self:optionalWhitespace()
							.. self:unparseExpression(statement.rhs, tabbing)
					else
						logger:error(
							string.format(
								'"%s" is not a valid unparseable statement in %s!',
								statement.kind,
								self.luaVersion
							)
						)
					end
				end
				return self:tabs(tabbing, false) .. code
			end
			local function randomTrueNode()
				local op = math.random(1, 2)
				if op == 1 then
					local a = math.random(1, 9)
					local b = math.random(0, a - 1)
					return tostring(a) .. ">" .. tostring(b)
				else
					local a = math.random(1, 9)
					local b = math.random(0, a - 1)
					return tostring(b) .. "<" .. tostring(a)
				end
			end
			local function randomFalseNode()
				local op = math.random(1, 2)
				if op == 1 then
					local a = math.random(1, 9)
					local b = math.random(0, a - 1)
					return tostring(b) .. ">" .. tostring(a)
				else
					local a = math.random(1, 9)
					local b = math.random(0, a - 1)
					return tostring(a) .. "<" .. tostring(b)
				end
			end
			function Unparser:unparseExpression(expression, tabbing)
				local code = ""
				if expression.kind == AstKind.BooleanExpression then
					if expression.value then
						return "true"
					else
						return "false"
					end
				end
				if expression.kind == AstKind.NumberExpression then
					local v = expression.value
					local function addUnderscores(s)
						if #s <= 2 then
							return s
						end
						local out = s:sub(1, 1)
						for ci = 2, #s do
							if ci < #s and math.random(4) == 1 then
								out = out .. "_"
							end
							out = out .. s:sub(ci, ci)
						end
						return out
					end
					local function toBin(n)
						if n == 0 then
							return "0"
						end
						local bits = ""
						while n > 0 do
							bits = ((n % 2 == 1) and "1" or "0") .. bits
							n = math.floor(n / 2)
						end
						return bits
					end
					local str
					local isInt = (math.floor(v) == v)
					local isU32 = (isInt and v >= 0 and v <= 0xFFFFFFFF)
					local isSmall = (isInt and v >= 0 and v < 2 ^ 24)
					if v == math.huge then
						str = "2e308"
					elseif v == -math.huge then
						str = "-2e308"
					elseif isU32 then
						local style = math.random(3)
						if style == 1 then
							str = string.format("0X%X", v)
						elseif style == 2 then
							str = string.format("0x%x", v)
						else
							str = tostring(v)
						end
					elseif isInt and v < 0 and v >= -0x7FFFFFFF then
						if math.random(2) == 1 then
							str = string.format("-0x%x", -v)
						else
							str = tostring(v)
						end
					else
						str = tostring(v)
					end
					if str:sub(1, 2) == "0." then
						str = str:sub(2)
					end
					return str
				end
				if expression.kind == AstKind.VariableExpression or expression.kind == AstKind.AssignmentVariable then
					return expression.scope:getVariableName(expression.id)
				end
				if expression.kind == AstKind.StringExpression then
					return '"' .. escapeString(expression.value) .. '"'
				end
				if expression.kind == AstKind.NilExpression then
					return "nil"
				end
				if expression.kind == AstKind.VarargExpression then
					return "..."
				end
				local k = AstKind.OrExpression
				if expression.kind == k then
					local lhs = self:unparseExpression(expression.lhs, tabbing)
					local rhs = self:unparseExpression(expression.rhs, tabbing)
					return lhs .. self:whitespaceIfNeeded2(lhs) .. "or" .. self:whitespaceIfNeeded(rhs) .. rhs
				end
				k = AstKind.AndExpression
				if expression.kind == k then
					local lhs = self:unparseExpression(expression.lhs, tabbing)
					if Ast.astKindExpressionToNumber(expression.lhs.kind) >= Ast.astKindExpressionToNumber(k) then
						lhs = "(" .. lhs .. ")"
					end
					local rhs = self:unparseExpression(expression.rhs, tabbing)
					if Ast.astKindExpressionToNumber(expression.rhs.kind) >= Ast.astKindExpressionToNumber(k) then
						rhs = "(" .. rhs .. ")"
					end
					return lhs .. self:whitespaceIfNeeded2(lhs) .. "and" .. self:whitespaceIfNeeded(rhs) .. rhs
				end
				k = AstKind.LessThanExpression
				if expression.kind == k then
					local lhs = self:unparseExpression(expression.lhs, tabbing)
					if Ast.astKindExpressionToNumber(expression.lhs.kind) >= Ast.astKindExpressionToNumber(k) then
						lhs = "(" .. lhs .. ")"
					end
					local rhs = self:unparseExpression(expression.rhs, tabbing)
					if Ast.astKindExpressionToNumber(expression.rhs.kind) >= Ast.astKindExpressionToNumber(k) then
						rhs = "(" .. rhs .. ")"
					end
					return lhs .. self:optionalWhitespace() .. "<" .. self:optionalWhitespace() .. rhs
				end
				k = AstKind.GreaterThanExpression
				if expression.kind == k then
					local lhs = self:unparseExpression(expression.lhs, tabbing)
					if Ast.astKindExpressionToNumber(expression.lhs.kind) >= Ast.astKindExpressionToNumber(k) then
						lhs = "(" .. lhs .. ")"
					end
					local rhs = self:unparseExpression(expression.rhs, tabbing)
					if Ast.astKindExpressionToNumber(expression.rhs.kind) >= Ast.astKindExpressionToNumber(k) then
						rhs = "(" .. rhs .. ")"
					end
					return lhs .. self:optionalWhitespace() .. ">" .. self:optionalWhitespace() .. rhs
				end
				k = AstKind.LessThanOrEqualsExpression
				if expression.kind == k then
					local lhs = self:unparseExpression(expression.lhs, tabbing)
					if Ast.astKindExpressionToNumber(expression.lhs.kind) >= Ast.astKindExpressionToNumber(k) then
						lhs = "(" .. lhs .. ")"
					end
					local rhs = self:unparseExpression(expression.rhs, tabbing)
					if Ast.astKindExpressionToNumber(expression.rhs.kind) >= Ast.astKindExpressionToNumber(k) then
						rhs = "(" .. rhs .. ")"
					end
					return lhs .. self:optionalWhitespace() .. "<=" .. self:optionalWhitespace() .. rhs
				end
				k = AstKind.GreaterThanOrEqualsExpression
				if expression.kind == k then
					local lhs = self:unparseExpression(expression.lhs, tabbing)
					if Ast.astKindExpressionToNumber(expression.lhs.kind) >= Ast.astKindExpressionToNumber(k) then
						lhs = "(" .. lhs .. ")"
					end
					local rhs = self:unparseExpression(expression.rhs, tabbing)
					if Ast.astKindExpressionToNumber(expression.rhs.kind) >= Ast.astKindExpressionToNumber(k) then
						rhs = "(" .. rhs .. ")"
					end
					return lhs .. self:optionalWhitespace() .. ">=" .. self:optionalWhitespace() .. rhs
				end
				k = AstKind.NotEqualsExpression
				if expression.kind == k then
					local lhs = self:unparseExpression(expression.lhs, tabbing)
					if Ast.astKindExpressionToNumber(expression.lhs.kind) >= Ast.astKindExpressionToNumber(k) then
						lhs = "(" .. lhs .. ")"
					end
					local rhs = self:unparseExpression(expression.rhs, tabbing)
					if Ast.astKindExpressionToNumber(expression.rhs.kind) >= Ast.astKindExpressionToNumber(k) then
						rhs = "(" .. rhs .. ")"
					end
					return lhs .. self:optionalWhitespace() .. "~=" .. self:optionalWhitespace() .. rhs
				end
				k = AstKind.EqualsExpression
				if expression.kind == k then
					local lhs = self:unparseExpression(expression.lhs, tabbing)
					if Ast.astKindExpressionToNumber(expression.lhs.kind) >= Ast.astKindExpressionToNumber(k) then
						lhs = "(" .. lhs .. ")"
					end
					local rhs = self:unparseExpression(expression.rhs, tabbing)
					if Ast.astKindExpressionToNumber(expression.rhs.kind) >= Ast.astKindExpressionToNumber(k) then
						rhs = "(" .. rhs .. ")"
					end
					return lhs .. self:optionalWhitespace() .. "==" .. self:optionalWhitespace() .. rhs
				end
				k = AstKind.StrCatExpression
				if expression.kind == k then
					local lhs = self:unparseExpression(expression.lhs, tabbing)
					if Ast.astKindExpressionToNumber(expression.lhs.kind) >= Ast.astKindExpressionToNumber(k) then
						lhs = "(" .. lhs .. ")"
					end
					local rhs = self:unparseExpression(expression.rhs, tabbing)
					if Ast.astKindExpressionToNumber(expression.rhs.kind) >= Ast.astKindExpressionToNumber(k) then
						rhs = "(" .. rhs .. ")"
					end
					if self.numberCharsLookup[string.sub(lhs, #lhs, #lhs)] then
						lhs = lhs .. " "
					end
					return lhs .. self:optionalWhitespace() .. ".." .. self:optionalWhitespace() .. rhs
				end
				k = AstKind.AddExpression
				if expression.kind == k then
					local lhs = self:unparseExpression(expression.lhs, tabbing)
					if Ast.astKindExpressionToNumber(expression.lhs.kind) >= Ast.astKindExpressionToNumber(k) then
						lhs = "(" .. lhs .. ")"
					end
					local rhs = self:unparseExpression(expression.rhs, tabbing)
					if Ast.astKindExpressionToNumber(expression.rhs.kind) >= Ast.astKindExpressionToNumber(k) then
						rhs = "(" .. rhs .. ")"
					end
					return lhs .. self:optionalWhitespace() .. "+" .. self:optionalWhitespace() .. rhs
				end
				k = AstKind.SubExpression
				if expression.kind == k then
					local lhs = self:unparseExpression(expression.lhs, tabbing)
					if Ast.astKindExpressionToNumber(expression.lhs.kind) >= Ast.astKindExpressionToNumber(k) then
						lhs = "(" .. lhs .. ")"
					end
					local rhs = self:unparseExpression(expression.rhs, tabbing)
					if Ast.astKindExpressionToNumber(expression.rhs.kind) >= Ast.astKindExpressionToNumber(k) then
						rhs = "(" .. rhs .. ")"
					end
					if string.sub(rhs, 1, 1) == "-" then
						rhs = "(" .. rhs .. ")"
					end
					return lhs .. self:optionalWhitespace() .. "-" .. self:optionalWhitespace() .. rhs
				end
				k = AstKind.MulExpression
				if expression.kind == k then
					local lhs = self:unparseExpression(expression.lhs, tabbing)
					if Ast.astKindExpressionToNumber(expression.lhs.kind) >= Ast.astKindExpressionToNumber(k) then
						lhs = "(" .. lhs .. ")"
					end
					local rhs = self:unparseExpression(expression.rhs, tabbing)
					if Ast.astKindExpressionToNumber(expression.rhs.kind) >= Ast.astKindExpressionToNumber(k) then
						rhs = "(" .. rhs .. ")"
					end
					return lhs .. self:optionalWhitespace() .. "*" .. self:optionalWhitespace() .. rhs
				end
				k = AstKind.DivExpression
				if expression.kind == k then
					local lhs = self:unparseExpression(expression.lhs, tabbing)
					if Ast.astKindExpressionToNumber(expression.lhs.kind) >= Ast.astKindExpressionToNumber(k) then
						lhs = "(" .. lhs .. ")"
					end
					local rhs = self:unparseExpression(expression.rhs, tabbing)
					if Ast.astKindExpressionToNumber(expression.rhs.kind) >= Ast.astKindExpressionToNumber(k) then
						rhs = "(" .. rhs .. ")"
					end
					return lhs .. self:optionalWhitespace() .. "/" .. self:optionalWhitespace() .. rhs
				end
				k = AstKind.ModExpression
				if expression.kind == k then
					local lhs = self:unparseExpression(expression.lhs, tabbing)
					if Ast.astKindExpressionToNumber(expression.lhs.kind) >= Ast.astKindExpressionToNumber(k) then
						lhs = "(" .. lhs .. ")"
					end
					local rhs = self:unparseExpression(expression.rhs, tabbing)
					if Ast.astKindExpressionToNumber(expression.rhs.kind) >= Ast.astKindExpressionToNumber(k) then
						rhs = "(" .. rhs .. ")"
					end
					return lhs .. self:optionalWhitespace() .. "%" .. self:optionalWhitespace() .. rhs
				end
				k = AstKind.PowExpression
				if expression.kind == k then
					local lhs = self:unparseExpression(expression.lhs, tabbing)
					if Ast.astKindExpressionToNumber(expression.lhs.kind) >= Ast.astKindExpressionToNumber(k) then
						lhs = "(" .. lhs .. ")"
					end
					local rhs = self:unparseExpression(expression.rhs, tabbing)
					if Ast.astKindExpressionToNumber(expression.rhs.kind) >= Ast.astKindExpressionToNumber(k) then
						rhs = "(" .. rhs .. ")"
					end
					return lhs .. self:optionalWhitespace() .. "^" .. self:optionalWhitespace() .. rhs
				end
				k = AstKind.NotExpression
				if expression.kind == k then
					local rhs = self:unparseExpression(expression.rhs, tabbing)
					if Ast.astKindExpressionToNumber(expression.rhs.kind) >= Ast.astKindExpressionToNumber(k) then
						rhs = "(" .. rhs .. ")"
					end
					return "not" .. self:whitespaceIfNeeded(rhs) .. rhs
				end
				k = AstKind.NegateExpression
				if expression.kind == k then
					local rhs = self:unparseExpression(expression.rhs, tabbing)
					if Ast.astKindExpressionToNumber(expression.rhs.kind) >= Ast.astKindExpressionToNumber(k) then
						rhs = "(" .. rhs .. ")"
					end
					if string.sub(rhs, 1, 1) == "-" then
						rhs = "(" .. rhs .. ")"
					end
					return "-" .. rhs
				end
				k = AstKind.LenExpression
				if expression.kind == k then
					local rhs = self:unparseExpression(expression.rhs, tabbing)
					if Ast.astKindExpressionToNumber(expression.rhs.kind) >= Ast.astKindExpressionToNumber(k) then
						rhs = "(" .. rhs .. ")"
					end
					return "#" .. rhs
				end
				k = AstKind.IndexExpression
				if expression.kind == k or expression.kind == AstKind.AssignmentIndexing then
					local base = self:unparseExpression(expression.base, tabbing)
					if
						expression.base.kind == AstKind.VarargExpression
						or Ast.astKindExpressionToNumber(expression.base.kind) > Ast.astKindExpressionToNumber(k)
					then
						base = "(" .. base .. ")"
					end
					if
						expression.index.kind == AstKind.StringExpression
						and self:isValidIdentifier(expression.index.value)
					then
						return base .. "." .. expression.index.value
					end
					local index = self:unparseExpression(expression.index, tabbing)
					return base .. "[" .. index .. "]"
				end
				k = AstKind.FunctionCallExpression
				if expression.kind == k then
					if
						not (
							expression.base.kind == AstKind.IndexExpression
							or expression.base.kind == AstKind.VariableExpression
						)
					then
						code = "(" .. self:unparseExpression(expression.base, tabbing) .. ")"
					else
						code = self:unparseExpression(expression.base, tabbing)
					end
					code = code .. "("
					for i, arg in ipairs(expression.args) do
						if i > 1 then
							code = code .. "," .. self:optionalWhitespace()
						end
						code = code .. self:unparseExpression(arg, tabbing)
					end
					code = code .. ")"
					return code
				end
				k = AstKind.PassSelfFunctionCallExpression
				if expression.kind == k then
					if
						not (
							expression.base.kind == AstKind.IndexExpression
							or expression.base.kind == AstKind.VariableExpression
						)
					then
						code = "(" .. self:unparseExpression(expression.base, tabbing) .. ")"
					else
						code = self:unparseExpression(expression.base, tabbing)
					end
					code = code .. ":" .. expression.passSelfFunctionName
					code = code .. "("
					for i, arg in ipairs(expression.args) do
						if i > 1 then
							code = code .. "," .. self:optionalWhitespace()
						end
						code = code .. self:unparseExpression(arg, tabbing)
					end
					code = code .. ")"
					return code
				end
				k = AstKind.FunctionLiteralExpression
				if expression.kind == k then
					code = "function" .. "("
					for i, arg in ipairs(expression.args) do
						if i > 1 then
							code = code .. "," .. self:optionalWhitespace()
						end
						if arg.kind == AstKind.VarargExpression then
							code = code .. "..."
						else
							code = code .. arg.scope:getVariableName(arg.id)
						end
					end
					code = code .. ")"
					local bodyCode = self:unparseBlock(expression.body, tabbing)
					code = code
						.. self:newline(false)
						.. bodyCode
						.. self:newline(false)
						.. self:whitespaceIfNeeded2(bodyCode, self:tabs(tabbing, true))
						.. "end"
					return code
				end
				k = AstKind.TableConstructorExpression
				if expression.kind == k then
					if #expression.entries == 0 then
						return "{}"
					end
					local inlineTable = #expression.entries <= 3
					local tableTabbing = tabbing + 1
					code = "{"
					if inlineTable then
						code = code .. self:optionalWhitespace()
					else
						code = code .. self:optionalWhitespace(self:newline() .. self:tabs(tableTabbing))
					end
					local p = false
					for i, entry in ipairs(expression.entries) do
						p = true
						local sep = self.prettyPrint and "," or (math.random(1, 2) == 1 and "," or ";")
						if i > 1 and not inlineTable then
							code = code .. sep .. self:optionalWhitespace(self:newline() .. self:tabs(tableTabbing))
						elseif i > 1 then
							code = code .. sep .. self:optionalWhitespace()
						end
						if entry.kind == AstKind.KeyedTableEntry then
							if
								entry.key.kind == AstKind.StringExpression and self:isValidIdentifier(entry.key.value)
							then
								code = code .. entry.key.value
							else
								code = code .. "[" .. self:unparseExpression(entry.key, tableTabbing) .. "]"
							end
							code = code
								.. self:optionalWhitespace()
								.. "="
								.. self:optionalWhitespace()
								.. self:unparseExpression(entry.value, tableTabbing)
						else
							code = code .. self:unparseExpression(entry.value, tableTabbing)
						end
					end
					if inlineTable then
						return code .. self:optionalWhitespace() .. "}"
					end
					return code
						.. self:optionalWhitespace((p and "," or "") .. self:newline() .. self:tabs(tabbing))
						.. "}"
				end
				if self.luaVersion == LuaVersion.LuaU then
					k = AstKind.IfElseExpression
					if expression.kind == k then
						code = "if "
						code = code .. self:unparseExpression(expression.condition)
						code = code .. " then "
						code = code .. self:unparseExpression(expression.true_value)
						code = code .. " else "
						code = code .. self:unparseExpression(expression.false_value)
						return code
					end
				end
				logger:error(string.format('"%s" is not a valid unparseable expression', expression.kind))
			end
			return Unparser
		end
		function _ZukOfficial.k()
			local v = _ZukOfficial.cache.k
			if not v then
				v = { c = __modImpl() }
				_ZukOfficial.cache.k = v
			end
			return v.c
		end
	end
	do
		local function __modImpl()
			local util = _ZukOfficial.f()
			local BASE_CHARS = {
				"e",
				"p",
				"W",
				"t",
				"X",
				"N",
				"y",
				"H",
				"Q",
				"l",
				"M",
				"d",
				"z",
				"h",
				"A",
				"b",
				"c",
				"f",
				"g",
				"i",
				"j",
				"k",
				"m",
				"n",
				"o",
				"q",
				"r",
				"s",
				"u",
				"v",
				"w",
				"x",
				"G",
				"R",
				"V",
				"Z",
				"S",
				"T",
				"U",
				"K",
				"L",
				"_",
				"B",
				"C",
				"D",
				"E",
				"F",
				"I",
				"J",
				"O",
				"P",
				"Y",
			}
			local SUFFIXES = {
				"o",
				"7",
				"_",
				"0",
				"i",
				"a",
				"O",
				"r",
				"c",
				"p",
				"n",
				"k",
				"",
				"",
				"",
				"",
				"",
				"",
				"",
			}
			local DIGIT_SUFFIXES = { "7", "0", "_", "4", "3", "6", "9" }
			local shuffledBase = {}
			local shuffledSuffix = {}
			local shuffledDigit = {}
			local function generateName(id)
				local bc = #shuffledBase > 0 and shuffledBase or BASE_CHARS
				local sc = #shuffledSuffix > 0 and shuffledSuffix or SUFFIXES
				local dc = #shuffledDigit > 0 and shuffledDigit or DIGIT_SUFFIXES
				if id % 20 == 0 then
					return bc[(id % #bc) + 1]
				end
				local primary = bc[(id % #bc) + 1]
				local r = (id * 6271 + 1337) % 4
				if r == 0 then
					primary = primary:upper()
				elseif r == 1 then
					primary = primary:lower()
				end
				local stype = id % 5
				local suffix
				if stype == 0 then
					suffix = sc[((id * 31) % #sc) + 1]
				elseif stype == 1 then
					suffix = dc[((id * 17) % #dc) + 1]
				elseif stype == 2 then
					local s = bc[((id * 13 + 7) % #bc) + 1]:upper()
					suffix = s
				elseif stype == 3 then
					suffix = ""
				else
					local s = bc[((id * 7 + 3) % #bc) + 1]
					local flip = (id * 11) % 3
					if flip == 0 then
						s = s:upper()
					end
					suffix = s
				end
				return primary .. suffix
			end
			local function prepare(ast)
				for i = 1, #BASE_CHARS do
					shuffledBase[i] = BASE_CHARS[i]
				end
				for i = 1, #SUFFIXES do
					shuffledSuffix[i] = SUFFIXES[i]
				end
				for i = 1, #DIGIT_SUFFIXES do
					shuffledDigit[i] = DIGIT_SUFFIXES[i]
				end
				util.shuffle(shuffledBase)
				util.shuffle(shuffledSuffix)
				util.shuffle(shuffledDigit)
			end
			return {
				generateName = generateName,
				prepare = prepare,
			}
		end
		function _ZukOfficial.l()
			local v = _ZukOfficial.cache.l
			if not v then
				v = { c = __modImpl() }
				_ZukOfficial.cache.l = v
			end
			return v.c
		end
	end
	do
		local function __modImpl()
			local bit32 = _ZukOfficial.e().bit32
			local band = bit32.band
			local bxor = bit32.bxor
			local lshift = bit32.lshift
			local rshift = bit32.rshift
			local MIN_LEN = 4
			local MAX_LEN = 8
			local ALPHA = {}
			local ALNUM = {}
			local DIGITS = {}
			do
				for c = 65, 90 do
					local ch = string.char(c)
					ALPHA[#ALPHA + 1] = ch
					ALNUM[#ALNUM + 1] = ch
				end
				for c = 97, 122 do
					local ch = string.char(c)
					ALPHA[#ALPHA + 1] = ch
					ALNUM[#ALNUM + 1] = ch
				end
				for c = 48, 57 do
					local ch = string.char(c)
					ALNUM[#ALNUM + 1] = ch
					DIGITS[#DIGITS + 1] = ch
				end
			end
			local seed = 0
			local saltA = 0
			local saltB = 0
			local usedNames = {}
			local function lcg(n, salt)
				n = band(n, 0xFFFFFFFF)
				n = bxor(n, lshift(n, 13))
				n = bxor(n, rshift(n, 7))
				n = bxor(n, lshift(n, 17))
				return band(n * 1664525 + salt, 0xFFFFFFFF)
			end
			local function _buildName(id)
				local s1 = lcg(id, seed + saltA)
				local s2 = lcg(bxor(s1, saltB), seed + id)
				local s3 = lcg(s2 + saltA, id * saltB + 1)
				local len = MIN_LEN + (s1 % (MAX_LEN - MIN_LEN + 1))
				local name = "_"
				name = name .. ALPHA[(s2 % #ALPHA) + 1]
				for i = 1, len - 1 do
					local h = lcg(s3 + i * 31 + id, bxor(saltA, i * saltB + seed))
					local pool
					if h % 12 < 5 then
						pool = DIGITS
					elseif h % 12 < 10 then
						pool = ALNUM
					else
						pool = ALPHA
					end
					name = name .. pool[(h % #pool) + 1]
				end
				return name
			end
			local function generateName(id, scope, originalName)
				local name
				local attempt = id
				local tries = 0
				repeat
					name = _buildName(attempt)
					attempt = attempt + 0x8000
					tries = tries + 1
					if tries > 64 then
						name = "_v" .. tostring(id) .. tostring(attempt % 0xFFFF)
						break
					end
				until not usedNames[name]
				usedNames[name] = true
				return name
			end
			local function prepare(ast)
				local t = (os.time() or 0) % 0x7FFFFFFF
				local c = math.floor((os.clock() * 1e6)) % 0x7FFFFFFF
				seed = (t * 1664525 + c * 22695477 + math.random(0, 0xFFFF)) % 0xFFFFFF
				saltA = (math.random(1, 0xFFFF) * 2) - 1
				saltB = math.random(0x1000, 0xFFFF)
				usedNames = {}
			end
			return {
				generateName = generateName,
				prepare = prepare,
			}
		end
		function _ZukOfficial.l2()
			local v = _ZukOfficial.cache.l2
			if not v then
				v = { c = __modImpl() }
				_ZukOfficial.cache.l2 = v
			end
			return v.c
		end
	end
	do
		local function __modImpl()
			local function shuffle(t)
				local n = #t
				for i = n, 2, -1 do
					local j = math.random(1, i)
					t[i], t[j] = t[j], t[i]
				end
			end
			local function buildPool(numLimit)
				local letters = {}
				for i = 0, 25 do
					letters[i + 1] = string.char(string.byte("a") + i)
				end
				shuffle(letters)
				local pool = {}
				for _, letter in ipairs(letters) do
					local nums = {}
					for n = 1, numLimit do nums[n] = n end
					shuffle(nums)
					for _, n in ipairs(nums) do
						pool[#pool + 1] = letter .. n
					end
				end
				return pool
			end
			local function makeAN(numLimit, ovStart)
				local pool     = {}
				local poolIdx  = 1
				local ovLetter = 0
				local ovCount  = ovStart
				local function generateName()
					if poolIdx <= #pool then
						local name = pool[poolIdx]
						poolIdx = poolIdx + 1
						return name
					else
						local letter = string.char(string.byte("a") + (ovLetter % 26))
						local name   = letter .. ovCount
						ovLetter = ovLetter + 1
						if ovLetter % 26 == 0 then
							ovCount = ovCount + 1
						end
						return name
					end
				end
				local function prepare()
					pool     = buildPool(numLimit)
					poolIdx  = 1
					ovLetter = 0
					ovCount  = ovStart
				end
				return { generateName = generateName, prepare = prepare }
			end
			return {
				AN      = makeAN(100, 101),
				ANLight = makeAN(20, 21),
			}
		end
		function _ZukOfficial.l3()
			local v = _ZukOfficial.cache.l3
			if not v then
				v = { c = __modImpl() }
				_ZukOfficial.cache.l3 = v
			end
			return v.c
		end
	end
	do
		local function __modImpl()
			return {
				Chaotic  = _ZukOfficial.l(),
				Dynamic  = _ZukOfficial.l2(),
				Mangled  = _ZukOfficial.l(),
				AN       = _ZukOfficial.l3().AN,
				ANLight  = _ZukOfficial.l3().ANLight,
			}
		end
		function _ZukOfficial.m()
			local v = _ZukOfficial.cache.m
			if not v then
				v = { c = __modImpl() }
				_ZukOfficial.cache.m = v
			end
			return v.c
		end
	end
	do
		local function __modImpl()
			local logger = _ZukOfficial.d()
			local util = _ZukOfficial.f()
			local lookupify = util.lookupify
			local Step = {}
			Step.SettingsDescriptor = {}
			function Step:new(settings)
				local instance = {}
				setmetatable(instance, self)
				self.__index = self
				if type(settings) ~= "table" then
					settings = {}
				end
				for key, data in pairs(self.SettingsDescriptor) do
					if settings[key] == nil then
						if data.default == nil then
							logger:error(
								string.format('The Setting "%s" was not provided for the Step "%s"', key, self.Name)
							)
						end
						instance[key] = data.default
					elseif data.type == "enum" then
						local lookup = lookupify(data.values)
						if not lookup[settings[key]] then
							logger:error(
								string.format(
									'Invalid value for the Setting "%s" of the Step "%s". It must be one of the following: %s',
									key,
									self.Name,
									table.concat(data, ", ")
								)
							)
						end
						instance[key] = settings[key]
					elseif type(settings[key]) ~= data.type then
						logger:error(
							string.format(
								'Invalid value for the Setting "%s" of the Step "%s". It must be a %s',
								key,
								self.Name,
								data.type
							)
						)
					else
						if data.min then
							if settings[key] < data.min then
								logger:error(
									string.format(
										'Invalid value for the Setting "%s" of the Step "%s". It must be at least %d',
										key,
										self.Name,
										data.min
									)
								)
							end
						end
						if data.max then
							if settings[key] > data.max then
								logger:error(
									string.format(
										'Invalid value for the Setting "%s" of the Step "%s". The biggest allowed value is %d',
										key,
										self.Name,
										data.min
									)
								)
							end
						end
						instance[key] = settings[key]
					end
				end
				instance:init()
				return instance
			end
			function Step:init()
				logger:error("Abstract Steps cannot be Created")
			end
			function Step:extend()
				local ext = {}
				setmetatable(ext, self)
				self.__index = self
				return ext
			end
			function Step:apply(ast, pipeline)
				logger:error("Abstract Steps cannot be Applied")
			end
			Step.Name = "Abstract Step"
			Step.Description = "Abstract Step"
			return Step
		end
		function _ZukOfficial.n()
			local v = _ZukOfficial.cache.n
			if not v then
				v = { c = __modImpl() }
				_ZukOfficial.cache.n = v
			end
			return v.c
		end
	end
	do
		local function __modImpl()
			local Step = _ZukOfficial.n()
			local Ast = _ZukOfficial.b()
			local Scope = _ZukOfficial.i()
			local AstKind = Ast.AstKind
			local InvertedExecution = Step:extend()
			InvertedExecution.Name = "Inverted Execution"
			InvertedExecution.Description =
				"Physically flips the script so the last chunk appears first in the file; logical execution order is preserved via a bottom-anchored state machine dispatcher."
			InvertedExecution.SettingsDescriptor = {
				ChunkSize = {
					type = "number",
					default = 1,
					min = 1,
					max = 20,
				},
				RandomiseIds = {
					type = "boolean",
					default = true,
				},
				JunkChunks = {
					type = "number",
					default = 3,
					min = 0,
					max = 20,
				},
			}
			function InvertedExecution:init(settings) end
			local usedIds = {}
			local function freshId(randomise)
				local id
				repeat
					if randomise then
						id = math.random(100000, 999999)
					else
						id = math.random(10000, 99999)
					end
				until not usedIds[id]
				usedIds[id] = true
				return id
			end
			local function resetIds()
				usedIds = {}
			end
			local function makeHandlerFunc(innerStmts, nextId, parentScope)
				local funcScope = Scope:new(parentScope)
				local doScope = Scope:new(funcScope)
				local retId = doScope:addVariable()
				local doBody = {}
				for _, s in ipairs(innerStmts) do
					table.insert(doBody, s)
				end
				table.insert(doBody, Ast.LocalVariableDeclaration(doScope, { retId }, { Ast.NumberExpression(nextId) }))
				table.insert(doBody, Ast.ReturnStatement({ Ast.VariableExpression(doScope, retId) }))
				local funcBody = Ast.Block({
					Ast.DoStatement(Ast.Block(doBody, doScope)),
				}, funcScope)
				return Ast.FunctionLiteralExpression({ Ast.VarargExpression() }, funcBody)
			end
			function InvertedExecution:apply(ast)
				local statements = ast.body.statements
				if not statements or #statements == 0 then
					return
				end
				resetIds()
				local chunkSize = self.ChunkSize
				local randomise = self.RandomiseIds
				local junkCount = self.JunkChunks
				local terminate = 0
				local rootScope = ast.body.scope
				local hoistedIds = {}
				local hoistedOrder = {}
				for _, stmt in ipairs(statements) do
					if stmt.kind == AstKind.LocalVariableDeclaration then
						for _, id in ipairs(stmt.ids) do
							if not hoistedIds[id] then
								hoistedIds[id] = true
								table.insert(hoistedOrder, id)
							end
						end
					elseif stmt.kind == AstKind.LocalFunctionDeclaration then
						local id = stmt.id
						if not hoistedIds[id] then
							hoistedIds[id] = true
							table.insert(hoistedOrder, id)
						end
					end
				end
				local function rewriteLocals(stmtList)
					local out = {}
					for _, stmt in ipairs(stmtList) do
						if stmt.kind == AstKind.LocalVariableDeclaration and #stmt.ids > 0 then
							local lhs = {}
							for _, id in ipairs(stmt.ids) do
								table.insert(lhs, Ast.AssignmentVariable(rootScope, id))
							end
							local rhs = stmt.expressions or {}
							table.insert(out, Ast.AssignmentStatement(lhs, rhs))
						elseif stmt.kind == AstKind.LocalFunctionDeclaration then
							local lhs = { Ast.AssignmentVariable(rootScope, stmt.id) }
							local rhs = { Ast.FunctionLiteralExpression(stmt.args, stmt.body) }
							table.insert(out, Ast.AssignmentStatement(lhs, rhs))
						else
							table.insert(out, stmt)
						end
					end
					return out
				end
				local chunks = {}
				local cur = {}
				for i, stmt in ipairs(statements) do
					table.insert(cur, stmt)
					if #cur >= chunkSize or i == #statements then
						table.insert(chunks, rewriteLocals(cur))
						cur = {}
					end
				end
				local n = #chunks
				local realIds = {}
				for i = 1, n do
					realIds[i] = freshId(randomise)
				end
				local tableEntries = {}
				local function addJunkEntry()
					local jId = freshId(randomise)
					local func = makeHandlerFunc({}, terminate, rootScope)
					table.insert(tableEntries, Ast.KeyedTableEntry(Ast.NumberExpression(jId), func))
				end
				local junkBudget = junkCount
				local function maybeJunk()
					if junkBudget > 0 and math.random() < 0.55 then
						addJunkEntry()
						junkBudget = junkBudget - 1
					end
				end
				for i = n, 1, -1 do
					maybeJunk()
					local nextId = realIds[i + 1] or terminate
					local func = makeHandlerFunc(chunks[i], nextId, rootScope)
					table.insert(tableEntries, Ast.KeyedTableEntry(Ast.NumberExpression(realIds[i]), func))
				end
				while junkBudget > 0 do
					addJunkEntry()
					junkBudget = junkBudget - 1
				end
				local function rvar(prefix)
					local s = ""
					local charset = "abcdefghijklmnopqrstuvwxyz"
					for _ = 1, 7 do
						local idx = math.random(1, #charset)
						s = s .. charset:sub(idx, idx)
					end
					return prefix .. s
				end
				local dispId = rootScope:addVariable(rvar("_D"))
				local stateId = rootScope:addVariable(rvar("_S"))
				local newStmts = {}
				local BATCH = 8
				local hi = 1
				while hi <= #hoistedOrder do
					local batchIds = {}
					local batchNils = {}
					for b = hi, math.min(hi + BATCH - 1, #hoistedOrder) do
						table.insert(batchIds, hoistedOrder[b])
						table.insert(batchNils, Ast.NilExpression())
					end
					table.insert(newStmts, Ast.LocalVariableDeclaration(rootScope, batchIds, batchNils))
					hi = hi + BATCH
				end
				table.insert(
					newStmts,
					Ast.LocalVariableDeclaration(
						rootScope,
						{ dispId },
						{ Ast.TableConstructorExpression(tableEntries) }
					)
				)
				table.insert(
					newStmts,
					Ast.LocalVariableDeclaration(rootScope, { stateId }, { Ast.NumberExpression(realIds[1]) })
				)
				local dispatchCall = Ast.FunctionCallExpression(
					Ast.IndexExpression(
						Ast.VariableExpression(rootScope, dispId),
						Ast.VariableExpression(rootScope, stateId)
					),
					{}
				)
				local loopScope = Scope:new(rootScope)
				local loopBody = Ast.Block({
					Ast.AssignmentStatement({ Ast.AssignmentVariable(rootScope, stateId) }, { dispatchCall }),
				}, loopScope)
				local loopCond =
					Ast.NotEqualsExpression(Ast.VariableExpression(rootScope, stateId), Ast.NumberExpression(terminate))
				table.insert(newStmts, Ast.WhileStatement(loopBody, loopCond))
				ast.body.statements = newStmts
				return ast
			end
			return InvertedExecution
		end
		function _ZukOfficial.o()
			local v = _ZukOfficial.cache.o
			if not v then
				v = { c = __modImpl() }
				_ZukOfficial.cache.o = v
			end
			return v.c
		end
	end
	do
		local function __modImpl()
			local Ast = _ZukOfficial.b()
			local utils = _ZukOfficial.f()
			local charset = utils.chararray("qwertyuiopasdfghjklzxcvbnmQWERTYUIOPASDFGHJKLZXCVBNM1234567890")
			local charsetLen = #charset
			local function randomString(wordsOrLen)
				if type(wordsOrLen) == "table" then
					return wordsOrLen[math.random(1, #wordsOrLen)]
				end
				local len = wordsOrLen or math.random(2, 15)
				local parts = {}
				for i = 1, len do
					parts[i] = charset[math.random(1, charsetLen)]
				end
				return table.concat(parts)
			end
			local function randomStringNode(wordsOrLen)
				return Ast.StringExpression(randomString(wordsOrLen))
			end
			local usedStrings = {}
			local function uniqueRandomString(len)
				local str
				local attempts = 0
				repeat
					str = randomString(len)
					attempts = attempts + 1
					if attempts > 1000 then
						str = str .. tostring(#usedStrings)
						break
					end
				until not usedStrings[str]
				usedStrings[str] = true
				return str
			end
			local function resetUsed()
				usedStrings = {}
			end
			return {
				randomString = randomString,
				randomStringNode = randomStringNode,
				uniqueRandomString = uniqueRandomString,
				resetUsed = resetUsed,
			}
		end
		function _ZukOfficial.p()
			local v = _ZukOfficial.cache.p
			if not v then
				v = { c = __modImpl() }
				_ZukOfficial.cache.p = v
			end
			return v.c
		end
	end
	do
		local function __modImpl()
			local Ast = _ZukOfficial.b()
			local util = _ZukOfficial.f()
			local AstKind = Ast.AstKind
			local lookupify = util.lookupify
			local visitAst, visitBlock, visitStatement, visitExpression
			function visitAst(ast, previsit, postvisit, data)
				ast.isAst = true
				data = data or {}
				data.scopeStack = {}
				data.functionData = {
					depth = 0,
					scope = ast.body.scope,
					node = ast,
				}
				data.scope = ast.globalScope
				data.globalScope = ast.globalScope
				if type(previsit) == "function" then
					local node, skip = previsit(ast, data)
					ast = node or ast
					if skip then
						return ast
					end
				end
				visitBlock(ast.body, previsit, postvisit, data, true)
				if type(postvisit) == "function" then
					ast = postvisit(ast, data) or ast
				end
				return ast
			end
			local compundStats = lookupify({
				AstKind.CompoundAddStatement,
				AstKind.CompoundSubStatement,
				AstKind.CompoundMulStatement,
				AstKind.CompoundDivStatement,
				AstKind.CompoundModStatement,
				AstKind.CompoundPowStatement,
				AstKind.CompoundConcatStatement,
			})
			function visitBlock(block, previsit, postvisit, data, isFunctionBlock)
				block.isBlock = true
				block.isFunctionBlock = isFunctionBlock or false
				data.scope = block.scope
				local parentBlockData = data.blockData
				data.blockData = {}
				table.insert(data.scopeStack, block.scope)
				if type(previsit) == "function" then
					local node, skip = previsit(block, data)
					block = node or block
					if skip then
						data.scope = table.remove(data.scopeStack)
						return block
					end
				end
				local i = 1
				while i <= #block.statements do
					local statement = table.remove(block.statements, i)
					i = i - 1
					local returnedStatements = { visitStatement(statement, previsit, postvisit, data) }
					for j, statement in ipairs(returnedStatements) do
						i = i + 1
						table.insert(block.statements, i, statement)
					end
					i = i + 1
				end
				if type(postvisit) == "function" then
					block = postvisit(block, data) or block
				end
				data.scope = table.remove(data.scopeStack)
				data.blockData = parentBlockData
				return block
			end
			function visitStatement(statement, previsit, postvisit, data)
				statement.isStatement = true
				if type(previsit) == "function" then
					local node, skip = previsit(statement, data)
					statement = node or statement
					if skip then
						return statement
					end
				end
				if statement.kind == AstKind.ReturnStatement then
					for i, expression in ipairs(statement.args) do
						statement.args[i] = visitExpression(expression, previsit, postvisit, data)
					end
				elseif
					statement.kind == AstKind.PassSelfFunctionCallStatement
					or statement.kind == AstKind.FunctionCallStatement
				then
					statement.base = visitExpression(statement.base, previsit, postvisit, data)
					for i, expression in ipairs(statement.args) do
						statement.args[i] = visitExpression(expression, previsit, postvisit, data)
					end
				elseif statement.kind == AstKind.AssignmentStatement then
					for i, primaryExpr in ipairs(statement.lhs) do
						statement.lhs[i] = visitExpression(primaryExpr, previsit, postvisit, data)
					end
					for i, expression in ipairs(statement.rhs) do
						statement.rhs[i] = visitExpression(expression, previsit, postvisit, data)
					end
				elseif
					statement.kind == AstKind.FunctionDeclaration
					or statement.kind == AstKind.LocalFunctionDeclaration
				then
					local parentFunctionData = data.functionData
					data.functionData = {
						depth = parentFunctionData.depth + 1,
						scope = statement.body.scope,
						node = statement,
					}
					statement.body = visitBlock(statement.body, previsit, postvisit, data, true)
					data.functionData = parentFunctionData
				elseif statement.kind == AstKind.DoStatement then
					statement.body = visitBlock(statement.body, previsit, postvisit, data, false)
				elseif statement.kind == AstKind.WhileStatement then
					statement.condition = visitExpression(statement.condition, previsit, postvisit, data)
					statement.body = visitBlock(statement.body, previsit, postvisit, data, false)
				elseif statement.kind == AstKind.RepeatStatement then
					statement.body = visitBlock(statement.body, previsit, postvisit, data)
					statement.condition = visitExpression(statement.condition, previsit, postvisit, data)
				elseif statement.kind == AstKind.ForStatement then
					statement.initialValue = visitExpression(statement.initialValue, previsit, postvisit, data)
					statement.finalValue = visitExpression(statement.finalValue, previsit, postvisit, data)
					statement.incrementBy = visitExpression(statement.incrementBy, previsit, postvisit, data)
					statement.body = visitBlock(statement.body, previsit, postvisit, data, false)
				elseif statement.kind == AstKind.ForInStatement then
					for i, expression in ipairs(statement.expressions) do
						statement.expressions[i] = visitExpression(expression, previsit, postvisit, data)
					end
					visitBlock(statement.body, previsit, postvisit, data, false)
				elseif statement.kind == AstKind.IfStatement then
					statement.condition = visitExpression(statement.condition, previsit, postvisit, data)
					statement.body = visitBlock(statement.body, previsit, postvisit, data, false)
					for i, eif in ipairs(statement.elseifs) do
						eif.condition = visitExpression(eif.condition, previsit, postvisit, data)
						eif.body = visitBlock(eif.body, previsit, postvisit, data, false)
					end
					if statement.elsebody then
						statement.elsebody = visitBlock(statement.elsebody, previsit, postvisit, data, false)
					end
				elseif statement.kind == AstKind.LocalVariableDeclaration then
					for i, expression in ipairs(statement.expressions) do
						statement.expressions[i] = visitExpression(expression, previsit, postvisit, data)
					end
				elseif compundStats[statement.kind] then
					statement.lhs = visitExpression(statement.lhs, previsit, postvisit, data)
					statement.rhs = visitExpression(statement.rhs, previsit, postvisit, data)
				end
				if type(postvisit) == "function" then
					local statements = { postvisit(statement, data) }
					if #statements > 0 then
						return unpack(statements)
					end
				end
				return statement
			end
			local binaryExpressions = lookupify({
				AstKind.OrExpression,
				AstKind.AndExpression,
				AstKind.LessThanExpression,
				AstKind.GreaterThanExpression,
				AstKind.LessThanOrEqualsExpression,
				AstKind.GreaterThanOrEqualsExpression,
				AstKind.NotEqualsExpression,
				AstKind.EqualsExpression,
				AstKind.StrCatExpression,
				AstKind.AddExpression,
				AstKind.SubExpression,
				AstKind.MulExpression,
				AstKind.DivExpression,
				AstKind.ModExpression,
				AstKind.PowExpression,
			})
			function visitExpression(expression, previsit, postvisit, data)
				expression.isExpression = true
				if type(previsit) == "function" then
					local node, skip = previsit(expression, data)
					expression = node or expression
					if skip then
						return expression
					end
				end
				if binaryExpressions[expression.kind] then
					expression.lhs = visitExpression(expression.lhs, previsit, postvisit, data)
					expression.rhs = visitExpression(expression.rhs, previsit, postvisit, data)
				end
				if
					expression.kind == AstKind.NotExpression
					or expression.kind == AstKind.NegateExpression
					or expression.kind == AstKind.LenExpression
				then
					expression.rhs = visitExpression(expression.rhs, previsit, postvisit, data)
				end
				if
					expression.kind == AstKind.PassSelfFunctionCallExpression
					or expression.kind == AstKind.FunctionCallExpression
				then
					expression.base = visitExpression(expression.base, previsit, postvisit, data)
					for i, arg in ipairs(expression.args) do
						expression.args[i] = visitExpression(arg, previsit, postvisit, data)
					end
				end
				if expression.kind == AstKind.FunctionLiteralExpression then
					local parentFunctionData = data.functionData
					data.functionData = {
						depth = parentFunctionData.depth + 1,
						scope = expression.body.scope,
						node = expression,
					}
					expression.body = visitBlock(expression.body, previsit, postvisit, data, true)
					data.functionData = parentFunctionData
				end
				if expression.kind == AstKind.TableConstructorExpression then
					for i, entry in ipairs(expression.entries) do
						if entry.kind == AstKind.KeyedTableEntry then
							entry.key = visitExpression(entry.key, previsit, postvisit, data)
						end
						entry.value = visitExpression(entry.value, previsit, postvisit, data)
					end
				end
				if expression.kind == AstKind.IndexExpression or expression.kind == AstKind.AssignmentIndexing then
					expression.base = visitExpression(expression.base, previsit, postvisit, data)
					expression.index = visitExpression(expression.index, previsit, postvisit, data)
				end
				if expression.kind == AstKind.IfElseExpression then
					expression.condition = visitExpression(expression.condition, previsit, postvisit, data)
					expression.true_expr = visitExpression(expression.true_expr, previsit, postvisit, data)
					expression.false_expr = visitExpression(expression.false_expr, previsit, postvisit, data)
				end
				if type(postvisit) == "function" then
					expression = postvisit(expression, data) or expression
				end
				return expression
			end
			return visitAst
		end
		function _ZukOfficial.q()
			local v = _ZukOfficial.cache.q
			if not v then
				v = { c = __modImpl() }
				_ZukOfficial.cache.q = v
			end
			return v.c
		end
	end
	do
		local function __modImpl()
			local Step = _ZukOfficial.n()
			local Ast = _ZukOfficial.b()
			local Scope = _ZukOfficial.i()
			local RandomStrings = _ZukOfficial.p()
			local Parser = _ZukOfficial.j()
			local Enums = _ZukOfficial.g()
			local logger = _ZukOfficial.d()
			local visitast = _ZukOfficial.q()
			local util = _ZukOfficial.f()
			local AstKind = Ast.AstKind
			local EncryptStrings = Step:extend()
			EncryptStrings.Description = "This Step will encrypt strings within your Program."
			EncryptStrings.Name = "Encrypt Strings"
			EncryptStrings.SettingsDescriptor = {}
			function EncryptStrings:init(settings) end
			function EncryptStrings:CreateEncrypionService()
				local usedSeeds = {}
				local key_a = math.random(1, 255)
				local key_b = math.random(0, 511)
				local key_c = math.random(0, 8191)
				local key_d = math.random(0, 65535)
				local floor = math.floor
				local function bxor(a, b)
					local r, m = 0, 1
					while a > 0 or b > 0 do
						local ra = a % 2
						local rb = b % 2
						if ra ~= rb then
							r = r + m
						end
						a = floor(a / 2)
						b = floor(b / 2)
						m = m * 2
					end
					return r
				end
				local LCG_MUL_POOL = {
					1664525,
					1103515245,
					214013,
					6364136223846793005 % 2 ^ 32,
					1140671485,
					22695477,
					1664525 + math.random(0, 512) * 2,
					134775813,
					1284865837,
					4294967118,
				}
				local lcg_mul = LCG_MUL_POOL[math.random(#LCG_MUL_POOL)]
				local lcg_add = key_d * 2 + 1
				local lcg_mod = 2 ^ 32
				local state_lcg = 0
				local rot_state = 1
				local prev_bytes = {}
				local _ROT_MOD, _ROT_MUL, _ROT_ADD, _MIX_FACTOR
				local function set_seed(seed)
					state_lcg = seed % lcg_mod
					rot_state = (seed % _ROT_MOD) + 1
					prev_bytes = {}
				end
				local function gen_seed()
					local seed
					repeat
						seed = math.random(0, 2147483647)
					until not usedSeeds[seed]
					usedSeeds[seed] = true
					return seed
				end
				local function next_rand_32()
					state_lcg = (state_lcg * lcg_mul + lcg_add) % lcg_mod
					rot_state = (rot_state * _ROT_MUL + _ROT_ADD) % _ROT_MOD + 1
					local mixed = (state_lcg + rot_state * _MIX_FACTOR) % lcg_mod
					return floor(mixed)
				end
				local function get_next_byte()
					if #prev_bytes == 0 then
						local r = next_rand_32()
						local b1 = r % 256
						local b2 = floor(r / 256) % 256
						local b3 = floor(r / 65536) % 256
						local b4 = floor(r / 16777216) % 256
						prev_bytes = { b1, b2, b3, b4 }
					end
					return table.remove(prev_bytes)
				end
				local _roll_pool = {
					17,
					23,
					29,
					37,
					41,
					47,
					53,
					59,
					67,
					71,
					79,
					83,
					89,
					97,
					101,
					107,
					113,
					127,
					131,
					137,
					149,
					157,
					163,
					167,
					173,
					179,
					191,
					197,
					211,
					223,
					229,
					233,
					239,
					251,
				}
				local ROLL_CONST = _roll_pool[math.random(#_roll_pool)]
				local function encrypt(str)
					local seed = gen_seed()
					set_seed(seed)
					local len = #str
					local out = {}
					local roll = key_a
					for i = 1, len do
						local b = string.byte(str, i)
						local kb = get_next_byte()
						out[i] = string.char(bxor(b, bxor(kb, roll)) % 256)
						roll = (roll + b + ROLL_CONST) % 256
					end
					return table.concat(out), seed
				end
				local lcg_mul_s = tostring(lcg_mul)
				local lcg_add_s = tostring(lcg_add)
				local key_a_s = tostring(key_a)
				local roll_s = tostring(ROLL_CONST)
				local ROT_MOD_POOL = { 251, 241, 239, 233, 229, 227 }
				local ROT_MOD = ROT_MOD_POOL[math.random(#ROT_MOD_POOL)]
				local ROT_MUL_POOL = { 37, 41, 43, 47, 53, 59, 61, 67 }
				local ROT_MUL = ROT_MUL_POOL[math.random(#ROT_MUL_POOL)]
				local ROT_ADD_POOL = { 7, 11, 13, 17, 19, 23 }
				local ROT_ADD = ROT_ADD_POOL[math.random(#ROT_ADD_POOL)]
				local MIX_FACTOR_POOL = { 65537, 65539, 65543, 65551, 65557, 65563 }
				local MIX_FACTOR = MIX_FACTOR_POOL[math.random(#MIX_FACTOR_POOL)]
				_ROT_MOD = ROT_MOD
				_ROT_MUL = ROT_MUL
				_ROT_ADD = ROT_ADD
				_MIX_FACTOR = MIX_FACTOR
				local rot_mod_s = tostring(ROT_MOD)
				local rot_mul_s = tostring(ROT_MUL)
				local rot_add_s = tostring(ROT_ADD)
				local mix_factor_s = tostring(MIX_FACTOR)
				local function randIdent(len)
					local chars = {
						"a",
						"b",
						"c",
						"d",
						"e",
						"f",
						"g",
						"h",
						"i",
						"j",
						"k",
						"l",
						"m",
						"n",
						"o",
						"p",
						"q",
						"r",
						"s",
						"t",
						"u",
						"v",
						"w",
						"x",
						"y",
						"z",
					}
					local uppers = {
						"A",
						"B",
						"C",
						"D",
						"E",
						"F",
						"G",
						"H",
						"I",
						"J",
						"K",
						"L",
						"M",
						"N",
						"O",
						"P",
						"Q",
						"R",
						"S",
						"T",
						"U",
						"V",
						"W",
						"X",
						"Y",
						"Z",
					}
					local all = {}
					for _, v in ipairs(chars) do
						all[#all + 1] = v
					end
					for _, v in ipairs(uppers) do
						all[#all + 1] = v
					end
					local digits = { "0", "1", "2", "3", "4", "5", "6", "7", "8", "9" }
					local result = { chars[math.random(#chars)] }
					for _ = 2, len do
						local pool = math.random(3) == 1 and digits or all
						result[#result + 1] = pool[math.random(#pool)]
					end
					return table.concat(result)
				end
				local cache_key = randIdent(math.random(6, 12))
				local dec_key = randIdent(math.random(6, 12))
				local realstrings_key = randIdent(math.random(6, 12))
				local localcache_key = randIdent(math.random(6, 12))
				local locdec_key = randIdent(math.random(6, 12))
				local tbl_key = randIdent(math.random(6, 12))
				local function makeBxor(a, b)
					return string.format(
						[[
            	local function %s(%s,%s)
            		local r,m=0,1
            		while %s>0 or %s>0 do
            			local ra=%s%%2 local rb=%s%%2
            			if ra~=rb then r=r+m end
            			%s=_F(%s/2) %s=_F(%s/2) m=m*2
            		end
            		return r
            	end]],
						a,
						a,
						b,
						a,
						b,
						a,
						b,
						a,
						a,
						b,
						b
					)
				end
				local function genCode()
					local LCG_MUL = lcg_mul_s
					local LCG_ADD = lcg_add_s
					local LCG_MOD = "4294967296"
					local KEY_A = key_a_s
					local ROT_MOD = rot_mod_s
					local ROT_MUL = rot_mul_s
					local ROT_ADD = rot_add_s
					local MIX = mix_factor_s
					local ROLL_K = roll_s
					local cache = realstrings_key
					local code = "do\n"
					code = code .. "local " .. cache .. "={}\n"
					code = code .. "local _st0,_st1,_pb=0,1,{}\n"
					code = code .. "local _cm={}\n"
					code = code .. "for _ci=1,256 do _cm[_ci]=string.char(_ci-1) end\n"
					code = code .. "local function _rng()\n"
					code = code .. " _st0=(_st0*" .. LCG_MUL .. "+" .. LCG_ADD .. ")%" .. LCG_MOD .. "\n"
					code = code .. " _st1=(_st1*" .. ROT_MUL .. "+" .. ROT_ADD .. ")%" .. ROT_MOD .. "+1\n"
					code = code .. " return math.floor((_st0+_st1*" .. MIX .. ")%" .. LCG_MOD .. ")\n"
					code = code .. "end\n"
					code = code .. "local function _gb()\n"
					code = code .. " if #_pb==0 then local _v=_rng()\n"
					code = code
						.. "  _pb={_v%256,math.floor(_v/256)%256,math.floor(_v/65536)%256,math.floor(_v/16777216)%256}\n"
					code = code .. " end return table.remove(_pb)\n"
					code = code .. "end\n"
					code = code .. "local function _xr(_a,_b)\n"
					code = code .. " local _r,_m=0,1\n"
					code = code .. " while _a>0 or _b>0 do\n"
					code = code .. "  if _a%2~=_b%2 then _r=_r+_m end\n"
					code = code .. "  _a=math.floor(_a/2) _b=math.floor(_b/2) _m=_m*2\n"
					code = code .. " end return _r\n"
					code = code .. "end\n"
					code = code .. "STRINGS=setmetatable({},{__index=" .. cache .. ",__metatable=nil})\n"
					code = code .. "function DECRYPT(_s,_k)\n"
					code = code .. " if not " .. cache .. "[_k] then\n"
					code = code .. "  _pb={} _st0=_k%" .. LCG_MOD .. " _st1=_k%" .. ROT_MOD .. "+1\n"
					code = code .. "  local _n=#_s local _rk=" .. KEY_A .. " local _p={}\n"
					code = code .. "  for _i=1,_n do\n"
					code = code .. "   local _e=string.byte(_s,_i) local _b=_gb()\n"
					code = code .. "   local _d=_xr(_e,_xr(_b,_rk))%256\n"
					code = code .. "   _p[_i]=_cm[_d+1] _rk=(_rk+_d+" .. ROLL_K .. ")%256\n"
					code = code .. "  end\n"
					code = code .. "  " .. cache .. "[_k]=table.concat(_p)\n"
					code = code .. " end return _k\n"
					code = code .. "end\n"
					code = code .. "end"
					return code
				end
				return {
					encrypt = encrypt,
					genCode = genCode,
					key_a = key_a,
					lcg_mul = lcg_mul,
					lcg_add = lcg_add,
				}
			end
			function EncryptStrings:apply(ast, pipeline)
				local Encryptor = self:CreateEncrypionService()
				local code = Encryptor.genCode()
				local newAst = Parser:new({ LuaVersion = Enums.LuaVersion.Lua51 }):parse(code)
				local doStat = newAst.body.statements[1]
				local scope = ast.body.scope
				local decryptVar = scope:addVariable()
				local stringsVar = scope:addVariable()
				doStat.body.scope:setParent(ast.body.scope)
				visitast(newAst, nil, function(node, data)
					if node.kind == AstKind.FunctionDeclaration then
						if node.scope:getVariableName(node.id) == "DECRYPT" then
							data.scope:removeReferenceToHigherScope(node.scope, node.id)
							data.scope:addReferenceToHigherScope(scope, decryptVar)
							node.scope = scope
							node.id = decryptVar
						end
					end
					if node.kind == AstKind.AssignmentVariable or node.kind == AstKind.VariableExpression then
						if node.scope:getVariableName(node.id) == "STRINGS" then
							data.scope:removeReferenceToHigherScope(node.scope, node.id)
							data.scope:addReferenceToHigherScope(scope, stringsVar)
							node.scope = scope
							node.id = stringsVar
						end
					end
				end)
				visitast(ast, nil, function(node, data)
					if node.kind == AstKind.StringExpression then
						data.scope:addReferenceToHigherScope(scope, stringsVar)
						data.scope:addReferenceToHigherScope(scope, decryptVar)
						local encrypted, seed = Encryptor.encrypt(node.value)
						return Ast.IndexExpression(
							Ast.VariableExpression(scope, stringsVar),
							Ast.FunctionCallExpression(Ast.VariableExpression(scope, decryptVar), {
								Ast.StringExpression(encrypted),
								Ast.NumberExpression(seed),
							})
						)
					end
				end)
				table.insert(ast.body.statements, 1, doStat)
				table.insert(
					ast.body.statements,
					1,
					Ast.LocalVariableDeclaration(scope, util.shuffle({ decryptVar, stringsVar }), {})
				)
				return ast
			end
			return EncryptStrings
		end
		function _ZukOfficial.r()
			local v = _ZukOfficial.cache.r
			if not v then
				v = { c = __modImpl() }
				_ZukOfficial.cache.r = v
			end
			return v.c
		end
	end
	do
		local function __modImpl()
			local Step = _ZukOfficial.n()
			local Ast = _ZukOfficial.b()
			local visitAst = _ZukOfficial.q()
			local Parser = _ZukOfficial.j()
			local util = _ZukOfficial.f()
			local enums = _ZukOfficial.g()
			local LuaVersion = enums.LuaVersion
			local SplitStrings = Step:extend()
			SplitStrings.Description = "This Step splits Strings to a specific or random length"
			SplitStrings.Name = "Split Strings"
			SplitStrings.SettingsDescriptor = {
				Treshold = {
					name = "Treshold",
					description = "The relative amount of nodes that will be affected",
					type = "number",
					default = 1,
					min = 0,
					max = 1,
				},
				MinLength = {
					name = "MinLength",
					description = "The minimal length for the chunks in that the Strings are splitted",
					type = "number",
					default = 5,
					min = 1,
					max = nil,
				},
				MaxLength = {
					name = "MaxLength",
					description = "The maximal length for the chunks in that the Strings are splitted",
					type = "number",
					default = 5,
					min = 1,
					max = nil,
				},
				ConcatenationType = {
					name = "ConcatenationType",
					description = "The Functions used for Concatenation. Note that when using custom, the String Array will also be Shuffled",
					type = "enum",
					values = {
						"strcat",
						"table",
						"custom",
					},
					default = "custom",
				},
				CustomFunctionType = {
					name = "CustomFunctionType",
					description = "The Type of Function code injection This Option only applies when custom Concatenation is selected.\
            Note that when chosing inline, the code size may increase significantly!",
					type = "enum",
					values = {
						"global",
						"local",
						"inline",
					},
					default = "global",
				},
				CustomLocalFunctionsCount = {
					name = "CustomLocalFunctionsCount",
					description = "The number of local functions per scope. This option only applies when CustomFunctionType = local",
					type = "number",
					default = 2,
					min = 1,
				},
			}
			function SplitStrings:init(settings) end
			local function generateTableConcatNode(chunks, data)
				local chunkNodes = {}
				for i, chunk in ipairs(chunks) do
					table.insert(chunkNodes, Ast.TableEntry(Ast.StringExpression(chunk)))
				end
				local tb = Ast.TableConstructorExpression(chunkNodes)
				data.scope:addReferenceToHigherScope(data.tableConcatScope, data.tableConcatId)
				return Ast.FunctionCallExpression(
					Ast.VariableExpression(data.tableConcatScope, data.tableConcatId),
					{ tb }
				)
			end
			local function generateStrCatNode(chunks)
				local generatedNode = nil
				for i, chunk in ipairs(chunks) do
					if generatedNode then
						generatedNode = Ast.StrCatExpression(generatedNode, Ast.StringExpression(chunk))
					else
						generatedNode = Ast.StringExpression(chunk)
					end
				end
				return generatedNode
			end
			local customVariants = 2
			local custom1Code = [=[
            function custom(table)
                local stringTable, str = table[#table], "";
                for i=1,#stringTable, 1 do
                    str = str .. stringTable[table[i]];
            	end
            	return str
            end
            ]=]
			local custom2Code = [=[
            function custom(tb)
            	local str = "";
            	for i=1, #tb / 2, 1 do
            		str = str .. tb[#tb / 2 + tb[i]];
            	end
            	return str
            end
            ]=]
			local function generateCustomNodeArgs(chunks, data, variant)
				local shuffled = {}
				local shuffledIndices = {}
				for i = 1, #chunks, 1 do
					shuffledIndices[i] = i
				end
				util.shuffle(shuffledIndices)
				for i, v in ipairs(shuffledIndices) do
					shuffled[v] = chunks[i]
				end
				if variant == 1 then
					local args = {}
					local tbNodes = {}
					for i, v in ipairs(shuffledIndices) do
						table.insert(args, Ast.TableEntry(Ast.NumberExpression(v)))
					end
					for i, chunk in ipairs(shuffled) do
						table.insert(tbNodes, Ast.TableEntry(Ast.StringExpression(chunk)))
					end
					local tb = Ast.TableConstructorExpression(tbNodes)
					table.insert(args, Ast.TableEntry(tb))
					return { Ast.TableConstructorExpression(args) }
				else
					local args = {}
					for i, v in ipairs(shuffledIndices) do
						table.insert(args, Ast.TableEntry(Ast.NumberExpression(v)))
					end
					for i, chunk in ipairs(shuffled) do
						table.insert(args, Ast.TableEntry(Ast.StringExpression(chunk)))
					end
					return { Ast.TableConstructorExpression(args) }
				end
			end
			local function generateCustomFunctionLiteral(parentScope, variant)
				local parser = Parser:new({
					LuaVersion = LuaVersion.Lua52,
				})
				if variant == 1 then
					local funcDeclNode = parser:parse(custom1Code).body.statements[1]
					local funcBody = funcDeclNode.body
					local funcArgs = funcDeclNode.args
					funcBody.scope:setParent(parentScope)
					return Ast.FunctionLiteralExpression(funcArgs, funcBody)
				else
					local funcDeclNode = parser:parse(custom2Code).body.statements[1]
					local funcBody = funcDeclNode.body
					local funcArgs = funcDeclNode.args
					funcBody.scope:setParent(parentScope)
					return Ast.FunctionLiteralExpression(funcArgs, funcBody)
				end
			end
			local function generateGlobalCustomFunctionDeclaration(ast, data)
				local parser = Parser:new({
					LuaVersion = LuaVersion.Lua52,
				})
				if data.customFunctionVariant == 1 then
					local astScope = ast.body.scope
					local funcDeclNode = parser:parse(custom1Code).body.statements[1]
					local funcBody = funcDeclNode.body
					local funcArgs = funcDeclNode.args
					funcBody.scope:setParent(astScope)
					return Ast.LocalVariableDeclaration(
						astScope,
						{ data.customFuncId },
						{ Ast.FunctionLiteralExpression(funcArgs, funcBody) }
					)
				else
					local astScope = ast.body.scope
					local funcDeclNode = parser:parse(custom2Code).body.statements[1]
					local funcBody = funcDeclNode.body
					local funcArgs = funcDeclNode.args
					funcBody.scope:setParent(astScope)
					return Ast.LocalVariableDeclaration(
						data.customFuncScope,
						{ data.customFuncId },
						{ Ast.FunctionLiteralExpression(funcArgs, funcBody) }
					)
				end
			end
			function SplitStrings:variant()
				return math.random(1, customVariants)
			end
			function SplitStrings:apply(ast, pipeline)
				local data = {}
				if self.ConcatenationType == "table" then
					local scope = ast.body.scope
					local id = scope:addVariable()
					data.tableConcatScope = scope
					data.tableConcatId = id
				elseif self.ConcatenationType == "custom" then
					data.customFunctionType = self.CustomFunctionType
					if data.customFunctionType == "global" then
						local scope = ast.body.scope
						local id = scope:addVariable()
						data.customFuncScope = scope
						data.customFuncId = id
						data.customFunctionVariant = self:variant()
					end
				end
				local customLocalFunctionsCount = self.CustomLocalFunctionsCount
				local self2 = self
				visitAst(ast, function(node, data)
					if
						self.ConcatenationType == "custom"
						and data.customFunctionType == "local"
						and node.kind == Ast.AstKind.Block
						and node.isFunctionBlock
					then
						data.functionData.localFunctions = {}
						for i = 1, customLocalFunctionsCount, 1 do
							local scope = data.scope
							local id = scope:addVariable()
							local variant = self:variant()
							table.insert(data.functionData.localFunctions, {
								scope = scope,
								id = id,
								variant = variant,
								used = false,
							})
						end
					end
				end, function(node, data)
					if
						self.ConcatenationType == "custom"
						and data.customFunctionType == "local"
						and node.kind == Ast.AstKind.Block
						and node.isFunctionBlock
					then
						for i, func in ipairs(data.functionData.localFunctions) do
							if func.used then
								local literal = generateCustomFunctionLiteral(func.scope, func.variant)
								table.insert(
									node.statements,
									1,
									Ast.LocalVariableDeclaration(func.scope, { func.id }, { literal })
								)
							end
						end
					end
					if node.kind == Ast.AstKind.StringExpression then
						local str = node.value
						local chunks = {}
						local i = 1
						while i <= string.len(str) do
							local len = math.random(self.MinLength, self.MaxLength)
							table.insert(chunks, string.sub(str, i, i + len - 1))
							i = i + len
						end
						if #chunks > 1 then
							if math.random() < self.Treshold then
								if self.ConcatenationType == "strcat" then
									node = generateStrCatNode(chunks)
								elseif self.ConcatenationType == "table" then
									node = generateTableConcatNode(chunks, data)
								elseif self.ConcatenationType == "custom" then
									if self.CustomFunctionType == "global" then
										local args = generateCustomNodeArgs(chunks, data, data.customFunctionVariant)
										data.scope:addReferenceToHigherScope(data.customFuncScope, data.customFuncId)
										node = Ast.FunctionCallExpression(
											Ast.VariableExpression(data.customFuncScope, data.customFuncId),
											args
										)
									elseif self.CustomFunctionType == "local" then
										local lfuncs = data.functionData.localFunctions
										local idx = math.random(1, #lfuncs)
										local func = lfuncs[idx]
										local args = generateCustomNodeArgs(chunks, data, func.variant)
										func.used = true
										data.scope:addReferenceToHigherScope(func.scope, func.id)
										node = Ast.FunctionCallExpression(
											Ast.VariableExpression(func.scope, func.id),
											args
										)
									elseif self.CustomFunctionType == "inline" then
										local variant = self:variant()
										local args = generateCustomNodeArgs(chunks, data, variant)
										local literal = generateCustomFunctionLiteral(data.scope, variant)
										node = Ast.FunctionCallExpression(literal, args)
									end
								end
							end
						end
						return node, true
					end
				end, data)
				if self.ConcatenationType == "table" then
					local globalScope = data.globalScope
					local tableScope, tableId = globalScope:resolve("table")
					ast.body.scope:addReferenceToHigherScope(globalScope, tableId)
					table.insert(
						ast.body.statements,
						1,
						Ast.LocalVariableDeclaration(data.tableConcatScope, { data.tableConcatId }, {
							Ast.IndexExpression(
								Ast.VariableExpression(tableScope, tableId),
								Ast.StringExpression("concat")
							),
						})
					)
				elseif self.ConcatenationType == "custom" and self.CustomFunctionType == "global" then
					table.insert(ast.body.statements, 1, generateGlobalCustomFunctionDeclaration(ast, data))
				end
			end
			return SplitStrings
		end
		function _ZukOfficial.s()
			local v = _ZukOfficial.cache.s
			if not v then
				v = { c = __modImpl() }
				_ZukOfficial.cache.s = v
			end
			return v.c
		end
	end
	do
		local function __modImpl()
			local Step = _ZukOfficial.n()
			local Ast = _ZukOfficial.b()
			local Scope = _ZukOfficial.i()
			local RandomStrings = _ZukOfficial.p()
			local Parser = _ZukOfficial.j()
			local Enums = _ZukOfficial.g()
			local logger = _ZukOfficial.d()
			local AntiTamper = Step:extend()
			AntiTamper.Description = "Breaks your script when it is modified. Only effective when using the new VM."
			AntiTamper.Name = "Anti Tamper"
			AntiTamper.SettingsDescriptor = {
				UseDebug = {
					type = "boolean",
					default = true,
					description = "Use debug library. (Recommended — scripts will not work without it when enabled.)",
				},
			}
			function AntiTamper:init(settings) end
			function AntiTamper:apply(ast, pipeline)
				if pipeline.PrettyPrint then
					logger:warn(
						string.format('"%s" cannot be used with PrettyPrint, ignoring "%s"', self.Name, self.Name)
					)
					return ast
				end
				local code = "do local valid = true;"
				if self.UseDebug then
					local _traceTag = RandomStrings.randomString()
					code = code
						.. [[
                        local sethook = debug and debug.sethook or function() end
                        local allowedLine = nil
                        local called = 0
                        sethook(function(s, line)
                            if not line then return end
                            called = called + 1
                            if allowedLine then
                                if allowedLine ~= line then
                                    sethook(error, "l", 5)
                                end
                            else
                                allowedLine = line
                            end
                        end, "l", 5)
                        ;(function() end)()
                        ;(function() end)()
                        ;(function() end)()
                        sethook()
                        if called < 3 then
                            valid = false
                        end
                        local funcs = {pcall, string.char, debug.getinfo, string.dump}
                        for i = 1, #funcs do
                            local _ok, info = pcall(debug.getinfo, funcs[i])
                            if not _ok or not info or info.what ~= "C" then
                                valid = false
                            end
                            local _ok2, upv = pcall(debug.getupvalue, funcs[i], 1)
                            if _ok2 and upv then
                                valid = false
                            end
                            if pcall(string.dump, funcs[i]) then
                                valid = false
                            end
                        end
                        local function getTraceback()
                            local str = (function(arg)
                                return debug.traceback(arg)
                            end)("]]
						.. _traceTag
						.. [[")
                            return str
                        end
                        local traceback = getTraceback()
                        local newlinePos = traceback:find("\n")
                        valid = valid and newlinePos ~= nil
                            and traceback:sub(1, newlinePos - 1) == "]]
						.. _traceTag
						.. [["
                        local iter = traceback:gmatch(":(%d*):")
                        local firstLine = iter()
                        local count = 1
                        for ln in iter do
                            valid = valid and (ln == firstLine)
                            count = count + 1
                        end
                        valid = valid and count >= 2
                    ]]
				end
				code = code
					.. [[
                local gmatch   = string.gmatch
                local err      = function() error("hey there") end
                local _pcall   = pcall
                local pcallIntact2 = false
                local pcallIntact  = _pcall(function() pcallIntact2 = true end) and pcallIntact2
                valid = valid and pcallIntact
                local random    = math.random
                local tblconcat = table.concat
                local unpkg     = (table and table.unpack) or unpack
                local n         = random(3, 65)
                local acc1      = 0
                local acc2      = 0
                local pcallRet = {_pcall(function()
                    local a = ]]
					.. tostring(math.random(1, 2 ^ 24))
					.. [[ - "]]
					.. RandomStrings.randomString()
					.. [[" ^ ]]
					.. tostring(math.random(1, 2 ^ 24))
					.. [[
                    return "]]
					.. RandomStrings.randomString()
					.. [[" / a
                end)}
                local origMsg = pcallRet[2]
                local line    = tonumber(gmatch(tostring(origMsg), ':(%d*):')())
                for i = 1, n do
                    local len       = random(1, 100)
                    local n2        = random(0, 255)
                    local pos       = random(1, len)
                    local shouldErr = random(1, 2) == 1
                    local msg       = origMsg:gsub(':(%d*):', ':' .. tostring(random(0, 10000)) .. ':')
                    local arr = {_pcall(function()
                        if random(1, 2) == 1 or i == n then
                            local line2 = tonumber(gmatch(tostring(({_pcall(function()
                                local a = ]]
					.. tostring(math.random(1, 2 ^ 24))
					.. [[ - "]]
					.. RandomStrings.randomString()
					.. [[" ^ ]]
					.. tostring(math.random(1, 2 ^ 24))
					.. [[
                                return "]]
					.. RandomStrings.randomString()
					.. [[" / a
                            end)})[2]), ':(%d*):')())
                            valid = valid and (line == line2)
                        end
                        if shouldErr then
                            error(msg, 0)
                        end
                        local arr2 = {}
                        for j = 1, len do
                            arr2[j] = random(0, 255)
                        end
                        arr2[pos] = n2
                        return unpkg(arr2)
                    end)}
                    if shouldErr then
                        valid = valid and (arr[1] == false) and (arr[2] == msg)
                    else
                        valid = valid and arr[1]
                        acc1 = (acc1 + arr[pos + 1]) % 256
                        acc2 = (acc2 + n2)           % 256
                    end
                end
                valid = valid and (acc1 == acc2)
                if not valid then
                    while true do
                        l1, l2 = l2, l1
                        err()
                    end
                    return
                end
            end
                local obj = setmetatable({}, {
                    __tostring = err,
                })
                obj[math.random(1, 100)] = obj
                ;(function() end)(obj)
                ]]
				local parsed = Parser:new({ LuaVersion = Enums.LuaVersion.Lua51 }):parse(code)
				local doStat = parsed.body.statements[1]
				doStat.body.scope:setParent(ast.body.scope)
				table.insert(ast.body.statements, 1, doStat)
				return ast
			end
			return AntiTamper
		end
		function _ZukOfficial.t()
			local v = _ZukOfficial.cache.t
			if not v then
				v = { c = __modImpl() }
				_ZukOfficial.cache.t = v
			end
			return v.c
		end
	end
	do
		local function __modImpl()
			local Step = _ZukOfficial.n()
			local Ast = _ZukOfficial.b()
			local Scope = _ZukOfficial.i()
			local visitast = _ZukOfficial.q()
			local util = _ZukOfficial.f()
			local Parser = _ZukOfficial.j()
			local Enums = _ZukOfficial.g()
			local AstKind = Ast.AstKind
			local LuaVersion = Enums.LuaVersion
			local DynamicXOR = Step:extend()
			DynamicXOR.Description =
				"Chained-state XOR encoding on number constants. Stateful: element N depends on elements 1..N-1, defeating AI batch decoding."
			DynamicXOR.Name = "DynamicXOR"
			DynamicXOR.SettingsDescriptor = {
				Treshold = {
					name = "Treshold",
					description = "Fraction of number literals to XOR-encode",
					type = "number",
					default = 0.5,
					min = 0,
					max = 1,
				},
				ChainStrength = {
					name = "ChainStrength",
					description = "How many prior elements feed into each state update (1=simple chain, 3=harder)",
					type = "number",
					default = 2,
					min = 1,
					max = 4,
				},
			}
			function DynamicXOR:init(settings) end
			local function rol32(x, n)
				x = x % 0x100000000
				n = n % 32
				local hi = math.floor(x / (2 ^ (32 - n)))
				local lo = (x % (2 ^ (32 - n))) * (2 ^ n)
				return (hi + lo) % 0x100000000
			end
			local function bxor32(a, b)
				local r, m = 0, 1
				a = a % 0x100000000
				b = b % 0x100000000
				while a > 0 or b > 0 do
					if (a % 2) ~= (b % 2) then
						r = r + m
					end
					a = math.floor(a / 2)
					b = math.floor(b / 2)
					m = m * 2
				end
				return r
			end
			function DynamicXOR:apply(ast, pipeline)
				local candidates = {}
				visitast(ast, nil, function(node)
					if
						node.kind == AstKind.NumberExpression
						and math.abs(node.value) > 7
						and node.value == math.floor(node.value)
						and math.random() <= self.Treshold
					then
						candidates[#candidates + 1] = node
					end
				end)
				if #candidates == 0 then
					return ast
				end
				local seed = math.random(0x1000, 0xEFFFFFFF)
				local stepMul = math.random(0x100, 0xFFFF) * 2 + 1
				local rotBase = math.random(1, 7)
				local strength = math.max(1, math.min(4, math.floor(self.ChainStrength or 2)))
				local encodedValues = {}
				local state = seed
				for i, node in ipairs(candidates) do
					local rot = (rotBase + i) % 32
					local mask = rol32(state, rot) % 0x100000000
					local v = math.floor(math.abs(node.value)) % 0x100000000
					local enc = bxor32(v, mask)
					encodedValues[i] = {
						node = node,
						enc = enc,
						neg = node.value < 0,
						state = state,
						mask = mask,
					}
					state = rol32((state * stepMul + enc) % 0x100000000, rotBase)
				end
				local nodeMap = {}
				for idx, entry in ipairs(encodedValues) do
					nodeMap[entry.node] = { index = idx, neg = entry.neg }
				end
				local dtName = "_xd" .. math.random(10000, 99999)
				local idxName = "_xi" .. math.random(10000, 99999)
				local parts = {}
				for _, entry in ipairs(encodedValues) do
					parts[#parts + 1] = tostring(entry.enc)
				end
				local tableLit = "{" .. table.concat(parts, ",") .. "}"
				local decodeCode = string.format(
					[[
            do
                local %s = %s
                local function _rol_%s(x, n)
                    x = x %% 4294967296
                    n = n %% 32
                    if n == 0 then return x end
                    local hi = math.floor(x / (2^(32-n)))
                    local lo = (x %% (2^(32-n))) * (2^n)
                    return (hi + lo) %% 4294967296
                end
                local function _bx_%s(a, b)
                    local r, m = 0, 1
                    a = a %% 4294967296
                    b = b %% 4294967296
                    while a > 0 or b > 0 do
                        if (a %% 2) ~= (b %% 2) then r = r + m end
                        a = math.floor(a / 2)
                        b = math.floor(b / 2)
                        m = m * 2
                    end
                    return r
                end
                local %s = %d
                for %s = 1, #%s do
                    local _rot = (%d + %s) %% 32
                    local _mask = _rol_%s(%s, _rot)
                    %s[%s] = _bx_%s(%s[%s], _mask)
                    %s = _rol_%s((%s * %d + %s[%s]) %% 4294967296, %d)
                end
            end
            ]],
					dtName,
					tableLit,
					dtName,
					dtName,
					"_xs" .. dtName,
					seed,
					idxName,
					dtName,
					rotBase,
					idxName,
					dtName,
					"_xs" .. dtName,
					dtName,
					idxName,
					dtName,
					dtName,
					idxName,
					"_xs" .. dtName,
					dtName,
					"_xs" .. dtName,
					dtName,
					"_xs" .. dtName,
					stepMul,
					dtName,
					idxName,
					dtName,
					rotBase
				)
				local parser = Parser:new({ LuaVersion = LuaVersion.Lua51 })
				local ok, parsed = pcall(function()
					return parser:parse(decodeCode)
				end)
				if not ok then
					return ast
				end
				for i = #parsed.body.statements, 1, -1 do
					local stat = parsed.body.statements[i]
					if stat.body and stat.body.scope then
						stat.body.scope:setParent(ast.body.scope)
					end
					table.insert(ast.body.statements, 1, stat)
				end
				local refExpr = nil
				do
					local refSrc = "return " .. dtName
					local refOk, refParsed = pcall(function()
						return parser:parse(refSrc)
					end)
					if refOk and refParsed then
						local stmts = refParsed.body.statements
						if stmts and stmts[1] and stmts[1].values then
							refExpr = stmts[1].values[1]
						end
					end
				end
				if not refExpr then
					return ast
				end
				visitast(ast, nil, function(node)
					local info = nodeMap[node]
					if not info then
						return
					end
					local indexNode = Ast.IndexExpression(refExpr, Ast.NumberExpression(info.index))
					if info.neg then
						return Ast.NegateExpression(indexNode)
					end
					return indexNode
				end)
				return ast
			end
			return DynamicXOR
		end
		function _ZukOfficial.u()
			local v = _ZukOfficial.cache.u
			if not v then
				v = { c = __modImpl() }
				_ZukOfficial.cache.u = v
			end
			return v.c
		end
	end
	do
		local function __modImpl()
			local Step = _ZukOfficial.n()
			local Ast = _ZukOfficial.b()
			local Scope = _ZukOfficial.i()
			local visitast = _ZukOfficial.q()
			local util = _ZukOfficial.f()
			local Parser = _ZukOfficial.j()
			local Enums = _ZukOfficial.g()
			local AstKind = Ast.AstKind
			local LuaVersion = Enums.LuaVersion
			local DynamicDecrypt = Step:extend()
			DynamicDecrypt.Description =
				"Multi-layer Feistel cipher with a runtime-generated S-box: constants stay encrypted; every execution uses a different effective cipher derived from os.clock/tick."
			DynamicDecrypt.Name = "Dynamic Decrypt"
			DynamicDecrypt.SettingsDescriptor = {
				Threshold = {
					name = "Threshold",
					description = "Fraction of string nodes to encrypt (0-1)",
					type = "number",
					default = 1,
					min = 0,
					max = 1,
				},
				Rounds = {
					name = "Rounds",
					description = "Number of Feistel rounds (2-8). More rounds = harder to reverse, slightly more overhead.",
					type = "number",
					default = 4,
					min = 2,
					max = 8,
				},
			}
			function DynamicDecrypt:init(settings) end
			local function bxor51(a, b)
				local r, m = 0, 1
				while a > 0 or b > 0 do
					local ra = a % 2
					local rb = b % 2
					if ra ~= rb then
						r = r + m
					end
					a = math.floor(a / 2)
					b = math.floor(b / 2)
					m = m * 2
				end
				return r
			end
			local function feistelEncryptByte(b, roundKeys, tweak, pos, rounds)
				local TWEAKS = { 1, 3, 7, 13, 31, 61, 127, 251 }
				for r = 1, rounds do
					local rk = roundKeys[r]
					local tm = TWEAKS[r] or (r * 17 + 3)
					local idx = (b + rk + tweak * tm + pos) % 256
					b = bxor51(b, idx) % 256
				end
				return b
			end
			local function encryptString(str, roundKeys, tweak, rounds)
				local out = {}
				for i = 1, #str do
					local b = string.byte(str, i)
					out[i] = string.char(feistelEncryptByte(b, roundKeys, tweak, i, rounds))
				end
				return table.concat(out)
			end
			local function buildRuntimeCode(roundKeys, rounds, funcName)
				local tweaks = { 1, 3, 7, 13, 31, 61, 127, 251 }
				local code = "do\n"
				code = code .. "local function _bxor(_ba,_bb)\n"
				code = code .. " local _br,_bm=0,1\n"
				code = code .. " while _ba>0 or _bb>0 do\n"
				code = code .. "  if _ba%2~=_bb%2 then _br=_br+_bm end\n"
				code = code .. "  _ba=math.floor(_ba/2) _bb=math.floor(_bb/2) _bm=_bm*2\n"
				code = code .. " end return _br\n"
				code = code .. "end\n"
				code = code .. "local function _dec_byte(_db,_tw,_pos)\n"
				for r = rounds, 1, -1 do
					local rk = roundKeys[r] or 0
					local tm = tweaks[r] or (r * 17 + 3)
					code = code
						.. " do local _idx=(_db+"
						.. rk
						.. "+_tw*"
						.. tm
						.. "+_pos)%256 _db=_bxor(_db,_idx)%256 end\n"
				end
				code = code .. " return _db\n"
				code = code .. "end\n"
				code = code .. "function " .. funcName .. "(_enc,_tw)\n"
				code = code .. " local _n=#_enc local _out={}\n"
				code = code .. " for _di=1,_n do _out[_di]=string.char(_dec_byte(string.byte(_enc,_di),_tw,_di)) end\n"
				code = code .. " return table.concat(_out)\n"
				code = code .. "end\n"
				code = code .. "end"
				return code
			end
			function DynamicDecrypt:apply(ast, pipeline)
				local rounds = math.max(2, math.min(8, math.floor(self.Rounds or 4)))
				local threshold = self.Threshold or 1
				local roundKeys = {}
				for i = 1, rounds do
					roundKeys[i] = math.random(0, 255)
				end
				local funcName = "DDEC"
				local rtCode = buildRuntimeCode(roundKeys, rounds, funcName)
				local parser = Parser:new({ LuaVersion = LuaVersion.Lua51 })
				local rtAst = parser:parse(rtCode)
				local doStat = rtAst.body.statements[1]
				local rootScope = ast.body.scope
				local ddecVar = rootScope:addVariable()
				doStat.body.scope:setParent(rootScope)
				visitast(rtAst, nil, function(node, data)
					if node.kind == AstKind.FunctionDeclaration then
						if node.scope:getVariableName(node.id) == funcName then
							data.scope:removeReferenceToHigherScope(node.scope, node.id)
							data.scope:addReferenceToHigherScope(rootScope, ddecVar)
							node.scope = rootScope
							node.id = ddecVar
						end
					end
				end)
				table.insert(ast.body.statements, 1, doStat)
				table.insert(ast.body.statements, 1, Ast.LocalVariableDeclaration(rootScope, { ddecVar }, {}))
				local tweakCounter = 0
				visitast(ast, nil, function(node, data)
					if node.kind == AstKind.StringExpression and #node.value >= 1 and math.random() <= threshold then
						tweakCounter = tweakCounter + math.random(1, 63)
						local tw = tweakCounter
						local enc = encryptString(node.value, roundKeys, tw, rounds)
						data.scope:addReferenceToHigherScope(rootScope, ddecVar)
						return Ast.FunctionCallExpression(Ast.VariableExpression(rootScope, ddecVar), {
							Ast.StringExpression(enc),
							Ast.NumberExpression(tw),
						})
					end
				end)
				return ast
			end
			return DynamicDecrypt
		end
		function _ZukOfficial.v()
			local v = _ZukOfficial.cache.v
			if not v then
				v = { c = __modImpl() }
				_ZukOfficial.cache.v = v
			end
			return v.c
		end
	end
	do
		local function __modImpl()
			local Step = _ZukOfficial.n()
			local Ast = _ZukOfficial.b()
			local Parser = _ZukOfficial.j()
			local Enums = _ZukOfficial.g()
			local visitast = _ZukOfficial.q()
			local AstKind = Ast.AstKind
			local LuaVersion = Enums.LuaVersion
			local DynamicJumps = Step:extend()
			DynamicJumps.Description =
				"Replaces function bodies with runtime-randomized indirect jump tables: opcode values and dispatch structure differ every execution, making static CFG analysis impossible."
			DynamicJumps.Name = "Dynamic Jumps"
			DynamicJumps.SettingsDescriptor = {
				Threshold = {
					name = "Threshold",
					description = "Fraction of eligible local functions to transform (0-1)",
					type = "number",
					default = 0.85,
					min = 0,
					max = 1,
				},
				PoolSize = {
					name = "PoolSize",
					description = "Size of the opcode pool to shuffle. Larger = more entropy, slightly bigger output.",
					type = "number",
					default = 64,
					min = 16,
					max = 256,
				},
				MinStatements = {
					name = "MinStatements",
					description = "Minimum number of statements in a function body to apply the transform.",
					type = "number",
					default = 2,
					min = 1,
					max = 32,
				},
			}
			function DynamicJumps:init(settings) end
			local function newParser()
				return Parser:new({ LuaVersion = LuaVersion.Lua51 })
			end
			local function parseBlock(src)
				local p = newParser()
				local ok, result = pcall(function()
					return p:parse(src)
				end)
				if not ok or not result then
					return nil
				end
				return result.body.statements
			end
			local function parseExpr(src)
				local p = newParser()
				local ok, result = pcall(function()
					return p:parse("return " .. src)
				end)
				if not ok or not result then
					return nil
				end
				local stmts = result.body.statements
				if stmts and stmts[1] and stmts[1].values then
					return stmts[1].values[1]
				end
				return nil
			end
			local function buildPoolPreamble(poolSize, nSlots, slotVars)
				local lines = {}
				local poolLit = "{"
				for i = 1, poolSize do
					poolLit = poolLit .. (i * 3 + 7)
					if i < poolSize then
						poolLit = poolLit .. ","
					end
				end
				poolLit = poolLit .. "}"
				lines[#lines + 1] = "local _pool = " .. poolLit
				lines[#lines + 1] = "do"
				lines[#lines + 1] =
					"  local _sd = math.floor(((tick and tick()) or (os and os.clock and os.clock()) or 0.9876) * 999983) % 2147483647 + 1"
				lines[#lines + 1] = "  local _sz = " .. poolSize
				lines[#lines + 1] = "  for _fi = _sz, 2, -1 do"
				lines[#lines + 1] = "    _sd = (_sd * 1664525 + 1013904223) % 2147483648"
				lines[#lines + 1] = "    local _fj = (_sd % _fi) + 1"
				lines[#lines + 1] = "    _pool[_fi], _pool[_fj] = _pool[_fj], _pool[_fi]"
				lines[#lines + 1] = "  end"
				lines[#lines + 1] = "end"
				for i, vname in ipairs(slotVars) do
					lines[#lines + 1] = "local " .. vname .. " = _pool[" .. i .. "]"
				end
				return table.concat(lines, "\n")
			end
			local function rewireScopes(nodes, realScope)
				local function walk(node)
					if type(node) ~= "table" then
						return
					end
					if node.kind == AstKind.Block and node.scope then
						local s = node.scope
						if s.parentScope == nil or s.isGlobal then
							s:setParent(realScope)
						end
					end
					for _, v in pairs(node) do
						if type(v) == "table" then
							if v.kind then
								walk(v)
							else
								for _, child in ipairs(v) do
									if type(child) == "table" and child.kind then
										walk(child)
									end
								end
							end
						end
					end
				end
				for _, stmt in ipairs(nodes) do
					walk(stmt)
				end
			end
			local function transformBody(stmts, poolSize, scope)
				local n = #stmts
				if n < 1 then
					return nil
				end
				local slotVars = {}
				for i = 1, n do
					slotVars[i] = "_dj_s" .. i .. "_" .. math.random(1000, 9999)
				end
				local sentinelVar = "_dj_nil_" .. math.random(1000, 9999)
				local actualPoolSize = math.max(poolSize, n + 8)
				local allVars = {}
				for _, v in ipairs(slotVars) do
					allVars[#allVars + 1] = v
				end
				allVars[#allVars + 1] = sentinelVar
				local preambleSrc = buildPoolPreamble(actualPoolSize, n + 1, allVars)
				local jtLines = {}
				jtLines[#jtLines + 1] = "local _djt = {}"
				for i = 1, n do
					local nextSlot = (i < n) and slotVars[i + 1] or "nil"
					jtLines[#jtLines + 1] =
						string.format("_djt[%s] = function(_djt_, _djst_) _djst_[1] = %s end", slotVars[i], nextSlot)
				end
				jtLines[#jtLines + 1] = "local _djst = { " .. slotVars[1] .. " }"
				jtLines[#jtLines + 1] = "while _djst[1] do _djt[_djst[1]](_djt, _djst) end"
				local fullSrc = preambleSrc .. "\n" .. table.concat(jtLines, "\n")
				local parsed = parseBlock(fullSrc)
				if not parsed then
					return nil
				end
				local preambleParsed = parseBlock(preambleSrc)
				if not preambleParsed then
					return nil
				end
				rewireScopes(parsed, scope)
				local preambleCount = #preambleParsed
				for i = 1, n do
					local assignIdx = preambleCount + i
					local assignNode = parsed[assignIdx]
					if not assignNode then
						return nil
					end
					local funcExpr = nil
					if assignNode.kind == AstKind.AssignmentStatement then
						funcExpr = (assignNode.rhs and assignNode.rhs[1])
							or (assignNode.values and assignNode.values[1])
					end
					if not funcExpr then
						return nil
					end
					local bodyStmts = funcExpr.body and funcExpr.body.statements
					if not bodyStmts then
						return nil
					end
					table.insert(bodyStmts, 1, stmts[i])
				end
				return parsed
			end
			function DynamicJumps:apply(ast, pipeline)
				local threshold = self.Threshold or 0.85
				local poolSize = math.floor(self.PoolSize or 64)
				local minStmts = math.floor(self.MinStatements or 2)
				visitast(ast, nil, function(node, data)
					local isFuncDecl = (
						node.kind == AstKind.FunctionDeclaration or node.kind == AstKind.LocalFunctionDeclaration
					)
					if not isFuncDecl then
						return
					end
					if math.random() > threshold then
						return
					end
					local body = node.body
					if not body then
						return
					end
					local stmts = body.statements
					if not stmts or #stmts < minStmts then
						return
					end
					local newStmts = transformBody(stmts, poolSize, body.scope)
					if newStmts then
						body.statements = newStmts
					end
				end)
				return ast
			end
			return DynamicJumps
		end
		function _ZukOfficial.w()
			local v = _ZukOfficial.cache.w
			if not v then
				v = { c = __modImpl() }
				_ZukOfficial.cache.w = v
			end
			return v.c
		end
	end
	do
		local function __modImpl()
			local Step = _ZukOfficial.n()
			local Ast = _ZukOfficial.b()
			local visitast = _ZukOfficial.q()
			local AstKind = Ast.AstKind
			local ConstantsObfuscator = Step:extend()
			ConstantsObfuscator.Description =
				"Replaces number and string literals with setmetatable-based algebraic expressions (x²-y²+z identity)."
			ConstantsObfuscator.Name = "Constants Obfuscator"
			ConstantsObfuscator.SettingsDescriptor = {
				ObfuscateNumbers = {
					type = "boolean",
					default = true,
				},
				ObfuscateStrings = {
					type = "boolean",
					default = true,
				},
				MockStringChance = {
					type = "number",
					default = 10,
					min = 1,
					max = 100,
				},
				MinAbsValue = {
					type = "number",
					default = 2,
					min = 0,
					max = 1e9,
				},
			}
			local MOCKING_STRINGS = {
				"k7qL2mX",
				"nT5vR8pW",
				"gB3dH6jY",
				"cF9wA1sZ",
				"xU4eI0oQ",
			}
			local OPERATORS = {
				{ sym = "+", mm = "__add" },
				{ sym = "-", mm = "__sub" },
			}
			local function solveTriple(target)
				if target ~= math.floor(target) then
					return nil
				end
				local abs_target = math.abs(target)
				local sign = (target < 0) and -1 or 1
				for _ = 1, 500 do
					local x = math.random(1, 2 ^ 14)
					local y = math.random(1, 2 ^ 14)
					local z = abs_target - x * x + y * y
					if x * x - y * y + z == abs_target then
						return x, y, sign * z
					end
				end
				return nil
			end
			local function parseExpr(src)
				local Parser = _ZukOfficial.j()
				local Enums = _ZukOfficial.g()
				local p = Parser:new({ LuaVersion = Enums.LuaVersion.Lua51 })
				local ok, result = pcall(function()
					return p:parse("return " .. src)
				end)
				if not ok then
					return nil
				end
				local stmts = result and result.body and result.body.statements
				if stmts and stmts[1] and stmts[1].values then
					return stmts[1].values[1]
				end
				return nil
			end
			local function obfuscateNumber(value, mockChance, minAbs)
				if math.abs(value) < minAbs then
					return nil
				end
				if value ~= math.floor(value) then
					return nil
				end
				local x, y, z = solveTriple(value)
				if not x then
					return nil
				end
				local mockLen = 0
				local mockStr = nil
				if math.random(1, mockChance) == 1 and math.abs(value) >= 100 then
					mockStr = MOCKING_STRINGS[math.random(#MOCKING_STRINGS)]
					mockLen = #mockStr
				end
				local op = OPERATORS[math.random(#OPERATORS)]
				local snippet
				if mockStr then
					snippet = string.format(
						[[setmetatable({},{["%s"]=function(_,a)local x,y,z=a[1],a[2],a[3];return x*x-y*y+z end})%s{%d,%d,%d}+%d-#"%s"]],
						op.mm,
						op.sym,
						x,
						y,
						z + mockLen,
						mockLen,
						mockStr
					)
				else
					snippet = string.format(
						[[setmetatable({},{["%s"]=function(_,a)local x,y,z=a[1],a[2],a[3];return x*x-y*y+z end})%s{%d,%d,%d}]],
						op.mm,
						op.sym,
						x,
						y,
						z
					)
				end
				return parseExpr(snippet)
			end
			local function obfuscateString(value)
				if #value == 0 then
					return nil
				end
				local parts = {}
				for i = 1, #value do
					local b = value:byte(i)
					local x, y, z = solveTriple(b)
					if not x then
						return nil
					end
					parts[i] = string.format("{%d,%d,%d}", x, y, z)
				end
				local op = OPERATORS[math.random(#OPERATORS)]
				local snippet = string.format(
					[[setmetatable({},{["%s"]=function(_,a)local s=""local i=1 while a[i] do local t=a[i];s=s..string.char(t[1]*t[1]-t[2]*t[2]+t[3]);i=i+1 end return s end})%s{%s}]],
					op.mm,
					op.sym,
					table.concat(parts, ",")
				)
				return parseExpr(snippet)
			end
			function ConstantsObfuscator:init(settings) end
			function ConstantsObfuscator:apply(ast, pipeline)
				local obfNums = self.ObfuscateNumbers
				local obfStrs = self.ObfuscateStrings
				local mockCh = self.MockStringChance
				local minAbs = self.MinAbsValue
				visitast(ast, nil, function(node, data)
					if obfNums and node.kind == AstKind.NumberExpression then
						local replacement = obfuscateNumber(node.value, mockCh, minAbs)
						if replacement then
							return replacement
						end
					elseif obfStrs and node.kind == AstKind.StringExpression then
						if #node.value >= 2 then
							local replacement = obfuscateString(node.value)
							if replacement then
								return replacement
							end
						end
					end
				end)
				return ast
			end
			return ConstantsObfuscator
		end
		function _ZukOfficial.x()
			local v = _ZukOfficial.cache.x
			if not v then
				v = { c = __modImpl() }
				_ZukOfficial.cache.x = v
			end
			return v.c
		end
	end
	do
		local function __modImpl()
			unpack = unpack or table.unpack
			local Step = _ZukOfficial.n()
			local Ast = _ZukOfficial.b()
			local Scope = _ZukOfficial.i()
			local visitast = _ZukOfficial.q()
			local util = _ZukOfficial.f()
			local AstKind = Ast.AstKind
			local NumbersToExpressions = Step:extend()
			NumbersToExpressions.Description =
				"Converts number literals to context-dependent expressions. Resistant to AI/symbolic batch decoding."
			NumbersToExpressions.Name = "Numbers To Expressions"
			NumbersToExpressions.SettingsDescriptor = {
				Treshold = {
					type = "number",
					default = 1,
					min = 0,
					max = 1,
				},
				InternalTreshold = {
					type = "number",
					default = 0.2,
					min = 0,
					max = 0.8,
				},
				AIResistance = {
					type = "boolean",
					default = true,
					description = "Enable non-arithmetic generators that defeat AI/symbolic decoders",
				},
			}
			function NumbersToExpressions:init(settings)
				local arithGenerators = {
					function(val, depth)
						local a = math.random(-2 ^ 20, 2 ^ 20)
						local b = val - a
						if tonumber(tostring(b)) + tonumber(tostring(a)) ~= val then
							return false
						end
						return Ast.AddExpression(
							self:CreateNumberExpression(a, depth),
							self:CreateNumberExpression(b, depth)
						)
					end,
					function(val, depth)
						local a = math.random(-2 ^ 20, 2 ^ 20)
						local b = val + a
						if tonumber(tostring(b)) - tonumber(tostring(a)) ~= val then
							return false
						end
						return Ast.SubExpression(
							self:CreateNumberExpression(b, depth),
							self:CreateNumberExpression(a, depth)
						)
					end,
					function(val, depth)
						if val == 0 then
							return false
						end
						local factors = { 3, 5, 7, 11, 13 }
						local a = factors[math.random(#factors)]
						local b = val / a
						if math.floor(b) ~= b then
							return false
						end
						if tonumber(tostring(b)) * tonumber(tostring(a)) ~= val then
							return false
						end
						return Ast.MulExpression(
							self:CreateNumberExpression(b, depth),
							self:CreateNumberExpression(a, depth)
						)
					end,
					function(val, depth)
						if val < 0 or val > 2 ^ 20 or math.floor(val) ~= val then
							return false
						end
						local modulus = val + math.random(1, 1024)
						local k = math.random(2, 8)
						local big = modulus * k + val
						if big % modulus ~= val then
							return false
						end
						if big > 2 ^ 53 then
							return false
						end
						return Ast.SubExpression(
							self:CreateNumberExpression(big, depth),
							self:CreateNumberExpression(modulus * k, depth)
						)
					end,
					function(val, depth)
						if val < 0 or val > 65535 or math.floor(val) ~= val then
							return false
						end
						local hi = math.floor(val / 256)
						local lo = val % 256
						if hi == 0 then
							return false
						end
						return Ast.AddExpression(
							self:CreateNumberExpression(hi * 256, depth),
							self:CreateNumberExpression(lo, depth)
						)
					end,
					function(val, depth)
						if val < 0 or val > 4294967295 or math.floor(val) ~= val then
							return false
						end
						local mask = math.random(0x1000, 0xFFFF)
						local a = val + mask
						if a - mask ~= val then
							return false
						end
						if a > 2 ^ 53 then
							return false
						end
						return Ast.SubExpression(
							self:CreateNumberExpression(a, depth),
							self:CreateNumberExpression(mask, depth)
						)
					end,
				}
				local aiResistGenerators = {
					function(val, depth)
						if val < 1 or val > 255 or math.floor(val) ~= val then
							return false
						end
						local char_str = string.char(val)
						local L = math.random(1, 8)
						local K = math.floor(val / L)
						local R = val - K * L
						if K == 0 or R < 0 or K * L + R ~= val then
							return false
						end
						local padStr = string.rep(string.char(math.random(65, 90)), L)
						local lenCall = Ast.FunctionCallExpression(
							Ast.IndexExpression(Ast.StringExpression("string"), Ast.StringExpression("len")),
							{ Ast.StringExpression(padStr) }
						)
						local mulNode = Ast.MulExpression(lenCall, Ast.NumberExpression(K))
						if R == 0 then
							return mulNode
						end
						return Ast.AddExpression(mulNode, Ast.NumberExpression(R))
					end,
					function(val, depth)
						if math.floor(val) ~= val or val < 0 or val > 2 ^ 20 then
							return false
						end
						local D = math.random(3, 31)
						local q = math.floor(val / D)
						local r = val % D
						if q == 0 then
							return false
						end
						local k = math.random(1, 100)
						local X = (q + k) * D
						if X > 2 ^ 53 then
							return false
						end
						local floorCall = Ast.FunctionCallExpression(
							Ast.IndexExpression(Ast.StringExpression("math"), Ast.StringExpression("floor")),
							{ Ast.DivExpression(Ast.NumberExpression(X), Ast.NumberExpression(D)) }
						)
						local subK = Ast.SubExpression(floorCall, Ast.NumberExpression(k))
						local mulD = Ast.MulExpression(
							Ast.ParenExpression and Ast.ParenExpression(subK) or subK,
							Ast.NumberExpression(D)
						)
						if r == 0 then
							return mulD
						end
						return Ast.AddExpression(mulD, Ast.NumberExpression(r))
					end,
					function(val, depth)
						if depth > 1 then
							return false
						end
						local K = math.random(1, 9999)
						local decoy = math.random(0, 0xFFFF)
						while decoy == val do
							decoy = math.random(0, 0xFFFF)
						end
						local maxCall = Ast.FunctionCallExpression(
							Ast.IndexExpression(Ast.StringExpression("math"), Ast.StringExpression("max")),
							{ Ast.NumberExpression(K), Ast.NumberExpression(K) }
						)
						local tautology = Ast.EqualExpression(maxCall, Ast.NumberExpression(K))
						return Ast.AndExpression(
							tautology,
							Ast.OrExpression(Ast.NumberExpression(val), Ast.NumberExpression(decoy))
						)
					end,
					function(val, depth)
						if depth > 0 then
							return false
						end
						local pos = math.random(2, 5)
						local args = {}
						args[1] = Ast.NumberExpression(pos)
						for i = 2, pos - 1 do
							args[i] = Ast.NumberExpression(math.random(0, 99999))
						end
						args[pos] = Ast.NumberExpression(val)
						for i = pos + 1, pos + math.random(1, 3) do
							args[i] = Ast.NumberExpression(math.random(0, 99999))
						end
						return Ast.FunctionCallExpression(
							Ast.VariableExpression(
								Ast.RootScope and Ast.RootScope() or ast and ast.body and ast.body.scope or {},
								"select"
							),
							args
						)
					end,
					function(val, depth)
						if val <= 0 or val > 2 ^ 20 then
							return false
						end
						local noise = math.random(1, 1000)
						local inner = -(val + noise)
						local absCall = Ast.FunctionCallExpression(
							Ast.IndexExpression(Ast.StringExpression("math"), Ast.StringExpression("abs")),
							{ Ast.NumberExpression(inner) }
						)
						return Ast.SubExpression(absCall, Ast.NumberExpression(noise))
					end,
				}
				if self.AIResistance ~= false then
					self.ExpressionGenerators = {}
					for _, g in ipairs(arithGenerators) do
						self.ExpressionGenerators[#self.ExpressionGenerators + 1] = g
					end
					for _, g in ipairs(aiResistGenerators) do
						self.ExpressionGenerators[#self.ExpressionGenerators + 1] = g
					end
				else
					self.ExpressionGenerators = arithGenerators
				end
			end
			function NumbersToExpressions:CreateNumberExpression(val, depth)
				if depth > 0 and math.random() >= self.InternalTreshold or depth > 15 then
					return Ast.NumberExpression(val)
				end
				local generators = util.shuffle({ unpack(self.ExpressionGenerators) })
				for i, generator in ipairs(generators) do
					local ok, node = pcall(generator, val, depth)
					if ok and node then
						return node
					end
				end
				return Ast.NumberExpression(val)
			end
			function NumbersToExpressions:apply(ast)
				visitast(ast, nil, function(node, data)
					if node.kind == AstKind.NumberExpression then
						if math.random() <= self.Treshold then
							return self:CreateNumberExpression(node.value, 0)
						end
					end
				end)
			end
			return NumbersToExpressions
		end
		function _ZukOfficial.y()
			local v = _ZukOfficial.cache.y
			if not v then
				v = { c = __modImpl() }
				_ZukOfficial.cache.y = v
			end
			return v.c
		end
	end
	do
		local function __modImpl()
			local Step = _ZukOfficial.n()
			local Ast = _ZukOfficial.b()
			local Scope = _ZukOfficial.i()
			local visitast = _ZukOfficial.q()
			local Parser = _ZukOfficial.j()
			local Enums = _ZukOfficial.g()
			local AstKind = Ast.AstKind
			local LuaVersion = Enums.LuaVersion
			local OpaquePredicates = Step:extend()
			OpaquePredicates.Description =
				"Injects always-true/false opaque predicates (trig identities, number theory) to prevent static control-flow analysis."
			OpaquePredicates.Name = "Opaque Predicates"
			OpaquePredicates.SettingsDescriptor = {
				Treshold = {
					name = "Treshold",
					description = "Probability that each function block gets a predicate injection",
					type = "number",
					default = 0.75,
					min = 0,
					max = 1,
				},
				InjectionsPerBlock = {
					name = "InjectionsPerBlock",
					description = "Max predicates injected per block",
					type = "number",
					default = 2,
					min = 1,
					max = 6,
				},
			}
			function OpaquePredicates:init(settings) end
			local function opaqueInt(n)
				local kind = math.random(1, 6)
				if kind == 1 then
					return string.format(
						"(math.floor((tick and tick() or (os and os.clock and os.clock()) or 0) * 0) + %d)",
						n
					)
				elseif kind == 2 then
					return string.format("(math.floor(math.random() * 0) + %d)", n)
				elseif kind == 3 then
					local rep = math.random(2, 5)
					local args = {}
					for _ = 1, rep do
						args[#args + 1] = tostring(math.random(1, 999))
					end
					return string.format("(select('#', %s) * 0 + %d)", table.concat(args, ","), n)
				elseif kind == 4 then
					return string.format("(%d + math.floor(math.random() * 0))", n)
				elseif kind == 5 then
					return string.format("(pcall(function()end) and %d or 0)", n)
				else
					return string.format("(math.floor((tick and tick() or 0) * 0) + %d)", n)
				end
			end
			local function generatePredicate()
				local style = math.random(1, 7)
				if style == 1 then
					local a = math.random(100, 99999)
					return string.format("%s == %d", opaqueInt(a), a)
				elseif style == 2 then
					local a = math.random(10, 9999)
					local b = math.random(10, 9999)
					return string.format("%s + %s == %d", opaqueInt(a), opaqueInt(b), a + b)
				elseif style == 3 then
					local a = math.random(2, 9999)
					return string.format("%s * %s == %d", opaqueInt(a), opaqueInt(1), a)
				elseif style == 4 then
					local n = math.random(1, 9999)
					return string.format('type(%s) == "number"', opaqueInt(n))
				elseif style == 5 then
					local b = math.random(1, 5000)
					local a = b + math.random(1, 5000)
					return string.format("%s >= %s", opaqueInt(a), opaqueInt(b))
				elseif style == 6 then
					local a = math.random(50, 9999)
					return string.format("math.max(%s, %s) == %d", opaqueInt(a), opaqueInt(a - 1), a)
				else
					local n = math.random(1, 500)
					return string.format("(function(...) return select('#',...) >= 0 end)(%s)", opaqueInt(n))
				end
			end
			local function deadBlock(scope)
				local innerScope = Scope:new(scope)
				local stmts = {}
				local dVar = innerScope:addVariable()
				table.insert(
					stmts,
					Ast.LocalVariableDeclaration(innerScope, { dVar }, { Ast.NumberExpression(math.random(1, 65535)) })
				)
				table.insert(
					stmts,
					Ast.AssignmentStatement({ Ast.AssignmentVariable(innerScope, dVar) }, {
						Ast.AddExpression(
							Ast.MulExpression(
								Ast.VariableExpression(innerScope, dVar),
								Ast.NumberExpression(math.random(2, 127))
							),
							Ast.NumberExpression(math.random(1, 255))
						),
					})
				)
				table.insert(
					stmts,
					Ast.AssignmentStatement({ Ast.AssignmentVariable(innerScope, dVar) }, { Ast.NilExpression() })
				)
				return Ast.Block(stmts, innerScope)
			end
			local function buildPredicateStatement(parentScope, parser)
				local pred = generatePredicate()
				local code = string.format("if %s then end", pred)
				local ok, parsed = pcall(function()
					return parser:parse(code)
				end)
				if not ok then
					return nil
				end
				local ifStat = parsed.body.statements[1]
				if ifStat then
					ifStat.elseBody = deadBlock(parentScope)
					if ifStat.body then
						ifStat.body.scope:setParent(parentScope)
					end
				end
				return ifStat
			end
			function OpaquePredicates:apply(ast, pipeline)
				local parser = Parser:new({ LuaVersion = LuaVersion.Lua51 })
				visitast(ast, nil, function(node, data)
					if node.kind ~= AstKind.Block then
						return
					end
					if not node.isFunctionBlock then
						return
					end
					if math.random() > self.Treshold then
						return
					end
					if #node.statements == 0 then
						return
					end
					local count = math.random(1, self.InjectionsPerBlock)
					for _ = 1, count do
						local stat = buildPredicateStatement(node.scope, parser)
						if stat then
							local insertPos = math.random(1, #node.statements)
							local last = node.statements[#node.statements]
							if
								last
								and (last.kind == AstKind.ReturnStatement or last.kind == AstKind.BreakStatement)
							then
								insertPos = math.max(1, #node.statements - 1)
							end
							table.insert(node.statements, insertPos, stat)
						end
					end
				end)
				return ast
			end
			return OpaquePredicates
		end
		function _ZukOfficial.z()
			local v = _ZukOfficial.cache.z
			if not v then
				v = { c = __modImpl() }
				_ZukOfficial.cache.z = v
			end
			return v.c
		end
	end
	do
		local function __modImpl()
			local MAX_REGS = 100
			local MAX_REGS_MUL = 0
			local Compiler = {}
			local Ast = _ZukOfficial.b()
			local Scope = _ZukOfficial.i()
			local logger = _ZukOfficial.d()
			local util = _ZukOfficial.f()
			local visitast = _ZukOfficial.q()
			local randomStrings = _ZukOfficial.p()
			local lookupify = util.lookupify
			local AstKind = Ast.AstKind
			local unpack = unpack or table.unpack
			function Compiler:new()
				local compiler = {
					blocks = {},
					registers = {},
					activeBlock = nil,
					registersForVar = {},
					usedRegisters = 0,
					maxUsedRegister = 0,
					registerVars = {},
					VAR_REGISTER = newproxy(false),
					RETURN_ALL = newproxy(false),
					POS_REGISTER = newproxy(false),
					RETURN_REGISTER = newproxy(false),
					UPVALUE = newproxy(false),
					BIN_OPS = lookupify({
						AstKind.LessThanExpression,
						AstKind.GreaterThanExpression,
						AstKind.LessThanOrEqualsExpression,
						AstKind.GreaterThanOrEqualsExpression,
						AstKind.NotEqualsExpression,
						AstKind.EqualsExpression,
						AstKind.StrCatExpression,
						AstKind.AddExpression,
						AstKind.SubExpression,
						AstKind.MulExpression,
						AstKind.DivExpression,
						AstKind.ModExpression,
						AstKind.PowExpression,
					}),
				}
				setmetatable(compiler, self)
				self.__index = self
				return compiler
			end
			function Compiler:createBlock()
				local id
				repeat
					id = math.random(0, 2 ^ 20)
				until not self.usedBlockIds[id]
				self.usedBlockIds[id] = true
				local scope = Scope:new(self.containerFuncScope)
				local block = {
					id = id,
					statements = {},
					scope = scope,
					advanceToNextBlock = true,
				}
				table.insert(self.blocks, block)
				return block
			end
			function Compiler:setActiveBlock(block)
				self.activeBlock = block
			end
			function Compiler:addStatement(statement, writes, reads, usesUpvals)
				if self.activeBlock.advanceToNextBlock then
					table.insert(self.activeBlock.statements, {
						statement = statement,
						writes = lookupify(writes),
						reads = lookupify(reads),
						usesUpvals = usesUpvals or false,
					})
				end
			end
			function Compiler:compile(ast)
				self.blocks = {}
				self.registers = {}
				self.activeBlock = nil
				self.registersForVar = {}
				self.scopeFunctionDepths = {}
				self.maxUsedRegister = 0
				self.usedRegisters = 0
				self.registerVars = {}
				self.usedBlockIds = {}
				self.upvalVars = {}
				self.registerUsageStack = {}
				self.upvalsProxyLenReturn = math.random(-2 ^ 18, 2 ^ 18)
				local newGlobalScope = Scope:newGlobal()
				local psc = Scope:new(newGlobalScope, nil)
				local _, getfenvVar = newGlobalScope:resolve("getfenv")
				local _, tableVar = newGlobalScope:resolve("table")
				local _, unpackVar = newGlobalScope:resolve("unpack")
				local _, envVar = newGlobalScope:resolve("_ENV")
				local _, newproxyVar = newGlobalScope:resolve("newproxy")
				local _, setmetatableVar = newGlobalScope:resolve("setmetatable")
				local _, getmetatableVar = newGlobalScope:resolve("getmetatable")
				local _, selectVar = newGlobalScope:resolve("select")
				psc:addReferenceToHigherScope(newGlobalScope, getfenvVar, 2)
				psc:addReferenceToHigherScope(newGlobalScope, tableVar)
				psc:addReferenceToHigherScope(newGlobalScope, unpackVar)
				psc:addReferenceToHigherScope(newGlobalScope, envVar)
				psc:addReferenceToHigherScope(newGlobalScope, newproxyVar)
				psc:addReferenceToHigherScope(newGlobalScope, setmetatableVar)
				psc:addReferenceToHigherScope(newGlobalScope, getmetatableVar)
				self.scope = Scope:new(psc)
				self.envVar = self.scope:addVariable()
				self.containerFuncVar = self.scope:addVariable()
				self.unpackVar = self.scope:addVariable()
				self.newproxyVar = self.scope:addVariable()
				self.setmetatableVar = self.scope:addVariable()
				self.getmetatableVar = self.scope:addVariable()
				self.selectVar = self.scope:addVariable()
				local argVar = self.scope:addVariable()
				self.containerFuncScope = Scope:new(self.scope)
				self.whileScope = Scope:new(self.containerFuncScope)
				self.posVar = self.containerFuncScope:addVariable()
				self.argsVar = self.containerFuncScope:addVariable()
				self.currentUpvaluesVar = self.containerFuncScope:addVariable()
				self.detectGcCollectVar = self.containerFuncScope:addVariable()
				self.returnVar = self.containerFuncScope:addVariable()
				self.upvaluesTable = self.scope:addVariable()
				self.upvaluesReferenceCountsTable = self.scope:addVariable()
				self.allocUpvalFunction = self.scope:addVariable()
				self.currentUpvalId = self.scope:addVariable()
				self.upvaluesProxyFunctionVar = self.scope:addVariable()
				self.upvaluesGcFunctionVar = self.scope:addVariable()
				self.freeUpvalueFunc = self.scope:addVariable()
				self.createClosureVars = {}
				self.createVarargClosureVar = self.scope:addVariable()
				local createClosureScope = Scope:new(self.scope)
				local createClosurePosArg = createClosureScope:addVariable()
				local createClosureUpvalsArg = createClosureScope:addVariable()
				local createClosureProxyObject = createClosureScope:addVariable()
				local createClosureFuncVar = createClosureScope:addVariable()
				local createClosureSubScope = Scope:new(createClosureScope)
				local upvalEntries = {}
				local upvalueIds = {}
				self.getUpvalueId = function(self, scope, id)
					local expression
					local scopeFuncDepth = self.scopeFunctionDepths[scope]
					if scopeFuncDepth == 0 then
						if upvalueIds[id] then
							return upvalueIds[id]
						end
						expression =
							Ast.FunctionCallExpression(Ast.VariableExpression(self.scope, self.allocUpvalFunction), {})
					else
						logger:error("Upvalue resolution failed at compile time")
					end
					table.insert(upvalEntries, Ast.TableEntry(expression))
					local uid = #upvalEntries
					upvalueIds[id] = uid
					return uid
				end
				createClosureSubScope:addReferenceToHigherScope(self.scope, self.containerFuncVar)
				createClosureSubScope:addReferenceToHigherScope(createClosureScope, createClosurePosArg)
				createClosureSubScope:addReferenceToHigherScope(createClosureScope, createClosureUpvalsArg, 1)
				createClosureScope:addReferenceToHigherScope(self.scope, self.upvaluesProxyFunctionVar)
				createClosureSubScope:addReferenceToHigherScope(createClosureScope, createClosureProxyObject)
				self:compileTopNode(ast)
				local functionNodeAssignments = {
					{
						var = Ast.AssignmentVariable(self.scope, self.containerFuncVar),
						val = Ast.FunctionLiteralExpression({
							Ast.VariableExpression(self.containerFuncScope, self.posVar),
							Ast.VariableExpression(self.containerFuncScope, self.argsVar),
							Ast.VariableExpression(self.containerFuncScope, self.currentUpvaluesVar),
							Ast.VariableExpression(self.containerFuncScope, self.detectGcCollectVar),
						}, self:emitContainerFuncBody()),
					},
					{
						var = Ast.AssignmentVariable(self.scope, self.createVarargClosureVar),
						val = Ast.FunctionLiteralExpression(
							{
								Ast.VariableExpression(createClosureScope, createClosurePosArg),
								Ast.VariableExpression(createClosureScope, createClosureUpvalsArg),
							},
							Ast.Block({
								Ast.LocalVariableDeclaration(createClosureScope, {
									createClosureProxyObject,
								}, {
									Ast.FunctionCallExpression(
										Ast.VariableExpression(self.scope, self.upvaluesProxyFunctionVar),
										{
											Ast.VariableExpression(createClosureScope, createClosureUpvalsArg),
										}
									),
								}),
								Ast.LocalVariableDeclaration(createClosureScope, { createClosureFuncVar }, {
									Ast.FunctionLiteralExpression(
										{
											Ast.VarargExpression(),
										},
										Ast.Block({
											Ast.ReturnStatement({
												Ast.FunctionCallExpression(
													Ast.VariableExpression(self.scope, self.containerFuncVar),
													{
														Ast.VariableExpression(createClosureScope, createClosurePosArg),
														Ast.TableConstructorExpression({
															Ast.TableEntry(Ast.VarargExpression()),
														}),
														Ast.VariableExpression(
															createClosureScope,
															createClosureUpvalsArg
														),
														Ast.VariableExpression(
															createClosureScope,
															createClosureProxyObject
														),
													}
												),
											}),
										}, createClosureSubScope)
									),
								}),
								Ast.ReturnStatement({
									Ast.VariableExpression(createClosureScope, createClosureFuncVar),
								}),
							}, createClosureScope)
						),
					},
					{
						var = Ast.AssignmentVariable(self.scope, self.upvaluesTable),
						val = Ast.TableConstructorExpression({}),
					},
					{
						var = Ast.AssignmentVariable(self.scope, self.upvaluesReferenceCountsTable),
						val = Ast.TableConstructorExpression({}),
					},
					{
						var = Ast.AssignmentVariable(self.scope, self.allocUpvalFunction),
						val = self:createAllocUpvalFunction(),
					},
					{
						var = Ast.AssignmentVariable(self.scope, self.currentUpvalId),
						val = Ast.NumberExpression(0),
					},
					{
						var = Ast.AssignmentVariable(self.scope, self.upvaluesProxyFunctionVar),
						val = self:createUpvaluesProxyFunc(),
					},
					{
						var = Ast.AssignmentVariable(self.scope, self.upvaluesGcFunctionVar),
						val = self:createUpvaluesGcFunc(),
					},
					{
						var = Ast.AssignmentVariable(self.scope, self.freeUpvalueFunc),
						val = self:createFreeUpvalueFunc(),
					},
				}
				local tbl = {
					Ast.VariableExpression(self.scope, self.containerFuncVar),
					Ast.VariableExpression(self.scope, self.createVarargClosureVar),
					Ast.VariableExpression(self.scope, self.upvaluesTable),
					Ast.VariableExpression(self.scope, self.upvaluesReferenceCountsTable),
					Ast.VariableExpression(self.scope, self.allocUpvalFunction),
					Ast.VariableExpression(self.scope, self.currentUpvalId),
					Ast.VariableExpression(self.scope, self.upvaluesProxyFunctionVar),
					Ast.VariableExpression(self.scope, self.upvaluesGcFunctionVar),
					Ast.VariableExpression(self.scope, self.freeUpvalueFunc),
				}
				for i, entry in pairs(self.createClosureVars) do
					table.insert(functionNodeAssignments, entry)
					table.insert(tbl, Ast.VariableExpression(entry.var.scope, entry.var.id))
				end
				util.shuffle(functionNodeAssignments)
				local assignmentStatLhs, assignmentStatRhs = {}, {}
				for i, v in ipairs(functionNodeAssignments) do
					assignmentStatLhs[i] = v.var
					assignmentStatRhs[i] = v.val
				end
				local functionNode = Ast.FunctionLiteralExpression(
					{
						Ast.VariableExpression(self.scope, self.envVar),
						Ast.VariableExpression(self.scope, self.unpackVar),
						Ast.VariableExpression(self.scope, self.newproxyVar),
						Ast.VariableExpression(self.scope, self.setmetatableVar),
						Ast.VariableExpression(self.scope, self.getmetatableVar),
						Ast.VariableExpression(self.scope, self.selectVar),
						Ast.VariableExpression(self.scope, argVar),
						unpack(util.shuffle(tbl)),
					},
					Ast.Block({
						Ast.AssignmentStatement(assignmentStatLhs, assignmentStatRhs),
						Ast.ReturnStatement({
							Ast.FunctionCallExpression(
								Ast.FunctionCallExpression(
									Ast.VariableExpression(self.scope, self.createVarargClosureVar),
									{
										Ast.NumberExpression(self.startBlockId),
										Ast.TableConstructorExpression(upvalEntries),
									}
								),
								{
									Ast.FunctionCallExpression(
										Ast.VariableExpression(self.scope, self.unpackVar),
										{ Ast.VariableExpression(self.scope, argVar) }
									),
								}
							),
						}),
					}, self.scope)
				)
				return Ast.TopNode(
					Ast.Block({
						Ast.ReturnStatement({
							Ast.FunctionCallExpression(functionNode, {
								Ast.OrExpression(
									Ast.AndExpression(
										Ast.VariableExpression(newGlobalScope, getfenvVar),
										Ast.FunctionCallExpression(
											Ast.VariableExpression(newGlobalScope, getfenvVar),
											{}
										)
									),
									Ast.VariableExpression(newGlobalScope, envVar)
								),
								Ast.OrExpression(
									Ast.VariableExpression(newGlobalScope, unpackVar),
									Ast.IndexExpression(
										Ast.VariableExpression(newGlobalScope, tableVar),
										Ast.StringExpression("unpack")
									)
								),
								Ast.VariableExpression(newGlobalScope, newproxyVar),
								Ast.VariableExpression(newGlobalScope, setmetatableVar),
								Ast.VariableExpression(newGlobalScope, getmetatableVar),
								Ast.VariableExpression(newGlobalScope, selectVar),
								Ast.TableConstructorExpression({
									Ast.TableEntry(Ast.VarargExpression()),
								}),
							}),
						}),
					}, psc),
					newGlobalScope
				)
			end
			function Compiler:getCreateClosureVar(argCount)
				if not self.createClosureVars[argCount] then
					local var = Ast.AssignmentVariable(self.scope, self.scope:addVariable())
					local createClosureScope = Scope:new(self.scope)
					local createClosureSubScope = Scope:new(createClosureScope)
					local createClosurePosArg = createClosureScope:addVariable()
					local createClosureUpvalsArg = createClosureScope:addVariable()
					local createClosureProxyObject = createClosureScope:addVariable()
					local createClosureFuncVar = createClosureScope:addVariable()
					createClosureSubScope:addReferenceToHigherScope(self.scope, self.containerFuncVar)
					createClosureSubScope:addReferenceToHigherScope(createClosureScope, createClosurePosArg)
					createClosureSubScope:addReferenceToHigherScope(createClosureScope, createClosureUpvalsArg, 1)
					createClosureScope:addReferenceToHigherScope(self.scope, self.upvaluesProxyFunctionVar)
					createClosureSubScope:addReferenceToHigherScope(createClosureScope, createClosureProxyObject)
					local argsTb, argsTb2 = {}, {}
					for i = 1, argCount do
						local arg = createClosureSubScope:addVariable()
						argsTb[i] = Ast.VariableExpression(createClosureSubScope, arg)
						argsTb2[i] = Ast.TableEntry(Ast.VariableExpression(createClosureSubScope, arg))
					end
					local val = Ast.FunctionLiteralExpression(
						{
							Ast.VariableExpression(createClosureScope, createClosurePosArg),
							Ast.VariableExpression(createClosureScope, createClosureUpvalsArg),
						},
						Ast.Block({
							Ast.LocalVariableDeclaration(createClosureScope, {
								createClosureProxyObject,
							}, {
								Ast.FunctionCallExpression(
									Ast.VariableExpression(self.scope, self.upvaluesProxyFunctionVar),
									{
										Ast.VariableExpression(createClosureScope, createClosureUpvalsArg),
									}
								),
							}),
							Ast.LocalVariableDeclaration(createClosureScope, { createClosureFuncVar }, {
								Ast.FunctionLiteralExpression(
									argsTb,
									Ast.Block({
										Ast.ReturnStatement({
											Ast.FunctionCallExpression(
												Ast.VariableExpression(self.scope, self.containerFuncVar),
												{
													Ast.VariableExpression(createClosureScope, createClosurePosArg),
													Ast.TableConstructorExpression(argsTb2),
													Ast.VariableExpression(createClosureScope, createClosureUpvalsArg),
													Ast.VariableExpression(
														createClosureScope,
														createClosureProxyObject
													),
												}
											),
										}),
									}, createClosureSubScope)
								),
							}),
							Ast.ReturnStatement({ Ast.VariableExpression(createClosureScope, createClosureFuncVar) }),
						}, createClosureScope)
					)
					self.createClosureVars[argCount] = {
						var = var,
						val = val,
					}
				end
				local var = self.createClosureVars[argCount].var
				return var.scope, var.id
			end
			function Compiler:pushRegisterUsageInfo()
				table.insert(self.registerUsageStack, {
					usedRegisters = self.usedRegisters,
					registers = self.registers,
				})
				self.usedRegisters = 0
				self.registers = {}
			end
			function Compiler:popRegisterUsageInfo()
				local info = table.remove(self.registerUsageStack)
				self.usedRegisters = info.usedRegisters
				self.registers = info.registers
			end
			function Compiler:createUpvaluesGcFunc()
				local scope = Scope:new(self.scope)
				local selfVar = scope:addVariable()
				local iteratorVar = scope:addVariable()
				local valueVar = scope:addVariable()
				local whileScope = Scope:new(scope)
				whileScope:addReferenceToHigherScope(self.scope, self.upvaluesReferenceCountsTable, 3)
				whileScope:addReferenceToHigherScope(scope, valueVar, 3)
				whileScope:addReferenceToHigherScope(scope, iteratorVar, 3)
				local ifScope = Scope:new(whileScope)
				ifScope:addReferenceToHigherScope(self.scope, self.upvaluesReferenceCountsTable, 1)
				ifScope:addReferenceToHigherScope(self.scope, self.upvaluesTable, 1)
				return Ast.FunctionLiteralExpression(
					{ Ast.VariableExpression(scope, selfVar) },
					Ast.Block({
						Ast.LocalVariableDeclaration(scope, { iteratorVar, valueVar }, {
							Ast.NumberExpression(1),
							Ast.IndexExpression(Ast.VariableExpression(scope, selfVar), Ast.NumberExpression(1)),
						}),
						Ast.WhileStatement(
							Ast.Block({
								Ast.AssignmentStatement({
									Ast.AssignmentIndexing(
										Ast.VariableExpression(self.scope, self.upvaluesReferenceCountsTable),
										Ast.VariableExpression(scope, valueVar)
									),
									Ast.AssignmentVariable(scope, iteratorVar),
								}, {
									Ast.SubExpression(
										Ast.IndexExpression(
											Ast.VariableExpression(self.scope, self.upvaluesReferenceCountsTable),
											Ast.VariableExpression(scope, valueVar)
										),
										Ast.NumberExpression(1)
									),
									Ast.AddExpression(unpack(util.shuffle({
										Ast.VariableExpression(scope, iteratorVar),
										Ast.NumberExpression(1),
									}))),
								}),
								Ast.IfStatement(
									Ast.EqualsExpression(unpack(util.shuffle({
										Ast.IndexExpression(
											Ast.VariableExpression(self.scope, self.upvaluesReferenceCountsTable),
											Ast.VariableExpression(scope, valueVar)
										),
										Ast.NumberExpression(0),
									}))),
									Ast.Block({
										Ast.AssignmentStatement({
											Ast.AssignmentIndexing(
												Ast.VariableExpression(self.scope, self.upvaluesReferenceCountsTable),
												Ast.VariableExpression(scope, valueVar)
											),
											Ast.AssignmentIndexing(
												Ast.VariableExpression(self.scope, self.upvaluesTable),
												Ast.VariableExpression(scope, valueVar)
											),
										}, {
											Ast.NilExpression(),
											Ast.NilExpression(),
										}),
									}, ifScope),
									{},
									nil
								),
								Ast.AssignmentStatement({
									Ast.AssignmentVariable(scope, valueVar),
								}, {
									Ast.IndexExpression(
										Ast.VariableExpression(scope, selfVar),
										Ast.VariableExpression(scope, iteratorVar)
									),
								}),
							}, whileScope),
							Ast.VariableExpression(scope, valueVar),
							scope
						),
					}, scope)
				)
			end
			function Compiler:createFreeUpvalueFunc()
				local scope = Scope:new(self.scope)
				local argVar = scope:addVariable()
				local ifScope = Scope:new(scope)
				ifScope:addReferenceToHigherScope(scope, argVar, 3)
				scope:addReferenceToHigherScope(self.scope, self.upvaluesReferenceCountsTable, 2)
				return Ast.FunctionLiteralExpression(
					{ Ast.VariableExpression(scope, argVar) },
					Ast.Block({
						Ast.AssignmentStatement({
							Ast.AssignmentIndexing(
								Ast.VariableExpression(self.scope, self.upvaluesReferenceCountsTable),
								Ast.VariableExpression(scope, argVar)
							),
						}, {
							Ast.SubExpression(
								Ast.IndexExpression(
									Ast.VariableExpression(self.scope, self.upvaluesReferenceCountsTable),
									Ast.VariableExpression(scope, argVar)
								),
								Ast.NumberExpression(1)
							),
						}),
						Ast.IfStatement(
							Ast.EqualsExpression(unpack(util.shuffle({
								Ast.IndexExpression(
									Ast.VariableExpression(self.scope, self.upvaluesReferenceCountsTable),
									Ast.VariableExpression(scope, argVar)
								),
								Ast.NumberExpression(0),
							}))),
							Ast.Block({
								Ast.AssignmentStatement({
									Ast.AssignmentIndexing(
										Ast.VariableExpression(self.scope, self.upvaluesReferenceCountsTable),
										Ast.VariableExpression(scope, argVar)
									),
									Ast.AssignmentIndexing(
										Ast.VariableExpression(self.scope, self.upvaluesTable),
										Ast.VariableExpression(scope, argVar)
									),
								}, {
									Ast.NilExpression(),
									Ast.NilExpression(),
								}),
							}, ifScope),
							{},
							nil
						),
					}, scope)
				)
			end
			function Compiler:createUpvaluesProxyFunc()
				local scope = Scope:new(self.scope)
				scope:addReferenceToHigherScope(self.scope, self.newproxyVar)
				local entriesVar = scope:addVariable()
				local ifScope = Scope:new(scope)
				local proxyVar = ifScope:addVariable()
				local metatableVar = ifScope:addVariable()
				local elseScope = Scope:new(scope)
				ifScope:addReferenceToHigherScope(self.scope, self.newproxyVar)
				ifScope:addReferenceToHigherScope(self.scope, self.getmetatableVar)
				ifScope:addReferenceToHigherScope(self.scope, self.upvaluesGcFunctionVar)
				ifScope:addReferenceToHigherScope(scope, entriesVar)
				elseScope:addReferenceToHigherScope(self.scope, self.setmetatableVar)
				elseScope:addReferenceToHigherScope(scope, entriesVar)
				elseScope:addReferenceToHigherScope(self.scope, self.upvaluesGcFunctionVar)
				local forScope = Scope:new(scope)
				local forArg = forScope:addVariable()
				forScope:addReferenceToHigherScope(self.scope, self.upvaluesReferenceCountsTable, 2)
				forScope:addReferenceToHigherScope(scope, entriesVar, 2)
				return Ast.FunctionLiteralExpression(
					{ Ast.VariableExpression(scope, entriesVar) },
					Ast.Block({
						Ast.ForStatement(
							forScope,
							forArg,
							Ast.NumberExpression(1),
							Ast.LenExpression(Ast.VariableExpression(scope, entriesVar)),
							Ast.NumberExpression(1),
							Ast.Block({
								Ast.AssignmentStatement({
									Ast.AssignmentIndexing(
										Ast.VariableExpression(self.scope, self.upvaluesReferenceCountsTable),
										Ast.IndexExpression(
											Ast.VariableExpression(scope, entriesVar),
											Ast.VariableExpression(forScope, forArg)
										)
									),
								}, {
									Ast.AddExpression(unpack(util.shuffle({
										Ast.IndexExpression(
											Ast.VariableExpression(self.scope, self.upvaluesReferenceCountsTable),
											Ast.IndexExpression(
												Ast.VariableExpression(scope, entriesVar),
												Ast.VariableExpression(forScope, forArg)
											)
										),
										Ast.NumberExpression(1),
									}))),
								}),
							}, forScope),
							scope
						),
						Ast.IfStatement(
							Ast.VariableExpression(self.scope, self.newproxyVar),
							Ast.Block({
								Ast.LocalVariableDeclaration(ifScope, { proxyVar }, {
									Ast.FunctionCallExpression(Ast.VariableExpression(self.scope, self.newproxyVar), {
										Ast.BooleanExpression(true),
									}),
								}),
								Ast.LocalVariableDeclaration(ifScope, { metatableVar }, {
									Ast.FunctionCallExpression(
										Ast.VariableExpression(self.scope, self.getmetatableVar),
										{
											Ast.VariableExpression(ifScope, proxyVar),
										}
									),
								}),
								Ast.AssignmentStatement({
									Ast.AssignmentIndexing(
										Ast.VariableExpression(ifScope, metatableVar),
										Ast.StringExpression("__index")
									),
									Ast.AssignmentIndexing(
										Ast.VariableExpression(ifScope, metatableVar),
										Ast.StringExpression("__gc")
									),
									Ast.AssignmentIndexing(
										Ast.VariableExpression(ifScope, metatableVar),
										Ast.StringExpression("__len")
									),
								}, {
									Ast.VariableExpression(scope, entriesVar),
									Ast.VariableExpression(self.scope, self.upvaluesGcFunctionVar),
									Ast.FunctionLiteralExpression(
										{},
										Ast.Block({
											Ast.ReturnStatement({ Ast.NumberExpression(self.upvalsProxyLenReturn) }),
										}, Scope:new(ifScope))
									),
								}),
								Ast.ReturnStatement({
									Ast.VariableExpression(ifScope, proxyVar),
								}),
							}, ifScope),
							{},
							Ast.Block({
								Ast.ReturnStatement({
									Ast.FunctionCallExpression(
										Ast.VariableExpression(self.scope, self.setmetatableVar),
										{
											Ast.TableConstructorExpression({}),
											Ast.TableConstructorExpression({
												Ast.KeyedTableEntry(
													Ast.StringExpression("__gc"),
													Ast.VariableExpression(self.scope, self.upvaluesGcFunctionVar)
												),
												Ast.KeyedTableEntry(
													Ast.StringExpression("__index"),
													Ast.VariableExpression(scope, entriesVar)
												),
												Ast.KeyedTableEntry(
													Ast.StringExpression("__len"),
													Ast.FunctionLiteralExpression(
														{},
														Ast.Block({
															Ast.ReturnStatement({
																Ast.NumberExpression(self.upvalsProxyLenReturn),
															}),
														}, Scope:new(ifScope))
													)
												),
											}),
										}
									),
								}),
							}, elseScope)
						),
					}, scope)
				)
			end
			function Compiler:createAllocUpvalFunction()
				local scope = Scope:new(self.scope)
				scope:addReferenceToHigherScope(self.scope, self.currentUpvalId, 4)
				scope:addReferenceToHigherScope(self.scope, self.upvaluesReferenceCountsTable, 1)
				return Ast.FunctionLiteralExpression(
					{},
					Ast.Block({
						Ast.AssignmentStatement({
							Ast.AssignmentVariable(self.scope, self.currentUpvalId),
						}, {
							Ast.AddExpression(unpack(util.shuffle({
								Ast.VariableExpression(self.scope, self.currentUpvalId),
								Ast.NumberExpression(1),
							}))),
						}),
						Ast.AssignmentStatement({
							Ast.AssignmentIndexing(
								Ast.VariableExpression(self.scope, self.upvaluesReferenceCountsTable),
								Ast.VariableExpression(self.scope, self.currentUpvalId)
							),
						}, {
							Ast.NumberExpression(1),
						}),
						Ast.ReturnStatement({
							Ast.VariableExpression(self.scope, self.currentUpvalId),
						}),
					}, scope)
				)
			end
			function Compiler:emitContainerFuncBody()
				local blocks = {}
				util.shuffle(self.blocks)
				for _, block in ipairs(self.blocks) do
					local id = block.id
					local blockstats = block.statements
					for i = 2, #blockstats do
						local stat = blockstats[i]
						local reads = stat.reads
						local writes = stat.writes
						local maxShift = 0
						local usesUpvals = stat.usesUpvals
						for shift = 1, i - 1 do
							local stat2 = blockstats[i - shift]
							if stat2.usesUpvals and usesUpvals then
								break
							end
							local reads2 = stat2.reads
							local writes2 = stat2.writes
							local f = true
							for r, b in pairs(reads2) do
								if writes[r] then
									f = false
									break
								end
							end
							if f then
								for r, b in pairs(writes2) do
									if writes[r] then
										f = false
										break
									end
									if reads[r] then
										f = false
										break
									end
								end
							end
							if not f then
								break
							end
							maxShift = shift
						end
						local shift = math.random(0, maxShift)
						for j = 1, shift do
							blockstats[i - j], blockstats[i - j + 1] = blockstats[i - j + 1], blockstats[i - j]
						end
					end
					blockstats = {}
					for i, stat in ipairs(block.statements) do
						table.insert(blockstats, stat.statement)
					end
					table.insert(blocks, { id = id, block = Ast.Block(blockstats, block.scope) })
				end
				table.sort(blocks, function(a, b)
					return a.id < b.id
				end)
				local function buildIfBlock(scope, id, lBlock, rBlock)
					return Ast.Block({
						Ast.IfStatement(
							Ast.LessThanExpression(self:pos(scope), Ast.NumberExpression(id)),
							lBlock,
							{},
							rBlock
						),
					}, scope)
				end
				local function buildWhileBody(tb, l, r, pScope, scope)
					local len = r - l + 1
					if len == 1 then
						tb[r].block.scope:setParent(pScope)
						return tb[r].block
					elseif len == 0 then
						return nil
					end
					local splitBias = math.random(0, 1)
					local mid = l + math.floor(len / 2) + splitBias
					if mid > r then
						mid = r
					end
					if mid <= l then
						mid = l + 1
					end
					local bound = math.random(tb[mid - 1].id + 1, tb[mid].id)
					local ifScope = scope or Scope:new(pScope)
					local lBlock = buildWhileBody(tb, l, mid - 1, ifScope)
					local rBlock = buildWhileBody(tb, mid, r, ifScope)
					return buildIfBlock(ifScope, bound, lBlock, rBlock)
				end
				local whileBody = buildWhileBody(blocks, 1, #blocks, self.containerFuncScope, self.whileScope)
				self.whileScope:addReferenceToHigherScope(self.containerFuncScope, self.returnVar, 1)
				self.whileScope:addReferenceToHigherScope(self.containerFuncScope, self.posVar)
				self.containerFuncScope:addReferenceToHigherScope(self.scope, self.unpackVar)
				local declarations = {
					self.returnVar,
				}
				for i, var in pairs(self.registerVars) do
					if i ~= MAX_REGS then
						table.insert(declarations, var)
					end
				end
				local stats = {
					Ast.LocalVariableDeclaration(self.containerFuncScope, util.shuffle(declarations), {}),
					Ast.WhileStatement(whileBody, Ast.VariableExpression(self.containerFuncScope, self.posVar)),
					Ast.AssignmentStatement({
						Ast.AssignmentVariable(self.containerFuncScope, self.posVar),
					}, {
						Ast.LenExpression(Ast.VariableExpression(self.containerFuncScope, self.detectGcCollectVar)),
					}),
					Ast.ReturnStatement({
						Ast.FunctionCallExpression(Ast.VariableExpression(self.scope, self.unpackVar), {
							Ast.VariableExpression(self.containerFuncScope, self.returnVar),
						}),
					}),
				}
				if self.maxUsedRegister >= MAX_REGS then
					table.insert(
						stats,
						1,
						Ast.LocalVariableDeclaration(
							self.containerFuncScope,
							{ self.registerVars[MAX_REGS] },
							{ Ast.TableConstructorExpression({}) }
						)
					)
				end
				return Ast.Block(stats, self.containerFuncScope)
			end
			function Compiler:freeRegister(id, force)
				if force or not (self.registers[id] == self.VAR_REGISTER) then
					self.usedRegisters = self.usedRegisters - 1
					self.registers[id] = false
				end
			end
			function Compiler:isVarRegister(id)
				return self.registers[id] == self.VAR_REGISTER
			end
			function Compiler:allocRegister(isVar)
				self.usedRegisters = self.usedRegisters + 1
				if not isVar then
					if not self.registers[self.POS_REGISTER] then
						self.registers[self.POS_REGISTER] = true
						return self.POS_REGISTER
					end
					if not self.registers[self.RETURN_REGISTER] then
						self.registers[self.RETURN_REGISTER] = true
						return self.RETURN_REGISTER
					end
				end
				local id = 0
				if self.usedRegisters < MAX_REGS * MAX_REGS_MUL then
					repeat
						id = math.random(1, MAX_REGS - 1)
					until not self.registers[id]
				else
					repeat
						id = id + 1
					until not self.registers[id]
				end
				if id > self.maxUsedRegister then
					self.maxUsedRegister = id
				end
				if isVar then
					self.registers[id] = self.VAR_REGISTER
				else
					self.registers[id] = true
				end
				return id
			end
			function Compiler:isUpvalue(scope, id)
				return self.upvalVars[scope] and self.upvalVars[scope][id]
			end
			function Compiler:makeUpvalue(scope, id)
				if not self.upvalVars[scope] then
					self.upvalVars[scope] = {}
				end
				self.upvalVars[scope][id] = true
			end
			function Compiler:getVarRegister(scope, id, functionDepth, potentialId)
				if not self.registersForVar[scope] then
					self.registersForVar[scope] = {}
					self.scopeFunctionDepths[scope] = functionDepth
				end
				local reg = self.registersForVar[scope][id]
				if not reg then
					if
						potentialId
						and self.registers[potentialId] ~= self.VAR_REGISTER
						and potentialId ~= self.POS_REGISTER
						and potentialId ~= self.RETURN_REGISTER
					then
						self.registers[potentialId] = self.VAR_REGISTER
						reg = potentialId
					else
						reg = self:allocRegister(true)
					end
					self.registersForVar[scope][id] = reg
				end
				return reg
			end
			function Compiler:getRegisterVarId(id)
				local varId = self.registerVars[id]
				if not varId then
					varId = self.containerFuncScope:addVariable()
					self.registerVars[id] = varId
				end
				return varId
			end
			function Compiler:register(scope, id)
				if id == self.POS_REGISTER then
					return self:pos(scope)
				end
				if id == self.RETURN_REGISTER then
					return self:getReturn(scope)
				end
				if id < MAX_REGS then
					local vid = self:getRegisterVarId(id)
					scope:addReferenceToHigherScope(self.containerFuncScope, vid)
					return Ast.VariableExpression(self.containerFuncScope, vid)
				end
				local vid = self:getRegisterVarId(MAX_REGS)
				scope:addReferenceToHigherScope(self.containerFuncScope, vid)
				return Ast.IndexExpression(
					Ast.VariableExpression(self.containerFuncScope, vid),
					Ast.NumberExpression((id - MAX_REGS) + 1)
				)
			end
			function Compiler:registerList(scope, ids)
				local l = {}
				for i, id in ipairs(ids) do
					table.insert(l, self:register(scope, id))
				end
				return l
			end
			function Compiler:registerAssignment(scope, id)
				if id == self.POS_REGISTER then
					return self:posAssignment(scope)
				end
				if id == self.RETURN_REGISTER then
					return self:returnAssignment(scope)
				end
				if id < MAX_REGS then
					local vid = self:getRegisterVarId(id)
					scope:addReferenceToHigherScope(self.containerFuncScope, vid)
					return Ast.AssignmentVariable(self.containerFuncScope, vid)
				end
				local vid = self:getRegisterVarId(MAX_REGS)
				scope:addReferenceToHigherScope(self.containerFuncScope, vid)
				return Ast.AssignmentIndexing(
					Ast.VariableExpression(self.containerFuncScope, vid),
					Ast.NumberExpression((id - MAX_REGS) + 1)
				)
			end
			function Compiler:setRegister(scope, id, val, compundArg)
				if compundArg then
					return compundArg(self:registerAssignment(scope, id), val)
				end
				return Ast.AssignmentStatement({
					self:registerAssignment(scope, id),
				}, {
					val,
				})
			end
			function Compiler:setRegisters(scope, ids, vals)
				local idStats = {}
				for i, id in ipairs(ids) do
					table.insert(idStats, self:registerAssignment(scope, id))
				end
				return Ast.AssignmentStatement(idStats, vals)
			end
			function Compiler:copyRegisters(scope, to, from)
				local idStats = {}
				local vals = {}
				for i, id in ipairs(to) do
					local from = from[i]
					if from ~= id then
						table.insert(idStats, self:registerAssignment(scope, id))
						table.insert(vals, self:register(scope, from))
					end
				end
				if #idStats > 0 and #vals > 0 then
					return Ast.AssignmentStatement(idStats, vals)
				end
			end
			function Compiler:resetRegisters()
				self.registers = {}
			end
			function Compiler:pos(scope)
				scope:addReferenceToHigherScope(self.containerFuncScope, self.posVar)
				return Ast.VariableExpression(self.containerFuncScope, self.posVar)
			end
			function Compiler:posAssignment(scope)
				scope:addReferenceToHigherScope(self.containerFuncScope, self.posVar)
				return Ast.AssignmentVariable(self.containerFuncScope, self.posVar)
			end
			function Compiler:args(scope)
				scope:addReferenceToHigherScope(self.containerFuncScope, self.argsVar)
				return Ast.VariableExpression(self.containerFuncScope, self.argsVar)
			end
			function Compiler:unpack(scope)
				scope:addReferenceToHigherScope(self.scope, self.unpackVar)
				return Ast.VariableExpression(self.scope, self.unpackVar)
			end
			function Compiler:env(scope)
				scope:addReferenceToHigherScope(self.scope, self.envVar)
				return Ast.VariableExpression(self.scope, self.envVar)
			end
			function Compiler:jmp(scope, to)
				scope:addReferenceToHigherScope(self.containerFuncScope, self.posVar)
				return Ast.AssignmentStatement({ Ast.AssignmentVariable(self.containerFuncScope, self.posVar) }, { to })
			end
			function Compiler:setPos(scope, val)
				if not val then
					local v = Ast.IndexExpression(self:env(scope), randomStrings.randomStringNode(math.random(12, 14)))
					scope:addReferenceToHigherScope(self.containerFuncScope, self.posVar)
					return Ast.AssignmentStatement(
						{ Ast.AssignmentVariable(self.containerFuncScope, self.posVar) },
						{ v }
					)
				end
				scope:addReferenceToHigherScope(self.containerFuncScope, self.posVar)
				return Ast.AssignmentStatement(
					{ Ast.AssignmentVariable(self.containerFuncScope, self.posVar) },
					{ Ast.NumberExpression(val) or Ast.NilExpression() }
				)
			end
			function Compiler:setReturn(scope, val)
				scope:addReferenceToHigherScope(self.containerFuncScope, self.returnVar)
				return Ast.AssignmentStatement(
					{ Ast.AssignmentVariable(self.containerFuncScope, self.returnVar) },
					{ val }
				)
			end
			function Compiler:getReturn(scope)
				scope:addReferenceToHigherScope(self.containerFuncScope, self.returnVar)
				return Ast.VariableExpression(self.containerFuncScope, self.returnVar)
			end
			function Compiler:returnAssignment(scope)
				scope:addReferenceToHigherScope(self.containerFuncScope, self.returnVar)
				return Ast.AssignmentVariable(self.containerFuncScope, self.returnVar)
			end
			function Compiler:setUpvalueMember(scope, idExpr, valExpr, compoundConstructor)
				scope:addReferenceToHigherScope(self.scope, self.upvaluesTable)
				if compoundConstructor then
					return compoundConstructor(
						Ast.AssignmentIndexing(Ast.VariableExpression(self.scope, self.upvaluesTable), idExpr),
						valExpr
					)
				end
				return Ast.AssignmentStatement(
					{ Ast.AssignmentIndexing(Ast.VariableExpression(self.scope, self.upvaluesTable), idExpr) },
					{ valExpr }
				)
			end
			function Compiler:getUpvalueMember(scope, idExpr)
				scope:addReferenceToHigherScope(self.scope, self.upvaluesTable)
				return Ast.IndexExpression(Ast.VariableExpression(self.scope, self.upvaluesTable), idExpr)
			end
			function Compiler:compileTopNode(node)
				local startBlock = self:createBlock()
				local scope = startBlock.scope
				self.startBlockId = startBlock.id
				self:setActiveBlock(startBlock)
				local varAccessLookup = lookupify({
					AstKind.AssignmentVariable,
					AstKind.VariableExpression,
					AstKind.FunctionDeclaration,
					AstKind.LocalFunctionDeclaration,
				})
				local functionLookup = lookupify({
					AstKind.FunctionDeclaration,
					AstKind.LocalFunctionDeclaration,
					AstKind.FunctionLiteralExpression,
					AstKind.TopNode,
				})
				visitast(node, function(node, data)
					if node.kind == AstKind.Block then
						node.scope.__depth = data.functionData.depth
					end
					if varAccessLookup[node.kind] then
						if not node.scope.isGlobal then
							if node.scope.__depth < data.functionData.depth then
								if not self:isUpvalue(node.scope, node.id) then
									self:makeUpvalue(node.scope, node.id)
								end
							end
						end
					end
				end, nil, nil)
				self.varargReg = self:allocRegister(true)
				scope:addReferenceToHigherScope(self.containerFuncScope, self.argsVar)
				scope:addReferenceToHigherScope(self.scope, self.selectVar)
				scope:addReferenceToHigherScope(self.scope, self.unpackVar)
				self:addStatement(
					self:setRegister(
						scope,
						self.varargReg,
						Ast.VariableExpression(self.containerFuncScope, self.argsVar)
					),
					{ self.varargReg },
					{},
					false
				)
				self:compileBlock(node.body, 0)
				if self.activeBlock.advanceToNextBlock then
					self:addStatement(self:setPos(self.activeBlock.scope, nil), { self.POS_REGISTER }, {}, false)
					self:addStatement(
						self:setReturn(self.activeBlock.scope, Ast.TableConstructorExpression({})),
						{ self.RETURN_REGISTER },
						{},
						false
					)
					self.activeBlock.advanceToNextBlock = false
				end
				self:resetRegisters()
			end
			function Compiler:compileFunction(node, funcDepth)
				funcDepth = funcDepth + 1
				local oldActiveBlock = self.activeBlock
				local upperVarargReg = self.varargReg
				self.varargReg = nil
				local upvalueExpressions = {}
				local upvalueIds = {}
				local usedRegs = {}
				local oldGetUpvalueId = self.getUpvalueId
				self.getUpvalueId = function(self, scope, id)
					if not upvalueIds[scope] then
						upvalueIds[scope] = {}
					end
					if upvalueIds[scope][id] then
						return upvalueIds[scope][id]
					end
					local scopeFuncDepth = self.scopeFunctionDepths[scope]
					local expression
					if scopeFuncDepth == funcDepth then
						oldActiveBlock.scope:addReferenceToHigherScope(self.scope, self.allocUpvalFunction)
						expression =
							Ast.FunctionCallExpression(Ast.VariableExpression(self.scope, self.allocUpvalFunction), {})
					elseif scopeFuncDepth == funcDepth - 1 then
						local varReg = self:getVarRegister(scope, id, scopeFuncDepth, nil)
						expression = self:register(oldActiveBlock.scope, varReg)
						table.insert(usedRegs, varReg)
					else
						local higherId = oldGetUpvalueId(self, scope, id)
						oldActiveBlock.scope:addReferenceToHigherScope(self.containerFuncScope, self.currentUpvaluesVar)
						expression = Ast.IndexExpression(
							Ast.VariableExpression(self.containerFuncScope, self.currentUpvaluesVar),
							Ast.NumberExpression(higherId)
						)
					end
					table.insert(upvalueExpressions, Ast.TableEntry(expression))
					local uid = #upvalueExpressions
					upvalueIds[scope][id] = uid
					return uid
				end
				local block = self:createBlock()
				self:setActiveBlock(block)
				local scope = self.activeBlock.scope
				self:pushRegisterUsageInfo()
				for i, arg in ipairs(node.args) do
					if arg.kind == AstKind.VariableExpression then
						if self:isUpvalue(arg.scope, arg.id) then
							scope:addReferenceToHigherScope(self.scope, self.allocUpvalFunction)
							local argReg = self:getVarRegister(arg.scope, arg.id, funcDepth, nil)
							self:addStatement(
								self:setRegister(
									scope,
									argReg,
									Ast.FunctionCallExpression(
										Ast.VariableExpression(self.scope, self.allocUpvalFunction),
										{}
									)
								),
								{ argReg },
								{},
								false
							)
							self:addStatement(
								self:setUpvalueMember(
									scope,
									self:register(scope, argReg),
									Ast.IndexExpression(
										Ast.VariableExpression(self.containerFuncScope, self.argsVar),
										Ast.NumberExpression(i)
									)
								),
								{},
								{ argReg },
								true
							)
						else
							local argReg = self:getVarRegister(arg.scope, arg.id, funcDepth, nil)
							scope:addReferenceToHigherScope(self.containerFuncScope, self.argsVar)
							self:addStatement(
								self:setRegister(
									scope,
									argReg,
									Ast.IndexExpression(
										Ast.VariableExpression(self.containerFuncScope, self.argsVar),
										Ast.NumberExpression(i)
									)
								),
								{ argReg },
								{},
								false
							)
						end
					else
						self.varargReg = self:allocRegister(true)
						scope:addReferenceToHigherScope(self.containerFuncScope, self.argsVar)
						scope:addReferenceToHigherScope(self.scope, self.selectVar)
						scope:addReferenceToHigherScope(self.scope, self.unpackVar)
						self:addStatement(
							self:setRegister(
								scope,
								self.varargReg,
								Ast.TableConstructorExpression({
									Ast.TableEntry(
										Ast.FunctionCallExpression(Ast.VariableExpression(self.scope, self.selectVar), {
											Ast.NumberExpression(i),
											Ast.FunctionCallExpression(
												Ast.VariableExpression(self.scope, self.unpackVar),
												{
													Ast.VariableExpression(self.containerFuncScope, self.argsVar),
												}
											),
										})
									),
								})
							),
							{ self.varargReg },
							{},
							false
						)
					end
				end
				self:compileBlock(node.body, funcDepth)
				if self.activeBlock.advanceToNextBlock then
					self:addStatement(self:setPos(self.activeBlock.scope, nil), { self.POS_REGISTER }, {}, false)
					self:addStatement(
						self:setReturn(self.activeBlock.scope, Ast.TableConstructorExpression({})),
						{ self.RETURN_REGISTER },
						{},
						false
					)
					self.activeBlock.advanceToNextBlock = false
				end
				if self.varargReg then
					self:freeRegister(self.varargReg, true)
				end
				self.varargReg = upperVarargReg
				self.getUpvalueId = oldGetUpvalueId
				self:popRegisterUsageInfo()
				self:setActiveBlock(oldActiveBlock)
				local scope = self.activeBlock.scope
				local retReg = self:allocRegister(false)
				local isVarargFunction = #node.args > 0 and node.args[#node.args].kind == AstKind.VarargExpression
				local retrieveExpression
				if isVarargFunction then
					scope:addReferenceToHigherScope(self.scope, self.createVarargClosureVar)
					retrieveExpression =
						Ast.FunctionCallExpression(Ast.VariableExpression(self.scope, self.createVarargClosureVar), {
							Ast.NumberExpression(block.id),
							Ast.TableConstructorExpression(upvalueExpressions),
						})
				else
					local varScope, var = self:getCreateClosureVar(#node.args + math.random(0, 5))
					scope:addReferenceToHigherScope(varScope, var)
					retrieveExpression = Ast.FunctionCallExpression(Ast.VariableExpression(varScope, var), {
						Ast.NumberExpression(block.id),
						Ast.TableConstructorExpression(upvalueExpressions),
					})
				end
				self:addStatement(self:setRegister(scope, retReg, retrieveExpression), { retReg }, usedRegs, false)
				return retReg
			end
			function Compiler:compileBlock(block, funcDepth)
				for i, stat in ipairs(block.statements) do
					self:compileStatement(stat, funcDepth)
				end
				local scope = self.activeBlock.scope
				for id, name in ipairs(block.scope.variables) do
					local varReg = self:getVarRegister(block.scope, id, funcDepth, nil)
					if self:isUpvalue(block.scope, id) then
						scope:addReferenceToHigherScope(self.scope, self.freeUpvalueFunc)
						self:addStatement(
							self:setRegister(
								scope,
								varReg,
								Ast.FunctionCallExpression(Ast.VariableExpression(self.scope, self.freeUpvalueFunc), {
									self:register(scope, varReg),
								})
							),
							{ varReg },
							{ varReg },
							false
						)
					else
						self:addStatement(self:setRegister(scope, varReg, Ast.NilExpression()), { varReg }, {}, false)
					end
					self:freeRegister(varReg, true)
				end
			end
			function Compiler:compileStatement(statement, funcDepth)
				local scope = self.activeBlock.scope
				if statement.kind == AstKind.ReturnStatement then
					local entries = {}
					local regs = {}
					for i, expr in ipairs(statement.args) do
						if
							i == #statement.args
							and (
								expr.kind == AstKind.FunctionCallExpression
								or expr.kind == AstKind.PassSelfFunctionCallExpression
								or expr.kind == AstKind.VarargExpression
							)
						then
							local reg = self:compileExpression(expr, funcDepth, self.RETURN_ALL)[1]
							table.insert(
								entries,
								Ast.TableEntry(
									Ast.FunctionCallExpression(self:unpack(scope), { self:register(scope, reg) })
								)
							)
							table.insert(regs, reg)
						else
							local reg = self:compileExpression(expr, funcDepth, 1)[1]
							table.insert(entries, Ast.TableEntry(self:register(scope, reg)))
							table.insert(regs, reg)
						end
					end
					for _, reg in ipairs(regs) do
						self:freeRegister(reg, false)
					end
					self:addStatement(
						self:setReturn(scope, Ast.TableConstructorExpression(entries)),
						{ self.RETURN_REGISTER },
						regs,
						false
					)
					self:addStatement(self:setPos(self.activeBlock.scope, nil), { self.POS_REGISTER }, {}, false)
					self.activeBlock.advanceToNextBlock = false
					return
				end
				if statement.kind == AstKind.LocalVariableDeclaration then
					local exprregs = {}
					for i, expr in ipairs(statement.expressions) do
						if i == #statement.expressions and #statement.ids > #statement.expressions then
							local regs =
								self:compileExpression(expr, funcDepth, #statement.ids - #statement.expressions + 1)
							for i, reg in ipairs(regs) do
								table.insert(exprregs, reg)
							end
						else
							if
								statement.ids[i]
								or expr.kind == AstKind.FunctionCallExpression
								or expr.kind == AstKind.PassSelfFunctionCallExpression
							then
								local reg = self:compileExpression(expr, funcDepth, 1)[1]
								table.insert(exprregs, reg)
							end
						end
					end
					if #exprregs == 0 then
						for i = 1, #statement.ids do
							table.insert(exprregs, self:compileExpression(Ast.NilExpression(), funcDepth, 1)[1])
						end
					end
					for i, id in ipairs(statement.ids) do
						if exprregs[i] then
							if self:isUpvalue(statement.scope, id) then
								local varreg = self:getVarRegister(statement.scope, id, funcDepth)
								local varReg = self:getVarRegister(statement.scope, id, funcDepth, nil)
								scope:addReferenceToHigherScope(self.scope, self.allocUpvalFunction)
								self:addStatement(
									self:setRegister(
										scope,
										varReg,
										Ast.FunctionCallExpression(
											Ast.VariableExpression(self.scope, self.allocUpvalFunction),
											{}
										)
									),
									{ varReg },
									{},
									false
								)
								self:addStatement(
									self:setUpvalueMember(
										scope,
										self:register(scope, varReg),
										self:register(scope, exprregs[i])
									),
									{},
									{ varReg, exprregs[i] },
									true
								)
								self:freeRegister(exprregs[i], false)
							else
								local varreg = self:getVarRegister(statement.scope, id, funcDepth, exprregs[i])
								self:addStatement(
									self:copyRegisters(scope, { varreg }, { exprregs[i] }),
									{ varreg },
									{ exprregs[i] },
									false
								)
								self:freeRegister(exprregs[i], false)
							end
						end
					end
					if not self.scopeFunctionDepths[statement.scope] then
						self.scopeFunctionDepths[statement.scope] = funcDepth
					end
					return
				end
				if statement.kind == AstKind.FunctionCallStatement then
					local baseReg = self:compileExpression(statement.base, funcDepth, 1)[1]
					local retReg = self:allocRegister(false)
					local regs = {}
					local args = {}
					for i, expr in ipairs(statement.args) do
						if
							i == #statement.args
							and (
								expr.kind == AstKind.FunctionCallExpression
								or expr.kind == AstKind.PassSelfFunctionCallExpression
								or expr.kind == AstKind.VarargExpression
							)
						then
							local reg = self:compileExpression(expr, funcDepth, self.RETURN_ALL)[1]
							table.insert(
								args,
								Ast.FunctionCallExpression(self:unpack(scope), { self:register(scope, reg) })
							)
							table.insert(regs, reg)
						else
							local reg = self:compileExpression(expr, funcDepth, 1)[1]
							table.insert(args, self:register(scope, reg))
							table.insert(regs, reg)
						end
					end
					self:addStatement(
						self:setRegister(scope, retReg, Ast.FunctionCallExpression(self:register(scope, baseReg), args)),
						{ retReg },
						{ baseReg, unpack(regs) },
						true
					)
					self:freeRegister(baseReg, false)
					self:freeRegister(retReg, false)
					for i, reg in ipairs(regs) do
						self:freeRegister(reg, false)
					end
					return
				end
				if statement.kind == AstKind.PassSelfFunctionCallStatement then
					local baseReg = self:compileExpression(statement.base, funcDepth, 1)[1]
					local tmpReg = self:allocRegister(false)
					local args = { self:register(scope, baseReg) }
					local regs = { baseReg }
					for i, expr in ipairs(statement.args) do
						if
							i == #statement.args
							and (
								expr.kind == AstKind.FunctionCallExpression
								or expr.kind == AstKind.PassSelfFunctionCallExpression
								or expr.kind == AstKind.VarargExpression
							)
						then
							local reg = self:compileExpression(expr, funcDepth, self.RETURN_ALL)[1]
							table.insert(
								args,
								Ast.FunctionCallExpression(self:unpack(scope), { self:register(scope, reg) })
							)
							table.insert(regs, reg)
						else
							local reg = self:compileExpression(expr, funcDepth, 1)[1]
							table.insert(args, self:register(scope, reg))
							table.insert(regs, reg)
						end
					end
					self:addStatement(
						self:setRegister(scope, tmpReg, Ast.StringExpression(statement.passSelfFunctionName)),
						{ tmpReg },
						{},
						false
					)
					self:addStatement(
						self:setRegister(
							scope,
							tmpReg,
							Ast.IndexExpression(self:register(scope, baseReg), self:register(scope, tmpReg))
						),
						{ tmpReg },
						{ tmpReg, baseReg },
						false
					)
					self:addStatement(
						self:setRegister(scope, tmpReg, Ast.FunctionCallExpression(self:register(scope, tmpReg), args)),
						{ tmpReg },
						{ tmpReg, unpack(regs) },
						true
					)
					self:freeRegister(tmpReg, false)
					for i, reg in ipairs(regs) do
						self:freeRegister(reg, false)
					end
					return
				end
				if statement.kind == AstKind.LocalFunctionDeclaration then
					if self:isUpvalue(statement.scope, statement.id) then
						local varReg = self:getVarRegister(statement.scope, statement.id, funcDepth, nil)
						scope:addReferenceToHigherScope(self.scope, self.allocUpvalFunction)
						self:addStatement(
							self:setRegister(
								scope,
								varReg,
								Ast.FunctionCallExpression(
									Ast.VariableExpression(self.scope, self.allocUpvalFunction),
									{}
								)
							),
							{ varReg },
							{},
							false
						)
						local retReg = self:compileFunction(statement, funcDepth)
						self:addStatement(
							self:setUpvalueMember(scope, self:register(scope, varReg), self:register(scope, retReg)),
							{},
							{ varReg, retReg },
							true
						)
						self:freeRegister(retReg, false)
					else
						local retReg = self:compileFunction(statement, funcDepth)
						local varReg = self:getVarRegister(statement.scope, statement.id, funcDepth, retReg)
						self:addStatement(
							self:copyRegisters(scope, { varReg }, { retReg }),
							{ varReg },
							{ retReg },
							false
						)
						self:freeRegister(retReg, false)
					end
					return
				end
				if statement.kind == AstKind.FunctionDeclaration then
					local retReg = self:compileFunction(statement, funcDepth)
					if #statement.indices > 0 then
						local tblReg
						if statement.scope.isGlobal then
							tblReg = self:allocRegister(false)
							self:addStatement(
								self:setRegister(
									scope,
									tblReg,
									Ast.StringExpression(statement.scope:getVariableName(statement.id))
								),
								{ tblReg },
								{},
								false
							)
							self:addStatement(
								self:setRegister(
									scope,
									tblReg,
									Ast.IndexExpression(self:env(scope), self:register(scope, tblReg))
								),
								{ tblReg },
								{ tblReg },
								true
							)
						else
							if self.scopeFunctionDepths[statement.scope] == funcDepth then
								if self:isUpvalue(statement.scope, statement.id) then
									tblReg = self:allocRegister(false)
									local reg = self:getVarRegister(statement.scope, statement.id, funcDepth)
									self:addStatement(
										self:setRegister(
											scope,
											tblReg,
											self:getUpvalueMember(scope, self:register(scope, reg))
										),
										{ tblReg },
										{ reg },
										true
									)
								else
									tblReg = self:getVarRegister(statement.scope, statement.id, funcDepth, retReg)
								end
							else
								tblReg = self:allocRegister(false)
								local upvalId = self:getUpvalueId(statement.scope, statement.id)
								scope:addReferenceToHigherScope(self.containerFuncScope, self.currentUpvaluesVar)
								self:addStatement(
									self:setRegister(
										scope,
										tblReg,
										self:getUpvalueMember(
											scope,
											Ast.IndexExpression(
												Ast.VariableExpression(self.containerFuncScope, self.currentUpvaluesVar),
												Ast.NumberExpression(upvalId)
											)
										)
									),
									{ tblReg },
									{},
									true
								)
							end
						end
						for i = 1, #statement.indices - 1 do
							local index = statement.indices[i]
							local indexReg = self:compileExpression(Ast.StringExpression(index), funcDepth, 1)[1]
							local tblRegOld = tblReg
							tblReg = self:allocRegister(false)
							self:addStatement(
								self:setRegister(
									scope,
									tblReg,
									Ast.IndexExpression(self:register(scope, tblRegOld), self:register(scope, indexReg))
								),
								{ tblReg },
								{ tblReg, indexReg },
								false
							)
							self:freeRegister(tblRegOld, false)
							self:freeRegister(indexReg, false)
						end
						local index = statement.indices[#statement.indices]
						local indexReg = self:compileExpression(Ast.StringExpression(index), funcDepth, 1)[1]
						self:addStatement(
							Ast.AssignmentStatement({
								Ast.AssignmentIndexing(self:register(scope, tblReg), self:register(scope, indexReg)),
							}, {
								self:register(scope, retReg),
							}),
							{},
							{ tblReg, indexReg, retReg },
							true
						)
						self:freeRegister(indexReg, false)
						self:freeRegister(tblReg, false)
						self:freeRegister(retReg, false)
						return
					end
					if statement.scope.isGlobal then
						local tmpReg = self:allocRegister(false)
						self:addStatement(
							self:setRegister(
								scope,
								tmpReg,
								Ast.StringExpression(statement.scope:getVariableName(statement.id))
							),
							{ tmpReg },
							{},
							false
						)
						self:addStatement(
							Ast.AssignmentStatement(
								{ Ast.AssignmentIndexing(self:env(scope), self:register(scope, tmpReg)) },
								{ self:register(scope, retReg) }
							),
							{},
							{ tmpReg, retReg },
							true
						)
						self:freeRegister(tmpReg, false)
					else
						if self.scopeFunctionDepths[statement.scope] == funcDepth then
							if self:isUpvalue(statement.scope, statement.id) then
								local reg = self:getVarRegister(statement.scope, statement.id, funcDepth)
								self:addStatement(
									self:setUpvalueMember(
										scope,
										self:register(scope, reg),
										self:register(scope, retReg)
									),
									{},
									{ reg, retReg },
									true
								)
							else
								local reg = self:getVarRegister(statement.scope, statement.id, funcDepth, retReg)
								if reg ~= retReg then
									self:addStatement(
										self:setRegister(scope, reg, self:register(scope, retReg)),
										{ reg },
										{ retReg },
										false
									)
								end
							end
						else
							local upvalId = self:getUpvalueId(statement.scope, statement.id)
							scope:addReferenceToHigherScope(self.containerFuncScope, self.currentUpvaluesVar)
							self:addStatement(
								self:setUpvalueMember(
									scope,
									Ast.IndexExpression(
										Ast.VariableExpression(self.containerFuncScope, self.currentUpvaluesVar),
										Ast.NumberExpression(upvalId)
									),
									self:register(scope, retReg)
								),
								{},
								{ retReg },
								true
							)
						end
					end
					self:freeRegister(retReg, false)
					return
				end
				if statement.kind == AstKind.AssignmentStatement then
					local exprregs = {}
					local assignmentIndexingRegs = {}
					for i, primaryExpr in ipairs(statement.lhs) do
						if primaryExpr.kind == AstKind.AssignmentIndexing then
							assignmentIndexingRegs[i] = {
								base = self:compileExpression(primaryExpr.base, funcDepth, 1)[1],
								index = self:compileExpression(primaryExpr.index, funcDepth, 1)[1],
							}
						end
					end
					for i, expr in ipairs(statement.rhs) do
						if i == #statement.rhs and #statement.lhs > #statement.rhs then
							local regs = self:compileExpression(expr, funcDepth, #statement.lhs - #statement.rhs + 1)
							for i, reg in ipairs(regs) do
								if self:isVarRegister(reg) then
									local ro = reg
									reg = self:allocRegister(false)
									self:addStatement(
										self:copyRegisters(scope, { reg }, { ro }),
										{ reg },
										{ ro },
										false
									)
								end
								table.insert(exprregs, reg)
							end
						else
							if
								statement.lhs[i]
								or expr.kind == AstKind.FunctionCallExpression
								or expr.kind == AstKind.PassSelfFunctionCallExpression
							then
								local reg = self:compileExpression(expr, funcDepth, 1)[1]
								if self:isVarRegister(reg) then
									local ro = reg
									reg = self:allocRegister(false)
									self:addStatement(
										self:copyRegisters(scope, { reg }, { ro }),
										{ reg },
										{ ro },
										false
									)
								end
								table.insert(exprregs, reg)
							end
						end
					end
					for i, primaryExpr in ipairs(statement.lhs) do
						if primaryExpr.kind == AstKind.AssignmentVariable then
							if primaryExpr.scope.isGlobal then
								local tmpReg = self:allocRegister(false)
								self:addStatement(
									self:setRegister(
										scope,
										tmpReg,
										Ast.StringExpression(primaryExpr.scope:getVariableName(primaryExpr.id))
									),
									{ tmpReg },
									{},
									false
								)
								self:addStatement(
									Ast.AssignmentStatement(
										{ Ast.AssignmentIndexing(self:env(scope), self:register(scope, tmpReg)) },
										{ self:register(scope, exprregs[i]) }
									),
									{},
									{ tmpReg, exprregs[i] },
									true
								)
								self:freeRegister(tmpReg, false)
							else
								if self.scopeFunctionDepths[primaryExpr.scope] == funcDepth then
									if self:isUpvalue(primaryExpr.scope, primaryExpr.id) then
										local reg = self:getVarRegister(primaryExpr.scope, primaryExpr.id, funcDepth)
										self:addStatement(
											self:setUpvalueMember(
												scope,
												self:register(scope, reg),
												self:register(scope, exprregs[i])
											),
											{},
											{ reg, exprregs[i] },
											true
										)
									else
										local reg = self:getVarRegister(
											primaryExpr.scope,
											primaryExpr.id,
											funcDepth,
											exprregs[i]
										)
										if reg ~= exprregs[i] then
											self:addStatement(
												self:setRegister(scope, reg, self:register(scope, exprregs[i])),
												{ reg },
												{ exprregs[i] },
												false
											)
										end
									end
								else
									local upvalId = self:getUpvalueId(primaryExpr.scope, primaryExpr.id)
									scope:addReferenceToHigherScope(self.containerFuncScope, self.currentUpvaluesVar)
									self:addStatement(
										self:setUpvalueMember(
											scope,
											Ast.IndexExpression(
												Ast.VariableExpression(self.containerFuncScope, self.currentUpvaluesVar),
												Ast.NumberExpression(upvalId)
											),
											self:register(scope, exprregs[i])
										),
										{},
										{ exprregs[i] },
										true
									)
								end
							end
						elseif primaryExpr.kind == AstKind.AssignmentIndexing then
							local baseReg = assignmentIndexingRegs[i].base
							local indexReg = assignmentIndexingRegs[i].index
							self:addStatement(
								Ast.AssignmentStatement({
									Ast.AssignmentIndexing(
										self:register(scope, baseReg),
										self:register(scope, indexReg)
									),
								}, {
									self:register(scope, exprregs[i]),
								}),
								{},
								{ exprregs[i], baseReg, indexReg },
								true
							)
							self:freeRegister(exprregs[i], false)
							self:freeRegister(baseReg, false)
							self:freeRegister(indexReg, false)
						else
							error(string.format("Invalid Assignment lhs: %s", statement.lhs))
						end
					end
					return
				end
				if statement.kind == AstKind.IfStatement then
					local conditionReg = self:compileExpression(statement.condition, funcDepth, 1)[1]
					local finalBlock = self:createBlock()
					local nextBlock
					if statement.elsebody or #statement.elseifs > 0 then
						nextBlock = self:createBlock()
					else
						nextBlock = finalBlock
					end
					local innerBlock = self:createBlock()
					self:addStatement(
						self:setRegister(
							scope,
							self.POS_REGISTER,
							Ast.OrExpression(
								Ast.AndExpression(
									self:register(scope, conditionReg),
									Ast.NumberExpression(innerBlock.id)
								),
								Ast.NumberExpression(nextBlock.id)
							)
						),
						{ self.POS_REGISTER },
						{ conditionReg },
						false
					)
					self:freeRegister(conditionReg, false)
					self:setActiveBlock(innerBlock)
					scope = innerBlock.scope
					self:compileBlock(statement.body, funcDepth)
					self:addStatement(
						self:setRegister(scope, self.POS_REGISTER, Ast.NumberExpression(finalBlock.id)),
						{ self.POS_REGISTER },
						{},
						false
					)
					for i, eif in ipairs(statement.elseifs) do
						self:setActiveBlock(nextBlock)
						conditionReg = self:compileExpression(eif.condition, funcDepth, 1)[1]
						local innerBlock = self:createBlock()
						if statement.elsebody or i < #statement.elseifs then
							nextBlock = self:createBlock()
						else
							nextBlock = finalBlock
						end
						local scope = self.activeBlock.scope
						self:addStatement(
							self:setRegister(
								scope,
								self.POS_REGISTER,
								Ast.OrExpression(
									Ast.AndExpression(
										self:register(scope, conditionReg),
										Ast.NumberExpression(innerBlock.id)
									),
									Ast.NumberExpression(nextBlock.id)
								)
							),
							{ self.POS_REGISTER },
							{ conditionReg },
							false
						)
						self:freeRegister(conditionReg, false)
						self:setActiveBlock(innerBlock)
						scope = innerBlock.scope
						self:compileBlock(eif.body, funcDepth)
						self:addStatement(
							self:setRegister(scope, self.POS_REGISTER, Ast.NumberExpression(finalBlock.id)),
							{ self.POS_REGISTER },
							{},
							false
						)
					end
					if statement.elsebody then
						self:setActiveBlock(nextBlock)
						self:compileBlock(statement.elsebody, funcDepth)
						self:addStatement(
							self:setRegister(scope, self.POS_REGISTER, Ast.NumberExpression(finalBlock.id)),
							{ self.POS_REGISTER },
							{},
							false
						)
					end
					self:setActiveBlock(finalBlock)
					return
				end
				if statement.kind == AstKind.DoStatement then
					self:compileBlock(statement.body, funcDepth)
					return
				end
				if statement.kind == AstKind.WhileStatement then
					local innerBlock = self:createBlock()
					local finalBlock = self:createBlock()
					local checkBlock = self:createBlock()
					statement.__start_block = checkBlock
					statement.__final_block = finalBlock
					self:addStatement(self:setPos(scope, checkBlock.id), { self.POS_REGISTER }, {}, false)
					self:setActiveBlock(checkBlock)
					local scope = self.activeBlock.scope
					local conditionReg = self:compileExpression(statement.condition, funcDepth, 1)[1]
					self:addStatement(
						self:setRegister(
							scope,
							self.POS_REGISTER,
							Ast.OrExpression(
								Ast.AndExpression(
									self:register(scope, conditionReg),
									Ast.NumberExpression(innerBlock.id)
								),
								Ast.NumberExpression(finalBlock.id)
							)
						),
						{ self.POS_REGISTER },
						{ conditionReg },
						false
					)
					self:freeRegister(conditionReg, false)
					self:setActiveBlock(innerBlock)
					local scope = self.activeBlock.scope
					self:compileBlock(statement.body, funcDepth)
					self:addStatement(self:setPos(scope, checkBlock.id), { self.POS_REGISTER }, {}, false)
					self:setActiveBlock(finalBlock)
					return
				end
				if statement.kind == AstKind.RepeatStatement then
					local innerBlock = self:createBlock()
					local finalBlock = self:createBlock()
					statement.__start_block = innerBlock
					statement.__final_block = finalBlock
					self:addStatement(
						self:setRegister(scope, self.POS_REGISTER, Ast.NumberExpression(innerBlock.id)),
						{ self.POS_REGISTER },
						{},
						false
					)
					self:setActiveBlock(innerBlock)
					for i, stat in ipairs(statement.body.statements) do
						self:compileStatement(stat, funcDepth)
					end
					local scope = self.activeBlock.scope
					local conditionReg = (self:compileExpression(statement.condition, funcDepth, 1))[1]
					self:addStatement(
						self:setRegister(
							scope,
							self.POS_REGISTER,
							Ast.OrExpression(
								Ast.AndExpression(
									self:register(scope, conditionReg),
									Ast.NumberExpression(finalBlock.id)
								),
								Ast.NumberExpression(innerBlock.id)
							)
						),
						{ self.POS_REGISTER },
						{ conditionReg },
						false
					)
					self:freeRegister(conditionReg, false)
					for id, name in ipairs(statement.body.scope.variables) do
						local varReg = self:getVarRegister(statement.body.scope, id, funcDepth, nil)
						if self:isUpvalue(statement.body.scope, id) then
							scope:addReferenceToHigherScope(self.scope, self.freeUpvalueFunc)
							self:addStatement(
								self:setRegister(
									scope,
									varReg,
									Ast.FunctionCallExpression(
										Ast.VariableExpression(self.scope, self.freeUpvalueFunc),
										{ self:register(scope, varReg) }
									)
								),
								{ varReg },
								{ varReg },
								false
							)
						else
							self:addStatement(
								self:setRegister(scope, varReg, Ast.NilExpression()),
								{ varReg },
								{},
								false
							)
						end
						self:freeRegister(varReg, true)
					end
					self:setActiveBlock(finalBlock)
					return
				end
				if statement.kind == AstKind.ForStatement then
					local checkBlock = self:createBlock()
					local innerBlock = self:createBlock()
					local finalBlock = self:createBlock()
					statement.__start_block = checkBlock
					statement.__final_block = finalBlock
					local posState = self.registers[self.POS_REGISTER]
					self.registers[self.POS_REGISTER] = self.VAR_REGISTER
					local initialReg = self:compileExpression(statement.initialValue, funcDepth, 1)[1]
					local finalExprReg = self:compileExpression(statement.finalValue, funcDepth, 1)[1]
					local finalReg = self:allocRegister(false)
					self:addStatement(
						self:copyRegisters(scope, { finalReg }, { finalExprReg }),
						{ finalReg },
						{ finalExprReg },
						false
					)
					self:freeRegister(finalExprReg)
					local incrementExprReg = self:compileExpression(statement.incrementBy, funcDepth, 1)[1]
					local incrementReg = self:allocRegister(false)
					self:addStatement(
						self:copyRegisters(scope, { incrementReg }, { incrementExprReg }),
						{ incrementReg },
						{ incrementExprReg },
						false
					)
					self:freeRegister(incrementExprReg)
					local tmpReg = self:allocRegister(false)
					self:addStatement(self:setRegister(scope, tmpReg, Ast.NumberExpression(0)), { tmpReg }, {}, false)
					local incrementIsNegReg = self:allocRegister(false)
					self:addStatement(
						self:setRegister(
							scope,
							incrementIsNegReg,
							Ast.LessThanExpression(self:register(scope, incrementReg), self:register(scope, tmpReg))
						),
						{ incrementIsNegReg },
						{ incrementReg, tmpReg },
						false
					)
					self:freeRegister(tmpReg)
					local currentReg = self:allocRegister(true)
					self:addStatement(
						self:setRegister(
							scope,
							currentReg,
							Ast.SubExpression(self:register(scope, initialReg), self:register(scope, incrementReg))
						),
						{ currentReg },
						{ initialReg, incrementReg },
						false
					)
					self:freeRegister(initialReg)
					self:addStatement(
						self:jmp(scope, Ast.NumberExpression(checkBlock.id)),
						{ self.POS_REGISTER },
						{},
						false
					)
					self:setActiveBlock(checkBlock)
					scope = checkBlock.scope
					self:addStatement(
						self:setRegister(
							scope,
							currentReg,
							Ast.AddExpression(self:register(scope, currentReg), self:register(scope, incrementReg))
						),
						{ currentReg },
						{ currentReg, incrementReg },
						false
					)
					local tmpReg1 = self:allocRegister(false)
					local tmpReg2 = self:allocRegister(false)
					self:addStatement(
						self:setRegister(scope, tmpReg2, Ast.NotExpression(self:register(scope, incrementIsNegReg))),
						{ tmpReg2 },
						{ incrementIsNegReg },
						false
					)
					self:addStatement(
						self:setRegister(
							scope,
							tmpReg1,
							Ast.LessThanOrEqualsExpression(
								self:register(scope, currentReg),
								self:register(scope, finalReg)
							)
						),
						{ tmpReg1 },
						{ currentReg, finalReg },
						false
					)
					self:addStatement(
						self:setRegister(
							scope,
							tmpReg1,
							Ast.AndExpression(self:register(scope, tmpReg2), self:register(scope, tmpReg1))
						),
						{ tmpReg1 },
						{ tmpReg1, tmpReg2 },
						false
					)
					self:addStatement(
						self:setRegister(
							scope,
							tmpReg2,
							Ast.GreaterThanOrEqualsExpression(
								self:register(scope, currentReg),
								self:register(scope, finalReg)
							)
						),
						{ tmpReg2 },
						{ currentReg, finalReg },
						false
					)
					self:addStatement(
						self:setRegister(
							scope,
							tmpReg2,
							Ast.AndExpression(self:register(scope, incrementIsNegReg), self:register(scope, tmpReg2))
						),
						{ tmpReg2 },
						{ tmpReg2, incrementIsNegReg },
						false
					)
					self:addStatement(
						self:setRegister(
							scope,
							tmpReg1,
							Ast.OrExpression(self:register(scope, tmpReg2), self:register(scope, tmpReg1))
						),
						{ tmpReg1 },
						{ tmpReg1, tmpReg2 },
						false
					)
					self:freeRegister(tmpReg2)
					tmpReg2 = self:compileExpression(Ast.NumberExpression(innerBlock.id), funcDepth, 1)[1]
					self:addStatement(
						self:setRegister(
							scope,
							self.POS_REGISTER,
							Ast.AndExpression(self:register(scope, tmpReg1), self:register(scope, tmpReg2))
						),
						{ self.POS_REGISTER },
						{ tmpReg1, tmpReg2 },
						false
					)
					self:freeRegister(tmpReg2)
					self:freeRegister(tmpReg1)
					tmpReg2 = self:compileExpression(Ast.NumberExpression(finalBlock.id), funcDepth, 1)[1]
					self:addStatement(
						self:setRegister(
							scope,
							self.POS_REGISTER,
							Ast.OrExpression(self:register(scope, self.POS_REGISTER), self:register(scope, tmpReg2))
						),
						{ self.POS_REGISTER },
						{ self.POS_REGISTER, tmpReg2 },
						false
					)
					self:freeRegister(tmpReg2)
					self:setActiveBlock(innerBlock)
					scope = innerBlock.scope
					self.registers[self.POS_REGISTER] = posState
					local varReg = self:getVarRegister(statement.scope, statement.id, funcDepth, nil)
					if self:isUpvalue(statement.scope, statement.id) then
						scope:addReferenceToHigherScope(self.scope, self.allocUpvalFunction)
						self:addStatement(
							self:setRegister(
								scope,
								varReg,
								Ast.FunctionCallExpression(
									Ast.VariableExpression(self.scope, self.allocUpvalFunction),
									{}
								)
							),
							{ varReg },
							{},
							false
						)
						self:addStatement(
							self:setUpvalueMember(scope, self:register(scope, varReg), self:register(scope, currentReg)),
							{},
							{ varReg, currentReg },
							true
						)
					else
						self:addStatement(
							self:setRegister(scope, varReg, self:register(scope, currentReg)),
							{ varReg },
							{ currentReg },
							false
						)
					end
					self:compileBlock(statement.body, funcDepth)
					self:addStatement(
						self:setRegister(scope, self.POS_REGISTER, Ast.NumberExpression(checkBlock.id)),
						{ self.POS_REGISTER },
						{},
						false
					)
					self.registers[self.POS_REGISTER] = self.VAR_REGISTER
					self:freeRegister(finalReg)
					self:freeRegister(incrementIsNegReg)
					self:freeRegister(incrementReg)
					self:freeRegister(currentReg, true)
					self.registers[self.POS_REGISTER] = posState
					self:setActiveBlock(finalBlock)
					return
				end
				if statement.kind == AstKind.ForInStatement then
					local CALL_KINDS = {
						[AstKind.FunctionCallExpression] = true,
						[AstKind.PassSelfFunctionCallExpression] = true,
					}
					local function isGeneralizedIter(exprs)
						if #exprs ~= 1 then
							return false
						end
						local k = exprs[1].kind
						if k == AstKind.VarargExpression then
							return false
						end
						if CALL_KINDS[k] then
							return false
						end
						return true
					end
					if isGeneralizedIter(statement.expressions) then
						local gScope = self.scope
						while gScope.parentScope do
							gScope = gScope.parentScope
						end
						local _, nextVar = gScope:resolve("next")
						local tblExpr = statement.expressions[1]
						statement.expressions = {
							Ast.VariableExpression(gScope, nextVar),
							tblExpr,
							Ast.NilExpression(),
						}
					end
					local expressionsLength = #statement.expressions
					local exprregs = {}
					for i, expr in ipairs(statement.expressions) do
						if i == expressionsLength and expressionsLength < 3 then
							local regs = self:compileExpression(expr, funcDepth, 4 - expressionsLength)
							for i = 1, 4 - expressionsLength do
								table.insert(exprregs, regs[i])
							end
						else
							if i <= 3 then
								table.insert(exprregs, self:compileExpression(expr, funcDepth, 1)[1])
							else
								self:freeRegister(self:compileExpression(expr, funcDepth, 1)[1], false)
							end
						end
					end
					for i, reg in ipairs(exprregs) do
						if
							reg
							and self.registers[reg] ~= self.VAR_REGISTER
							and reg ~= self.POS_REGISTER
							and reg ~= self.RETURN_REGISTER
						then
							self.registers[reg] = self.VAR_REGISTER
						else
							exprregs[i] = self:allocRegister(true)
							self:addStatement(
								self:copyRegisters(scope, { exprregs[i] }, { reg }),
								{ exprregs[i] },
								{ reg },
								false
							)
						end
					end
					local checkBlock = self:createBlock()
					local bodyBlock = self:createBlock()
					local finalBlock = self:createBlock()
					statement.__start_block = checkBlock
					statement.__final_block = finalBlock
					self:addStatement(self:setPos(scope, checkBlock.id), { self.POS_REGISTER }, {}, false)
					self:setActiveBlock(checkBlock)
					local scope = self.activeBlock.scope
					local varRegs = {}
					for i, id in ipairs(statement.ids) do
						varRegs[i] = self:getVarRegister(statement.scope, id, funcDepth)
					end
					self:addStatement(
						Ast.AssignmentStatement({
							self:registerAssignment(scope, exprregs[3]),
							varRegs[2] and self:registerAssignment(scope, varRegs[2]),
						}, {
							Ast.FunctionCallExpression(self:register(scope, exprregs[1]), {
								self:register(scope, exprregs[2]),
								self:register(scope, exprregs[3]),
							}),
						}),
						{ exprregs[3], varRegs[2] },
						{ exprregs[1], exprregs[2], exprregs[3] },
						true
					)
					self:addStatement(
						Ast.AssignmentStatement({
							self:posAssignment(scope),
						}, {
							Ast.OrExpression(
								Ast.AndExpression(self:register(scope, exprregs[3]), Ast.NumberExpression(bodyBlock.id)),
								Ast.NumberExpression(finalBlock.id)
							),
						}),
						{ self.POS_REGISTER },
						{ exprregs[3] },
						false
					)
					self:setActiveBlock(bodyBlock)
					local scope = self.activeBlock.scope
					self:addStatement(
						self:copyRegisters(scope, { varRegs[1] }, { exprregs[3] }),
						{ varRegs[1] },
						{ exprregs[3] },
						false
					)
					for i = 3, #varRegs do
						self:addStatement(
							self:setRegister(scope, varRegs[i], Ast.NilExpression()),
							{ varRegs[i] },
							{},
							false
						)
					end
					for i, id in ipairs(statement.ids) do
						if self:isUpvalue(statement.scope, id) then
							local varreg = varRegs[i]
							local tmpReg = self:allocRegister(false)
							scope:addReferenceToHigherScope(self.scope, self.allocUpvalFunction)
							self:addStatement(
								self:setRegister(
									scope,
									tmpReg,
									Ast.FunctionCallExpression(
										Ast.VariableExpression(self.scope, self.allocUpvalFunction),
										{}
									)
								),
								{ tmpReg },
								{},
								false
							)
							self:addStatement(
								self:setUpvalueMember(scope, self:register(scope, tmpReg), self:register(scope, varreg)),
								{},
								{ tmpReg, varreg },
								true
							)
							self:addStatement(
								self:copyRegisters(scope, { varreg }, { tmpReg }),
								{ varreg },
								{ tmpReg },
								false
							)
							self:freeRegister(tmpReg, false)
						end
					end
					self:compileBlock(statement.body, funcDepth)
					self:addStatement(self:setPos(scope, checkBlock.id), { self.POS_REGISTER }, {}, false)
					self:setActiveBlock(finalBlock)
					for i, reg in ipairs(exprregs) do
						self:freeRegister(exprregs[i], true)
					end
					return
				end
				if statement.kind == AstKind.DoStatement then
					self:compileBlock(statement.body, funcDepth)
					return
				end
				if statement.kind == AstKind.BreakStatement then
					local toFreeVars = {}
					local statScope
					repeat
						statScope = statScope and statScope.parentScope or statement.scope
						for id, name in ipairs(statScope.variables) do
							table.insert(toFreeVars, {
								scope = statScope,
								id = id,
							})
						end
					until statScope == statement.loop.body.scope
					for i, var in pairs(toFreeVars) do
						local varScope, id = var.scope, var.id
						local varReg = self:getVarRegister(varScope, id, nil, nil)
						if self:isUpvalue(varScope, id) then
							scope:addReferenceToHigherScope(self.scope, self.freeUpvalueFunc)
							self:addStatement(
								self:setRegister(
									scope,
									varReg,
									Ast.FunctionCallExpression(
										Ast.VariableExpression(self.scope, self.freeUpvalueFunc),
										{
											self:register(scope, varReg),
										}
									)
								),
								{ varReg },
								{ varReg },
								false
							)
						else
							self:addStatement(
								self:setRegister(scope, varReg, Ast.NilExpression()),
								{ varReg },
								{},
								false
							)
						end
					end
					self:addStatement(
						self:setPos(scope, statement.loop.__final_block.id),
						{ self.POS_REGISTER },
						{},
						false
					)
					self.activeBlock.advanceToNextBlock = false
					return
				end
				if statement.kind == AstKind.ContinueStatement then
					local toFreeVars = {}
					local statScope
					repeat
						statScope = statScope and statScope.parentScope or statement.scope
						for id, name in pairs(statScope.variables) do
							table.insert(toFreeVars, {
								scope = statScope,
								id = id,
							})
						end
					until statScope == statement.loop.body.scope
					for i, var in ipairs(toFreeVars) do
						local varScope, id = var.scope, var.id
						local varReg = self:getVarRegister(varScope, id, nil, nil)
						if self:isUpvalue(varScope, id) then
							scope:addReferenceToHigherScope(self.scope, self.freeUpvalueFunc)
							self:addStatement(
								self:setRegister(
									scope,
									varReg,
									Ast.FunctionCallExpression(
										Ast.VariableExpression(self.scope, self.freeUpvalueFunc),
										{
											self:register(scope, varReg),
										}
									)
								),
								{ varReg },
								{ varReg },
								false
							)
						else
							self:addStatement(
								self:setRegister(scope, varReg, Ast.NilExpression()),
								{ varReg },
								{},
								false
							)
						end
					end
					self:addStatement(
						self:setPos(scope, statement.loop.__start_block.id),
						{ self.POS_REGISTER },
						{},
						false
					)
					self.activeBlock.advanceToNextBlock = false
					return
				end
				local compoundConstructors = {
					[AstKind.CompoundAddStatement] = Ast.CompoundAddStatement,
					[AstKind.CompoundSubStatement] = Ast.CompoundSubStatement,
					[AstKind.CompoundMulStatement] = Ast.CompoundMulStatement,
					[AstKind.CompoundDivStatement] = Ast.CompoundDivStatement,
					[AstKind.CompoundModStatement] = Ast.CompoundModStatement,
					[AstKind.CompoundPowStatement] = Ast.CompoundPowStatement,
					[AstKind.CompoundConcatStatement] = Ast.CompoundConcatStatement,
				}
				if compoundConstructors[statement.kind] then
					local compoundConstructor = compoundConstructors[statement.kind]
					if statement.lhs.kind == AstKind.AssignmentIndexing then
						local arithmeticOp = {
							[AstKind.CompoundAddStatement] = Ast.AddExpression,
							[AstKind.CompoundSubStatement] = Ast.SubExpression,
							[AstKind.CompoundMulStatement] = Ast.MulExpression,
							[AstKind.CompoundDivStatement] = Ast.DivExpression,
							[AstKind.CompoundModStatement] = Ast.ModExpression,
							[AstKind.CompoundPowStatement] = Ast.PowExpression,
							[AstKind.CompoundConcatStatement] = Ast.StrCatExpression,
						}
						local makeExpr = arithmeticOp[statement.kind]
						local indexing = statement.lhs
						local baseReg = self:compileExpression(indexing.base, funcDepth, 1)[1]
						local indexReg = self:compileExpression(indexing.index, funcDepth, 1)[1]
						local valueReg = self:compileExpression(statement.rhs, funcDepth, 1)[1]
						local readExpr =
							Ast.IndexExpression(self:register(scope, baseReg), self:register(scope, indexReg))
						local writeVal = makeExpr(readExpr, self:register(scope, valueReg))
						local writeLhs =
							Ast.AssignmentIndexing(self:register(scope, baseReg), self:register(scope, indexReg))
						self:addStatement(
							Ast.AssignmentStatement({ writeLhs }, { writeVal }),
							{},
							{ baseReg, indexReg, valueReg },
							true
						)
					else
						local valueReg = self:compileExpression(statement.rhs, funcDepth, 1)[1]
						local primaryExpr = statement.lhs
						if primaryExpr.scope.isGlobal then
							local tmpReg = self:allocRegister(false)
							self:addStatement(
								self:setRegister(
									scope,
									tmpReg,
									Ast.StringExpression(primaryExpr.scope:getVariableName(primaryExpr.id))
								),
								{ tmpReg },
								{},
								false
							)
							self:addStatement(
								Ast.AssignmentStatement(
									{ Ast.AssignmentIndexing(self:env(scope), self:register(scope, tmpReg)) },
									{ self:register(scope, valueReg) }
								),
								{},
								{ tmpReg, valueReg },
								true
							)
							self:freeRegister(tmpReg, false)
						else
							if self.scopeFunctionDepths[primaryExpr.scope] == funcDepth then
								if self:isUpvalue(primaryExpr.scope, primaryExpr.id) then
									local reg = self:getVarRegister(primaryExpr.scope, primaryExpr.id, funcDepth)
									self:addStatement(
										self:setUpvalueMember(
											scope,
											self:register(scope, reg),
											self:register(scope, valueReg),
											compoundConstructor
										),
										{},
										{ reg, valueReg },
										true
									)
								else
									local reg =
										self:getVarRegister(primaryExpr.scope, primaryExpr.id, funcDepth, valueReg)
									if reg ~= valueReg then
										self:addStatement(
											self:setRegister(
												scope,
												reg,
												self:register(scope, valueReg),
												compoundConstructor
											),
											{ reg },
											{ valueReg },
											false
										)
									end
								end
							else
								local upvalId = self:getUpvalueId(primaryExpr.scope, primaryExpr.id)
								scope:addReferenceToHigherScope(self.containerFuncScope, self.currentUpvaluesVar)
								self:addStatement(
									self:setUpvalueMember(
										scope,
										Ast.IndexExpression(
											Ast.VariableExpression(self.containerFuncScope, self.currentUpvaluesVar),
											Ast.NumberExpression(upvalId)
										),
										self:register(scope, valueReg),
										compoundConstructor
									),
									{},
									{ valueReg },
									true
								)
							end
						end
					end
					return
				end
				logger:error(string.format("%s is not a compileable statement!", statement.kind))
			end
			function Compiler:compileExpression(expression, funcDepth, numReturns)
				local scope = self.activeBlock.scope
				if expression.kind == AstKind.StringExpression then
					local regs = {}
					for i = 1, numReturns, 1 do
						regs[i] = self:allocRegister()
						if i == 1 then
							self:addStatement(
								self:setRegister(scope, regs[i], Ast.StringExpression(expression.value)),
								{ regs[i] },
								{},
								false
							)
						else
							self:addStatement(
								self:setRegister(scope, regs[i], Ast.NilExpression()),
								{ regs[i] },
								{},
								false
							)
						end
					end
					return regs
				end
				if expression.kind == AstKind.NumberExpression then
					local regs = {}
					for i = 1, numReturns do
						regs[i] = self:allocRegister()
						if i == 1 then
							self:addStatement(
								self:setRegister(scope, regs[i], Ast.NumberExpression(expression.value)),
								{ regs[i] },
								{},
								false
							)
						else
							self:addStatement(
								self:setRegister(scope, regs[i], Ast.NilExpression()),
								{ regs[i] },
								{},
								false
							)
						end
					end
					return regs
				end
				if expression.kind == AstKind.BooleanExpression then
					local regs = {}
					for i = 1, numReturns do
						regs[i] = self:allocRegister()
						if i == 1 then
							self:addStatement(
								self:setRegister(scope, regs[i], Ast.BooleanExpression(expression.value)),
								{ regs[i] },
								{},
								false
							)
						else
							self:addStatement(
								self:setRegister(scope, regs[i], Ast.NilExpression()),
								{ regs[i] },
								{},
								false
							)
						end
					end
					return regs
				end
				if expression.kind == AstKind.NilExpression then
					local regs = {}
					for i = 1, numReturns do
						regs[i] = self:allocRegister()
						self:addStatement(self:setRegister(scope, regs[i], Ast.NilExpression()), { regs[i] }, {}, false)
					end
					return regs
				end
				if expression.kind == AstKind.VariableExpression then
					local regs = {}
					for i = 1, numReturns do
						if i == 1 then
							if expression.scope.isGlobal then
								regs[i] = self:allocRegister(false)
								local tmpReg = self:allocRegister(false)
								self:addStatement(
									self:setRegister(
										scope,
										tmpReg,
										Ast.StringExpression(expression.scope:getVariableName(expression.id))
									),
									{ tmpReg },
									{},
									false
								)
								self:addStatement(
									self:setRegister(
										scope,
										regs[i],
										Ast.IndexExpression(self:env(scope), self:register(scope, tmpReg))
									),
									{ regs[i] },
									{ tmpReg },
									true
								)
								self:freeRegister(tmpReg, false)
							else
								if self.scopeFunctionDepths[expression.scope] == funcDepth then
									if self:isUpvalue(expression.scope, expression.id) then
										local reg = self:allocRegister(false)
										local varReg =
											self:getVarRegister(expression.scope, expression.id, funcDepth, nil)
										self:addStatement(
											self:setRegister(
												scope,
												reg,
												self:getUpvalueMember(scope, self:register(scope, varReg))
											),
											{ reg },
											{ varReg },
											true
										)
										regs[i] = reg
									else
										regs[i] = self:getVarRegister(expression.scope, expression.id, funcDepth, nil)
									end
								else
									local reg = self:allocRegister(false)
									local upvalId = self:getUpvalueId(expression.scope, expression.id)
									scope:addReferenceToHigherScope(self.containerFuncScope, self.currentUpvaluesVar)
									self:addStatement(
										self:setRegister(
											scope,
											reg,
											self:getUpvalueMember(
												scope,
												Ast.IndexExpression(
													Ast.VariableExpression(
														self.containerFuncScope,
														self.currentUpvaluesVar
													),
													Ast.NumberExpression(upvalId)
												)
											)
										),
										{ reg },
										{},
										true
									)
									regs[i] = reg
								end
							end
						else
							regs[i] = self:allocRegister()
							self:addStatement(
								self:setRegister(scope, regs[i], Ast.NilExpression()),
								{ regs[i] },
								{},
								false
							)
						end
					end
					return regs
				end
				if expression.kind == AstKind.FunctionCallExpression then
					local baseReg = self:compileExpression(expression.base, funcDepth, 1)[1]
					local retRegs = {}
					local returnAll = numReturns == self.RETURN_ALL
					if returnAll then
						retRegs[1] = self:allocRegister(false)
					else
						for i = 1, numReturns do
							retRegs[i] = self:allocRegister(false)
						end
					end
					local regs = {}
					local args = {}
					for i, expr in ipairs(expression.args) do
						if
							i == #expression.args
							and (
								expr.kind == AstKind.FunctionCallExpression
								or expr.kind == AstKind.PassSelfFunctionCallExpression
								or expr.kind == AstKind.VarargExpression
							)
						then
							local reg = self:compileExpression(expr, funcDepth, self.RETURN_ALL)[1]
							table.insert(
								args,
								Ast.FunctionCallExpression(self:unpack(scope), { self:register(scope, reg) })
							)
							table.insert(regs, reg)
						else
							local reg = self:compileExpression(expr, funcDepth, 1)[1]
							table.insert(args, self:register(scope, reg))
							table.insert(regs, reg)
						end
					end
					if returnAll then
						self:addStatement(
							self:setRegister(
								scope,
								retRegs[1],
								Ast.TableConstructorExpression({
									Ast.TableEntry(Ast.FunctionCallExpression(self:register(scope, baseReg), args)),
								})
							),
							{ retRegs[1] },
							{ baseReg, unpack(regs) },
							true
						)
					else
						if numReturns > 1 then
							local tmpReg = self:allocRegister(false)
							self:addStatement(
								self:setRegister(
									scope,
									tmpReg,
									Ast.TableConstructorExpression({
										Ast.TableEntry(Ast.FunctionCallExpression(self:register(scope, baseReg), args)),
									})
								),
								{ tmpReg },
								{ baseReg, unpack(regs) },
								true
							)
							for i, reg in ipairs(retRegs) do
								self:addStatement(
									self:setRegister(
										scope,
										reg,
										Ast.IndexExpression(self:register(scope, tmpReg), Ast.NumberExpression(i))
									),
									{ reg },
									{ tmpReg },
									false
								)
							end
							self:freeRegister(tmpReg, false)
						else
							self:addStatement(
								self:setRegister(
									scope,
									retRegs[1],
									Ast.FunctionCallExpression(self:register(scope, baseReg), args)
								),
								{ retRegs[1] },
								{ baseReg, unpack(regs) },
								true
							)
						end
					end
					self:freeRegister(baseReg, false)
					for i, reg in ipairs(regs) do
						self:freeRegister(reg, false)
					end
					return retRegs
				end
				if expression.kind == AstKind.PassSelfFunctionCallExpression then
					local baseReg = self:compileExpression(expression.base, funcDepth, 1)[1]
					local retRegs = {}
					local returnAll = numReturns == self.RETURN_ALL
					if returnAll then
						retRegs[1] = self:allocRegister(false)
					else
						for i = 1, numReturns do
							retRegs[i] = self:allocRegister(false)
						end
					end
					local args = { self:register(scope, baseReg) }
					local regs = { baseReg }
					for i, expr in ipairs(expression.args) do
						if
							i == #expression.args
							and (
								expr.kind == AstKind.FunctionCallExpression
								or expr.kind == AstKind.PassSelfFunctionCallExpression
								or expr.kind == AstKind.VarargExpression
							)
						then
							local reg = self:compileExpression(expr, funcDepth, self.RETURN_ALL)[1]
							table.insert(
								args,
								Ast.FunctionCallExpression(self:unpack(scope), { self:register(scope, reg) })
							)
							table.insert(regs, reg)
						else
							local reg = self:compileExpression(expr, funcDepth, 1)[1]
							table.insert(args, self:register(scope, reg))
							table.insert(regs, reg)
						end
					end
					if returnAll or numReturns > 1 then
						local tmpReg = self:allocRegister(false)
						self:addStatement(
							self:setRegister(scope, tmpReg, Ast.StringExpression(expression.passSelfFunctionName)),
							{ tmpReg },
							{},
							false
						)
						self:addStatement(
							self:setRegister(
								scope,
								tmpReg,
								Ast.IndexExpression(self:register(scope, baseReg), self:register(scope, tmpReg))
							),
							{ tmpReg },
							{ baseReg, tmpReg },
							false
						)
						if returnAll then
							self:addStatement(
								self:setRegister(
									scope,
									retRegs[1],
									Ast.TableConstructorExpression({
										Ast.TableEntry(Ast.FunctionCallExpression(self:register(scope, tmpReg), args)),
									})
								),
								{ retRegs[1] },
								{ tmpReg, unpack(regs) },
								true
							)
						else
							self:addStatement(
								self:setRegister(
									scope,
									tmpReg,
									Ast.TableConstructorExpression({
										Ast.TableEntry(Ast.FunctionCallExpression(self:register(scope, tmpReg), args)),
									})
								),
								{ tmpReg },
								{ tmpReg, unpack(regs) },
								true
							)
							for i, reg in ipairs(retRegs) do
								self:addStatement(
									self:setRegister(
										scope,
										reg,
										Ast.IndexExpression(self:register(scope, tmpReg), Ast.NumberExpression(i))
									),
									{ reg },
									{ tmpReg },
									false
								)
							end
						end
						self:freeRegister(tmpReg, false)
					else
						local tmpReg = retRegs[1] or self:allocRegister(false)
						self:addStatement(
							self:setRegister(scope, tmpReg, Ast.StringExpression(expression.passSelfFunctionName)),
							{ tmpReg },
							{},
							false
						)
						self:addStatement(
							self:setRegister(
								scope,
								tmpReg,
								Ast.IndexExpression(self:register(scope, baseReg), self:register(scope, tmpReg))
							),
							{ tmpReg },
							{ baseReg, tmpReg },
							false
						)
						self:addStatement(
							self:setRegister(
								scope,
								retRegs[1],
								Ast.FunctionCallExpression(self:register(scope, tmpReg), args)
							),
							{ retRegs[1] },
							{ baseReg, unpack(regs) },
							true
						)
					end
					for i, reg in ipairs(regs) do
						self:freeRegister(reg, false)
					end
					return retRegs
				end
				if expression.kind == AstKind.IndexExpression then
					local regs = {}
					for i = 1, numReturns do
						regs[i] = self:allocRegister()
						if i == 1 then
							local baseReg = self:compileExpression(expression.base, funcDepth, 1)[1]
							local indexReg = self:compileExpression(expression.index, funcDepth, 1)[1]
							self:addStatement(
								self:setRegister(
									scope,
									regs[i],
									Ast.IndexExpression(self:register(scope, baseReg), self:register(scope, indexReg))
								),
								{ regs[i] },
								{ baseReg, indexReg },
								true
							)
							self:freeRegister(baseReg, false)
							self:freeRegister(indexReg, false)
						else
							self:addStatement(
								self:setRegister(scope, regs[i], Ast.NilExpression()),
								{ regs[i] },
								{},
								false
							)
						end
					end
					return regs
				end
				if self.BIN_OPS[expression.kind] then
					local regs = {}
					for i = 1, numReturns do
						regs[i] = self:allocRegister()
						if i == 1 then
							local lhsReg = self:compileExpression(expression.lhs, funcDepth, 1)[1]
							local rhsReg = self:compileExpression(expression.rhs, funcDepth, 1)[1]
							self:addStatement(
								self:setRegister(
									scope,
									regs[i],
									Ast[expression.kind](self:register(scope, lhsReg), self:register(scope, rhsReg))
								),
								{ regs[i] },
								{ lhsReg, rhsReg },
								true
							)
							self:freeRegister(rhsReg, false)
							self:freeRegister(lhsReg, false)
						else
							self:addStatement(
								self:setRegister(scope, regs[i], Ast.NilExpression()),
								{ regs[i] },
								{},
								false
							)
						end
					end
					return regs
				end
				if expression.kind == AstKind.NotExpression then
					local regs = {}
					for i = 1, numReturns do
						regs[i] = self:allocRegister()
						if i == 1 then
							local rhsReg = self:compileExpression(expression.rhs, funcDepth, 1)[1]
							self:addStatement(
								self:setRegister(scope, regs[i], Ast.NotExpression(self:register(scope, rhsReg))),
								{ regs[i] },
								{ rhsReg },
								false
							)
							self:freeRegister(rhsReg, false)
						else
							self:addStatement(
								self:setRegister(scope, regs[i], Ast.NilExpression()),
								{ regs[i] },
								{},
								false
							)
						end
					end
					return regs
				end
				if expression.kind == AstKind.NegateExpression then
					local regs = {}
					for i = 1, numReturns do
						regs[i] = self:allocRegister()
						if i == 1 then
							local rhsReg = self:compileExpression(expression.rhs, funcDepth, 1)[1]
							self:addStatement(
								self:setRegister(scope, regs[i], Ast.NegateExpression(self:register(scope, rhsReg))),
								{ regs[i] },
								{ rhsReg },
								true
							)
							self:freeRegister(rhsReg, false)
						else
							self:addStatement(
								self:setRegister(scope, regs[i], Ast.NilExpression()),
								{ regs[i] },
								{},
								false
							)
						end
					end
					return regs
				end
				if expression.kind == AstKind.LenExpression then
					local regs = {}
					for i = 1, numReturns do
						regs[i] = self:allocRegister()
						if i == 1 then
							local rhsReg = self:compileExpression(expression.rhs, funcDepth, 1)[1]
							self:addStatement(
								self:setRegister(scope, regs[i], Ast.LenExpression(self:register(scope, rhsReg))),
								{ regs[i] },
								{ rhsReg },
								true
							)
							self:freeRegister(rhsReg, false)
						else
							self:addStatement(
								self:setRegister(scope, regs[i], Ast.NilExpression()),
								{ regs[i] },
								{},
								false
							)
						end
					end
					return regs
				end
				if expression.kind == AstKind.OrExpression then
					local posState = self.registers[self.POS_REGISTER]
					self.registers[self.POS_REGISTER] = self.VAR_REGISTER
					local regs = {}
					for i = 1, numReturns do
						regs[i] = self:allocRegister()
						if i ~= 1 then
							self:addStatement(
								self:setRegister(scope, regs[i], Ast.NilExpression()),
								{ regs[i] },
								{},
								false
							)
						end
					end
					local resReg = regs[1]
					local tmpReg
					if posState then
						tmpReg = self:allocRegister(false)
						self:addStatement(
							self:copyRegisters(scope, { tmpReg }, { self.POS_REGISTER }),
							{ tmpReg },
							{ self.POS_REGISTER },
							false
						)
					end
					local lhsReg = self:compileExpression(expression.lhs, funcDepth, 1)[1]
					if expression.rhs.isConstant then
						local rhsReg = self:compileExpression(expression.rhs, funcDepth, 1)[1]
						self:addStatement(
							self:setRegister(
								scope,
								resReg,
								Ast.OrExpression(self:register(scope, lhsReg), self:register(scope, rhsReg))
							),
							{ resReg },
							{ lhsReg, rhsReg },
							false
						)
						if tmpReg then
							self:freeRegister(tmpReg, false)
						end
						self:freeRegister(lhsReg, false)
						self:freeRegister(rhsReg, false)
						return regs
					end
					local block1, block2 = self:createBlock(), self:createBlock()
					self:addStatement(self:copyRegisters(scope, { resReg }, { lhsReg }), { resReg }, { lhsReg }, false)
					self:addStatement(
						self:setRegister(
							scope,
							self.POS_REGISTER,
							Ast.OrExpression(
								Ast.AndExpression(self:register(scope, lhsReg), Ast.NumberExpression(block2.id)),
								Ast.NumberExpression(block1.id)
							)
						),
						{ self.POS_REGISTER },
						{ lhsReg },
						false
					)
					self:freeRegister(lhsReg, false)
					do
						self:setActiveBlock(block1)
						local scope = block1.scope
						local rhsReg = self:compileExpression(expression.rhs, funcDepth, 1)[1]
						self:addStatement(
							self:copyRegisters(scope, { resReg }, { rhsReg }),
							{ resReg },
							{ rhsReg },
							false
						)
						self:freeRegister(rhsReg, false)
						self:addStatement(
							self:setRegister(scope, self.POS_REGISTER, Ast.NumberExpression(block2.id)),
							{ self.POS_REGISTER },
							{},
							false
						)
					end
					self.registers[self.POS_REGISTER] = posState
					self:setActiveBlock(block2)
					scope = block2.scope
					if tmpReg then
						self:addStatement(
							self:copyRegisters(scope, { self.POS_REGISTER }, { tmpReg }),
							{ self.POS_REGISTER },
							{ tmpReg },
							false
						)
						self:freeRegister(tmpReg, false)
					end
					return regs
				end
				if expression.kind == AstKind.AndExpression then
					local posState = self.registers[self.POS_REGISTER]
					self.registers[self.POS_REGISTER] = self.VAR_REGISTER
					local regs = {}
					for i = 1, numReturns do
						regs[i] = self:allocRegister()
						if i ~= 1 then
							self:addStatement(
								self:setRegister(scope, regs[i], Ast.NilExpression()),
								{ regs[i] },
								{},
								false
							)
						end
					end
					local resReg = regs[1]
					local tmpReg
					if posState then
						tmpReg = self:allocRegister(false)
						self:addStatement(
							self:copyRegisters(scope, { tmpReg }, { self.POS_REGISTER }),
							{ tmpReg },
							{ self.POS_REGISTER },
							false
						)
					end
					local lhsReg = self:compileExpression(expression.lhs, funcDepth, 1)[1]
					if expression.rhs.isConstant then
						local rhsReg = self:compileExpression(expression.rhs, funcDepth, 1)[1]
						self:addStatement(
							self:setRegister(
								scope,
								resReg,
								Ast.AndExpression(self:register(scope, lhsReg), self:register(scope, rhsReg))
							),
							{ resReg },
							{ lhsReg, rhsReg },
							false
						)
						if tmpReg then
							self:freeRegister(tmpReg, false)
						end
						self:freeRegister(lhsReg, false)
						self:freeRegister(rhsReg, false)
						return regs
					end
					local block1, block2 = self:createBlock(), self:createBlock()
					self:addStatement(self:copyRegisters(scope, { resReg }, { lhsReg }), { resReg }, { lhsReg }, false)
					self:addStatement(
						self:setRegister(
							scope,
							self.POS_REGISTER,
							Ast.OrExpression(
								Ast.AndExpression(self:register(scope, lhsReg), Ast.NumberExpression(block1.id)),
								Ast.NumberExpression(block2.id)
							)
						),
						{ self.POS_REGISTER },
						{ lhsReg },
						false
					)
					self:freeRegister(lhsReg, false)
					do
						self:setActiveBlock(block1)
						scope = block1.scope
						local rhsReg = self:compileExpression(expression.rhs, funcDepth, 1)[1]
						self:addStatement(
							self:copyRegisters(scope, { resReg }, { rhsReg }),
							{ resReg },
							{ rhsReg },
							false
						)
						self:freeRegister(rhsReg, false)
						self:addStatement(
							self:setRegister(scope, self.POS_REGISTER, Ast.NumberExpression(block2.id)),
							{ self.POS_REGISTER },
							{},
							false
						)
					end
					self.registers[self.POS_REGISTER] = posState
					self:setActiveBlock(block2)
					scope = block2.scope
					if tmpReg then
						self:addStatement(
							self:copyRegisters(scope, { self.POS_REGISTER }, { tmpReg }),
							{ self.POS_REGISTER },
							{ tmpReg },
							false
						)
						self:freeRegister(tmpReg, false)
					end
					return regs
				end
				if expression.kind == AstKind.TableConstructorExpression then
					local regs = {}
					for i = 1, numReturns do
						regs[i] = self:allocRegister()
						if i == 1 then
							local entries = {}
							local entryRegs = {}
							for i, entry in ipairs(expression.entries) do
								if entry.kind == AstKind.TableEntry then
									local value = entry.value
									if
										i == #expression.entries
										and (
											value.kind == AstKind.FunctionCallExpression
											or value.kind == AstKind.PassSelfFunctionCallExpression
											or value.kind == AstKind.VarargExpression
										)
									then
										local reg = self:compileExpression(entry.value, funcDepth, self.RETURN_ALL)[1]
										table.insert(
											entries,
											Ast.TableEntry(
												Ast.FunctionCallExpression(
													self:unpack(scope),
													{ self:register(scope, reg) }
												)
											)
										)
										table.insert(entryRegs, reg)
									else
										local reg = self:compileExpression(entry.value, funcDepth, 1)[1]
										table.insert(entries, Ast.TableEntry(self:register(scope, reg)))
										table.insert(entryRegs, reg)
									end
								else
									local keyReg = self:compileExpression(entry.key, funcDepth, 1)[1]
									local valReg = self:compileExpression(entry.value, funcDepth, 1)[1]
									table.insert(
										entries,
										Ast.KeyedTableEntry(self:register(scope, keyReg), self:register(scope, valReg))
									)
									table.insert(entryRegs, valReg)
									table.insert(entryRegs, keyReg)
								end
							end
							self:addStatement(
								self:setRegister(scope, regs[i], Ast.TableConstructorExpression(entries)),
								{ regs[i] },
								entryRegs,
								false
							)
							for i, reg in ipairs(entryRegs) do
								self:freeRegister(reg, false)
							end
						else
							self:addStatement(
								self:setRegister(scope, regs[i], Ast.NilExpression()),
								{ regs[i] },
								{},
								false
							)
						end
					end
					return regs
				end
				if expression.kind == AstKind.FunctionLiteralExpression then
					local regs = {}
					for i = 1, numReturns do
						if i == 1 then
							regs[i] = self:compileFunction(expression, funcDepth)
						else
							regs[i] = self:allocRegister()
							self:addStatement(
								self:setRegister(scope, regs[i], Ast.NilExpression()),
								{ regs[i] },
								{},
								false
							)
						end
					end
					return regs
				end
				if expression.kind == AstKind.VarargExpression then
					if numReturns == self.RETURN_ALL then
						return { self.varargReg }
					end
					local regs = {}
					for i = 1, numReturns do
						regs[i] = self:allocRegister(false)
						self:addStatement(
							self:setRegister(
								scope,
								regs[i],
								Ast.IndexExpression(self:register(scope, self.varargReg), Ast.NumberExpression(i))
							),
							{ regs[i] },
							{ self.varargReg },
							false
						)
					end
					return regs
				end
				logger:error(string.format("Cannot compile expression of kind: %s", expression.kind))
			end
			return Compiler
		end
		function _ZukOfficial.A()
			local v = _ZukOfficial.cache.A
			if not v then
				v = { c = __modImpl() }
				_ZukOfficial.cache.A = v
			end
			return v.c
		end
	end
	do
		local function __modImpl()
			local Ast = _ZukOfficial.b()
			local AstKind = Ast.AstKind
			local Optimizer = {}
			Optimizer.__index = Optimizer
			local SAFE_GLOBALS = {
				["tostring"] = true,
				["tonumber"] = true,
				["type"] = true,
				["pairs"] = true,
				["ipairs"] = true,
				["select"] = true,
				["unpack"] = true,
				["rawget"] = true,
				["rawset"] = true,
				["rawequal"] = true,
				["rawlen"] = true,
				["pcall"] = true,
				["xpcall"] = true,
				["error"] = true,
				["assert"] = true,
				["print"] = true,
				["setmetatable"] = true,
				["getmetatable"] = true,
				["next"] = true,
				["load"] = true,
				["loadstring"] = true,
				["require"] = true,
				["string"] = true,
				["table"] = true,
				["math"] = true,
				["bit"] = true,
				["bit32"] = true,
				["os"] = true,
				["io"] = true,
				["coroutine"] = true,
				["task"] = true,
				["game"] = true,
				["workspace"] = true,
				["script"] = true,
				["shared"] = true,
			}
			local GLOBAL_CONSTANTS = {
				["math.pi"] = math.pi,
				["math.huge"] = math.huge,
				["math.maxinteger"] = 2 ^ 53,
			}
			function Optimizer:new(level)
				local o = setmetatable({}, self)
				o.level = level or 2
				return o
			end
			local FOLD_OPS = {
				[AstKind.AddExpression] = function(a, b)
					return a + b
				end,
				[AstKind.SubExpression] = function(a, b)
					return a - b
				end,
				[AstKind.MulExpression] = function(a, b)
					return a * b
				end,
				[AstKind.DivExpression] = function(a, b)
					return b ~= 0 and a / b or nil
				end,
				[AstKind.ModExpression] = function(a, b)
					return b ~= 0 and a % b or nil
				end,
				[AstKind.PowExpression] = function(a, b)
					return a ^ b
				end,
				[AstKind.LessThanExpression] = function(a, b)
					return a < b
				end,
				[AstKind.GreaterThanExpression] = function(a, b)
					return a > b
				end,
				[AstKind.LessThanOrEqualsExpression] = function(a, b)
					return a <= b
				end,
				[AstKind.GreaterThanOrEqualsExpression] = function(a, b)
					return a >= b
				end,
				[AstKind.EqualsExpression] = function(a, b)
					return a == b
				end,
				[AstKind.NotEqualsExpression] = function(a, b)
					return a ~= b
				end,
				[AstKind.StrCatExpression] = function(a, b)
					if type(a) == "string" and type(b) == "string" then
						return a .. b
					end
				end,
			}
			local function isNumberLit(node)
				return node.kind == AstKind.NumberExpression
			end
			local function isStringLit(node)
				return node.kind == AstKind.StringExpression
			end
			local function isBoolLit(node)
				return node.kind == AstKind.BooleanExpression
			end
			local function isNilLit(node)
				return node.kind == AstKind.NilExpression
			end
			local function isLiteral(node)
				return isNumberLit(node) or isStringLit(node) or isBoolLit(node) or isNilLit(node)
			end
			local function getLiteralValue(node)
				if isNumberLit(node) then
					return node.value
				end
				if isStringLit(node) then
					return node.value
				end
				if isBoolLit(node) then
					return node.value
				end
				if isNilLit(node) then
					return nil
				end
			end
			local function foldNode(node)
				if not node then
					return node
				end
				if node.lhs then
					node.lhs = foldNode(node.lhs)
				end
				if node.rhs then
					node.rhs = foldNode(node.rhs)
				end
				local op = FOLD_OPS[node.kind]
				if op and node.lhs and node.rhs then
					local lv = getLiteralValue(node.lhs)
					local rv = getLiteralValue(node.rhs)
					if lv ~= nil and rv ~= nil then
						local ok, result = pcall(op, lv, rv)
						if ok and result ~= nil then
							if type(result) == "number" then
								return Ast.NumberExpression(result)
							elseif type(result) == "boolean" then
								return Ast.BooleanExpression(result)
							elseif type(result) == "string" then
								return Ast.StringExpression(result)
							end
						end
					end
				end
				if node.kind == AstKind.NegateExpression and node.rhs then
					node.rhs = foldNode(node.rhs)
					if isNumberLit(node.rhs) then
						return Ast.NumberExpression(-node.rhs.value)
					end
				end
				if node.kind == AstKind.NotExpression and node.rhs then
					node.rhs = foldNode(node.rhs)
					if isLiteral(node.rhs) then
						local v = getLiteralValue(node.rhs)
						return Ast.BooleanExpression(not v)
					end
				end
				if node.kind == AstKind.StrCatExpression and node.lhs and node.rhs then
					if isStringLit(node.lhs) and isStringLit(node.rhs) then
						return Ast.StringExpression(node.lhs.value .. node.rhs.value)
					end
					if isNumberLit(node.lhs) and isStringLit(node.rhs) then
						return Ast.StringExpression(tostring(node.lhs.value) .. node.rhs.value)
					end
					if isStringLit(node.lhs) and isNumberLit(node.rhs) then
						return Ast.StringExpression(node.lhs.value .. tostring(node.rhs.value))
					end
				end
				return node
			end
			function Optimizer:constantFold(ast)
				local function walkNode(node)
					if not node or type(node) ~= "table" then
						return node
					end
					if node.kind then
						for k, v in pairs(node) do
							if type(v) == "table" and v.kind then
								node[k] = walkNode(v)
							elseif type(v) == "table" and not v.kind then
								for i, child in ipairs(v) do
									if type(child) == "table" and child.kind then
										v[i] = walkNode(child)
									end
								end
							end
						end
						return foldNode(node)
					end
					return node
				end
				walkNode(ast)
				return ast
			end
			function Optimizer:mergeJumps(blocks)
				if not blocks or #blocks < 2 then
					return blocks
				end
				local idToIdx = {}
				for i, b in ipairs(blocks) do
					idToIdx[b.id] = i
				end
				local predCount = {}
				for _, b in ipairs(blocks) do
					predCount[b.id] = predCount[b.id] or 0
				end
				local changed = true
				local iterations = 0
				while changed and iterations < 20 do
					changed = false
					iterations = iterations + 1
					for i = 1, #blocks - 1 do
						local b = blocks[i]
						local stmts = b.statements
						if #stmts == 1 then
							local s = stmts[1].statement
							if
								s
								and s.kind == AstKind.AssignmentStatement
								and s.lhs
								and #s.lhs == 1
								and s.rhs
								and #s.rhs == 1
								and s.rhs[1].kind == AstKind.NumberExpression
							then
								local targetId = s.rhs[1].value
								local targetIdx = idToIdx[targetId]
								if targetIdx and targetIdx ~= i then
									local target = blocks[targetIdx]
									if target and #target.statements > 0 then
										for _, ts in ipairs(target.statements) do
											table.insert(b.statements, ts)
										end
										target.statements = {}
										changed = true
									end
								end
							end
						end
					end
				end
				return blocks
			end
			function Optimizer:constantPropagate(ast)
				local function propagateBlock(statements)
					local known = {}
					for _, stmt in ipairs(statements) do
						if stmt and type(stmt) == "table" then
							if stmt.kind == AstKind.LocalVariableDeclaration then
								if #stmt.ids == 1 and #stmt.expressions == 1 then
									local expr = stmt.expressions[1]
									if isLiteral(expr) then
										local key = tostring(stmt.scope) .. ":" .. tostring(stmt.ids[1])
										known[key] = expr
									else
										local key = tostring(stmt.scope) .. ":" .. tostring(stmt.ids[1])
										known[key] = nil
									end
								end
							elseif stmt.kind == AstKind.AssignmentStatement then
								if stmt.lhs then
									for _, lv in ipairs(stmt.lhs) do
										if lv.kind == AstKind.AssignmentVariable then
											local key = tostring(lv.scope) .. ":" .. tostring(lv.id)
											known[key] = nil
										end
									end
								end
							end
							local function substituteNode(node)
								if not node or type(node) ~= "table" then
									return node
								end
								if node.kind == AstKind.VariableExpression then
									local key = tostring(node.scope) .. ":" .. tostring(node.id)
									if known[key] then
										local c = known[key]
										if c.kind == AstKind.NumberExpression then
											return Ast.NumberExpression(c.value)
										end
										if c.kind == AstKind.StringExpression then
											return Ast.StringExpression(c.value)
										end
										if c.kind == AstKind.BooleanExpression then
											return Ast.BooleanExpression(c.value)
										end
										if c.kind == AstKind.NilExpression then
											return Ast.NilExpression()
										end
									end
								end
								for k, v in pairs(node) do
									if type(v) == "table" and v.kind then
										node[k] = substituteNode(v)
									elseif type(v) == "table" and not v.kind then
										for i, child in ipairs(v) do
											if type(child) == "table" and child.kind then
												v[i] = substituteNode(child)
											end
										end
									end
								end
								return node
							end
							substituteNode(stmt)
						end
					end
				end
				local function walkForPropagation(node)
					if not node or type(node) ~= "table" then
						return
					end
					if node.kind == AstKind.Block and node.statements then
						propagateBlock(node.statements)
					end
					for _, v in pairs(node) do
						if type(v) == "table" and v.kind then
							walkForPropagation(v)
						elseif type(v) == "table" and not v.kind then
							for _, child in ipairs(v) do
								if type(child) == "table" and child.kind then
									walkForPropagation(child)
								end
							end
						end
					end
				end
				walkForPropagation(ast)
				return ast
			end
			function Optimizer:localizeGlobals(ast, globalScope, threshold)
				threshold = threshold or 2
				local globalCounts = {}
				local function countGlobals(node)
					if not node or type(node) ~= "table" then
						return
					end
					if node.kind == AstKind.VariableExpression and node.scope and node.scope.isGlobal then
						local name = nil
						if node.scope.getVariableName then
							name = node.scope:getVariableName(node.id)
						end
						if name and SAFE_GLOBALS[name] then
							globalCounts[name] = (globalCounts[name] or 0) + 1
						end
					end
					for _, v in pairs(node) do
						if type(v) == "table" and v.kind then
							countGlobals(v)
						elseif type(v) == "table" and not v.kind then
							for _, child in ipairs(v) do
								if type(child) == "table" and child.kind then
									countGlobals(child)
								end
							end
						end
					end
				end
				countGlobals(ast)
				local toLocalize = {}
				for name, count in pairs(globalCounts) do
					if count >= threshold then
						table.insert(toLocalize, name)
					end
				end
				if #toLocalize == 0 then
					return ast
				end
				if ast.kind == AstKind.TopNode and ast.body and ast.body.kind == AstKind.Block then
					local body = ast.body
					local scope = body.scope
					local localMap = {}
					for _, name in ipairs(toLocalize) do
						local varId = scope:addVariable()
						localMap[name] = { scope = scope, id = varId }
						local _, gid = globalScope:resolve(name)
						if gid then
							local decl = Ast.LocalVariableDeclaration(
								scope,
								{ varId },
								{ Ast.VariableExpression(globalScope, gid) }
							)
							table.insert(body.statements, 1, decl)
						end
					end
					local function rewriteGlobals(node)
						if not node or type(node) ~= "table" then
							return node
						end
						if node.kind == AstKind.VariableExpression and node.scope and node.scope.isGlobal then
							local name = nil
							if node.scope.getVariableName then
								name = node.scope:getVariableName(node.id)
							end
							if name and localMap[name] then
								local loc = localMap[name]
								return Ast.VariableExpression(loc.scope, loc.id)
							end
						end
						for k, v in pairs(node) do
							if type(v) == "table" and v.kind then
								node[k] = rewriteGlobals(v)
							elseif type(v) == "table" and not v.kind then
								for i, child in ipairs(v) do
									if type(child) == "table" and child.kind then
										v[i] = rewriteGlobals(child)
									end
								end
							end
						end
						return node
					end
					for i = #toLocalize + 1, #body.statements do
						body.statements[i] = rewriteGlobals(body.statements[i])
					end
				end
				return ast
			end
			function Optimizer:foldGlobalConstants(ast)
				local function walkFoldGlobals(node)
					if not node or type(node) ~= "table" then
						return node
					end
					if node.kind == AstKind.IndexExpression then
						local base = node.base
						local index = node.index
						if
							base
							and base.kind == AstKind.VariableExpression
							and base.scope
							and base.scope.isGlobal
							and index
							and index.kind == AstKind.StringExpression
						then
							local baseName = nil
							if base.scope.getVariableName then
								baseName = base.scope:getVariableName(base.id)
							end
							if baseName then
								local key = baseName .. "." .. index.value
								if GLOBAL_CONSTANTS[key] ~= nil then
									return Ast.NumberExpression(GLOBAL_CONSTANTS[key])
								end
							end
						end
					end
					for k, v in pairs(node) do
						if type(v) == "table" and v.kind then
							node[k] = walkFoldGlobals(v)
						elseif type(v) == "table" and not v.kind then
							for i, child in ipairs(v) do
								if type(child) == "table" and child.kind then
									v[i] = walkFoldGlobals(child)
								end
							end
						end
					end
					return node
				end
				walkFoldGlobals(ast)
				return ast
			end
			function Optimizer:optimize(ast, globalScope)
				local level = self.level
				if level >= 1 then
					ast = self:constantFold(ast)
				end
				if level >= 2 then
					ast = self:constantPropagate(ast)
					ast = self:constantFold(ast)
				end
				if level >= 3 then
					ast = self:foldGlobalConstants(ast)
					if globalScope then
						ast = self:localizeGlobals(ast, globalScope, 3)
					end
					ast = self:constantFold(ast)
				end
				return ast
			end
			function Optimizer:postCompilePass(compiler)
				if self.level >= 1 then
					self:mergeJumps(compiler.blocks)
				end
			end
			return Optimizer
		end
		function _ZukOfficial.B()
			local v = _ZukOfficial.cache.B
			if not v then
				v = { c = __modImpl() }
				_ZukOfficial.cache.B = v
			end
			return v.c
		end
	end
	do
		local function __modImpl()
			local Step = _ZukOfficial.n()
			local Compiler = _ZukOfficial.A()
			local Optimizer = _ZukOfficial.B()
			local Vmify = Step:extend()
			Vmify.Description = "Compiles your script into a fully-custom bytecode VM format. "
				.. "OptimizationLevel mirrors Luraph's optimizer: "
				.. "0=none, 1=fold+jump-merge, 2=+propagation, 3=+global-localization."
			Vmify.Name = "Vmify"
			Vmify.SettingsDescriptor = {
				OptimizationLevel = {
					type = "number",
					default = 0,
					min = 0,
					max = 3,
				},
			}
			function Vmify:init(settings)
				settings = settings or {}
				self.optimizationLevel = settings.OptimizationLevel or 0
			end
			function Vmify:apply(ast)
				local level = self.optimizationLevel
				if level >= 1 then
					local optimizer = Optimizer:new(level)
					local globalScope = nil
					if ast.globalScope then
						globalScope = ast.globalScope
					elseif ast.body and ast.body.scope then
						local s = ast.body.scope
						while s and s.parentScope do
							s = s.parentScope
						end
						globalScope = s
					end
					ast = optimizer:optimize(ast, globalScope)
					local compiler = Compiler:new()
					local originalCompileTopNode = compiler.compileTopNode
					compiler.compileTopNode = function(self_c, node)
						originalCompileTopNode(self_c, node)
						optimizer:postCompilePass(self_c)
					end
					return compiler:compile(ast)
				end
				local compiler = Compiler:new()
				return compiler:compile(ast)
			end
			return Vmify
		end
		function _ZukOfficial.C()
			local v = _ZukOfficial.cache.C
			if not v then
				v = { c = __modImpl() }
				_ZukOfficial.cache.C = v
			end
			return v.c
		end
	end
	do
		local function __modImpl()
			local Step = _ZukOfficial.n()
			local Ast = _ZukOfficial.b()
			local Parser = _ZukOfficial.j()
			local Enums = _ZukOfficial.g()
			local visitast = _ZukOfficial.q()
			local AstKind = Ast.AstKind
			local LuaVersion = Enums.LuaVersion
			local StatementFlattener = Step:extend()
			StatementFlattener.Description =
				"Converts if-statements to while-break loops and flattens local-function bodies into opcode-dispatched state machines."
			StatementFlattener.Name = "Statement Flattener"
			StatementFlattener.SettingsDescriptor = {
				FlattenIf = {
					type = "boolean",
					default = true,
				},
				FlattenFunctions = {
					type = "boolean",
					default = true,
				},
				Threshold = {
					type = "number",
					default = 0.9,
					min = 0,
					max = 1,
				},
			}
			local function parseSnippet(src)
				local ok, result = pcall(function()
					return Parser:new({ LuaVersion = LuaVersion.Lua51 }):parse(src)
				end)
				if not ok or not result then
					return nil
				end
				return result.body and result.body.statements
			end
			local _opPool = (function()
				local POOL_SIZE = 512
				local pool = {}
				local used = {}
				while #pool < POOL_SIZE do
					local v = math.random(2, 2 ^ 28)
					if not used[v] then
						used[v] = true
						pool[#pool + 1] = v
					end
				end
				for i = #pool, 2, -1 do
					local j = math.random(1, i)
					pool[i], pool[j] = pool[j], pool[i]
				end
				return pool
			end)()
			local _opIdx = 0
			local function randOp()
				_opIdx = (_opIdx % #_opPool) + 1
				return math.floor(_opPool[_opIdx] * math.random()) % (2 ^ 22 - 2) + 2
			end
			local function shallowCopy(t)
				local c = {}
				for k, v in pairs(t) do
					c[k] = v
				end
				return c
			end
			local function flattenIfNode(node)
				if node.kind ~= AstKind.IfStatement then
					return
				end
				if node.elseifs and #node.elseifs > 0 then
					return
				end
				if node.elseBody then
					return
				end
				local body = node.body
				if not body or not body.statements then
					return
				end
				local whileNode = {
					kind = AstKind.WhileStatement,
					condition = node.condition,
					body = body,
					parentScope = node.scope or (body and body.scope),
				}
				local hasReturn = body.statements[#body.statements]
					and body.statements[#body.statements].kind == AstKind.ReturnStatement
				if not hasReturn then
					local breakNode = Ast.BreakStatement(whileNode, body.scope)
					table.insert(body.statements, breakNode)
				end
				node.kind = AstKind.WhileStatement
				node.condition = whileNode.condition
				node.body = body
				node.parentScope = whileNode.parentScope
				node.elseifs = nil
				node.elseBody = nil
				local lastStmt = body.statements[#body.statements]
				if lastStmt and lastStmt.kind == AstKind.BreakStatement then
					lastStmt.loop = node
				end
			end
			local function flattenFunctionNode(node)
				if node.kind ~= AstKind.LocalFunctionDeclaration then
					return
				end
				local body = node.body
				local stmts = body and body.statements
				if not stmts or #stmts == 0 then
					return
				end
				local funcScope = body.scope
				local opcodes = {}
				for i = 1, #stmts do
					opcodes[i] = { op = randOp(), next = nil, stmt = stmts[i] }
				end
				for i = 1, #opcodes do
					opcodes[i].next = opcodes[i + 1] and opcodes[i + 1].op or randOp()
				end
				local hoistedIds = {}
				local hoistedSet = {}
				for _, entry in ipairs(opcodes) do
					local s = entry.stmt
					if s.kind == AstKind.LocalVariableDeclaration then
						for _, vid in ipairs(s.ids or {}) do
							local key = tostring(s.scope) .. ":" .. tostring(vid)
							if not hoistedSet[key] then
								hoistedSet[key] = true
								table.insert(hoistedIds, { scope = s.scope, id = vid })
							end
						end
					elseif s.kind == AstKind.LocalFunctionDeclaration then
						local vid = s.id
						local key = tostring(s.scope) .. ":" .. tostring(vid)
						if vid and not hoistedSet[key] then
							hoistedSet[key] = true
							table.insert(hoistedIds, { scope = s.scope, id = vid })
						end
					end
				end
				local stateId = funcScope:addVariable()
				local firstOp = opcodes[1].op
				local stateDecl = Ast.LocalVariableDeclaration(
					funcScope,
					{ stateId },
					{ Ast.NumberExpression(firstOp) }
				)
				local hoistDecl = nil
				if #hoistedIds > 0 then
					local ids = {}
					for _, v in ipairs(hoistedIds) do
						table.insert(ids, v.id)
					end
					hoistDecl = Ast.LocalVariableDeclaration(funcScope, ids, {})
				end
				local function buildIfChain(entries, idx)
					if idx > #entries then
						return nil
					end
					local entry = entries[idx]
					local orig = entry.stmt
					local dispatchStmt
					if orig.kind == AstKind.LocalVariableDeclaration then
						local lhsNodes = {}
						for _, vid in ipairs(orig.ids or {}) do
							table.insert(lhsNodes, Ast.AssignmentVariable(orig.scope, vid))
						end
						dispatchStmt = Ast.AssignmentStatement(lhsNodes, orig.expressions or {})
					elseif orig.kind == AstKind.LocalFunctionDeclaration then
						dispatchStmt = Ast.AssignmentStatement(
							{ Ast.AssignmentVariable(orig.scope, orig.id) },
							{ Ast.FunctionLiteralExpression(orig.args or {}, orig.body) }
						)
					else
						dispatchStmt = orig
					end
					local stateAdvance = Ast.AssignmentStatement(
						{ Ast.AssignmentVariable(funcScope, stateId) },
						{ Ast.NumberExpression(entry.next) }
					)
					local branchScope = funcScope
					local ifBody = Ast.Block({ stateAdvance, dispatchStmt }, branchScope)
					local condition =
						Ast.EqualsExpression(Ast.VariableExpression(funcScope, stateId), Ast.NumberExpression(entry.op))
					local rest = buildIfChain(entries, idx + 1)
					return Ast.IfStatement(condition, ifBody, {}, rest and Ast.Block({ rest }, funcScope) or nil)
				end
				local ifChain = buildIfChain(opcodes, 1)
				local loopBody = Ast.Block(ifChain and { ifChain } or {}, funcScope)
				local whileNode = Ast.WhileStatement(loopBody, Ast.BooleanExpression(true), funcScope)
				local newStmts = { stateDecl }
				if hoistDecl then
					table.insert(newStmts, hoistDecl)
				end
				table.insert(newStmts, whileNode)
				body.statements = newStmts
			end
			function StatementFlattener:init(settings) end
			function StatementFlattener:apply(ast, pipeline)
				local doIf = self.FlattenIf
				local doFns = self.FlattenFunctions
				local thresh = self.Threshold
				visitast(ast, function(node, data)
					if doIf and node.kind == AstKind.IfStatement then
						if math.random() <= thresh then
							flattenIfNode(node)
						end
					elseif doFns and node.kind == AstKind.LocalFunctionDeclaration then
						if math.random() <= thresh then
							flattenFunctionNode(node)
						end
					end
				end)
				return ast
			end
			return StatementFlattener
		end
		function _ZukOfficial.D()
			local v = _ZukOfficial.cache.D
			if not v then
				v = { c = __modImpl() }
				_ZukOfficial.cache.D = v
			end
			return v.c
		end
	end
	do
		local function __modImpl()
			local Step = _ZukOfficial.n()
			local Ast = _ZukOfficial.b()
			local Parser = _ZukOfficial.j()
			local Enums = _ZukOfficial.g()
			local LuaVersion = Enums.LuaVersion
			local AntiDump = Step:extend()
			AntiDump.Description =
				"Upvalue bait + GC pressure to resist memory dumpers. __namecall trap removed (false-positived in Luau)."
			AntiDump.Name = "Anti Dump"
			AntiDump.SettingsDescriptor = {
				GCInterval = {
					name = "GCInterval",
					description = "Number of allocation loops in the GC pressure section",
					type = "number",
					default = 50,
					min = 10,
					max = 500,
				},
			}
			function AntiDump:init(settings) end
			function AntiDump:apply(ast, pipeline)
				local gcInterval = self.GCInterval or 50
				local sentinelVal = math.random(100000, 999999)
				local sentinelKey = "_zt" .. math.random(10000, 99999)
				local code = string.format(
					[[
            do
                local _trap_ok = true
                local _bait = { ["%s"] = %d }
                local function _bait_reader()
                    return _bait["%s"]
                end
                if _bait_reader() ~= %d then
                    _trap_ok = false
                end
                do
                    local _dbg = debug
                    if _dbg and _dbg["getinfo"] then
                        local _grm = getrawmetatable
                        if _grm ~= nil then
                            local _ok, _gi = pcall(_dbg["getinfo"], _grm)
                            if _ok and _gi and _gi["what"] ~= "C" then
                                _trap_ok = false
                            end
                        end
                    end
                end
                do
                    local _sink = {}
                    for _i = 1, %d do
                        local _t = {}
                        for _j = 1, 8 do _t[_j] = _i * _j end
                        _sink[_i] = _t
                    end
                    _sink = nil
                end
                if not _trap_ok then
                    task.defer(function() while true do task.wait(1e9) end end)
                    while true do task.wait(1e9) end
                end
            end
            ]],
					sentinelKey,
					sentinelVal,
					sentinelKey,
					sentinelVal,
					gcInterval
				)
				local parser = Parser:new({ LuaVersion = LuaVersion.Lua51 })
				local ok, parsed = pcall(function()
					return parser:parse(code)
				end)
				if not ok then
					return ast
				end
				for i = #parsed.body.statements, 1, -1 do
					local stat = parsed.body.statements[i]
					if stat.body and stat.body.scope then
						stat.body.scope:setParent(ast.body.scope)
					end
					table.insert(ast.body.statements, 1, stat)
				end
				return ast
			end
			return AntiDump
		end
		function _ZukOfficial.E()
			local v = _ZukOfficial.cache.E
			if not v then
				v = { c = __modImpl() }
				_ZukOfficial.cache.E = v
			end
			return v.c
		end
	end
	do
		local function __modImpl()
			local Step = _ZukOfficial.n()
			local Ast = _ZukOfficial.b()
			local visitast = _ZukOfficial.q()
			local AstKind = Ast.AstKind
			local VirtualGlobals = Step:extend()
			VirtualGlobals.Description =
				"Routes global references through a numeric-keyed local proxy table, hiding them from executor global-call scanners."
			VirtualGlobals.Name = "Virtual Globals"
			VirtualGlobals.SettingsDescriptor = {
				Treshold = {
					name = "Treshold",
					description = "Fraction of global references to redirect (0-1)",
					type = "number",
					default = 1,
					min = 0,
					max = 1,
				},
				UseNumericKeys = {
					name = "UseNumericKeys",
					description = "Use numeric keys instead of string keys",
					type = "boolean",
					default = true,
				},
			}
			function VirtualGlobals:init(settings) end
			function VirtualGlobals:apply(ast, pipeline)
				local globalScope = ast.globalScope
				local rootScope = ast.body.scope
				local nameToId = {}
				visitast(ast, nil, function(node)
					if node.kind == AstKind.VariableExpression and node.scope == globalScope then
						local name = globalScope:getVariableName(node.id)
						if name and not nameToId[name] then
							nameToId[name] = node.id
						end
					end
				end)
				if not next(nameToId) then
					return ast
				end
				local nameToKey = {}
				local keyBase = math.random(1000, 9000)
				local keyStep_ = math.random(7, 31)
				local idx = 0
				for name, _ in pairs(nameToId) do
					if self.UseNumericKeys then
						nameToKey[name] = keyBase + idx * keyStep_
					else
						nameToKey[name] = name
					end
					idx = idx + 1
				end
				local proxyId = rootScope:addVariable()
				local initStmts = {}
				table.insert(
					initStmts,
					Ast.LocalVariableDeclaration(rootScope, { proxyId }, { Ast.TableConstructorExpression({}) })
				)
				for name, gid in pairs(nameToId) do
					local key = nameToKey[name]
					local keyExpr = type(key) == "number" and Ast.NumberExpression(key) or Ast.StringExpression(key)
					rootScope:addReferenceToHigherScope(globalScope, gid)
					table.insert(
						initStmts,
						Ast.AssignmentStatement(
							{ Ast.AssignmentIndexing(Ast.VariableExpression(rootScope, proxyId), keyExpr) },
							{ Ast.VariableExpression(globalScope, gid) }
						)
					)
				end
				visitast(ast, nil, function(node, data)
					if
						node.kind == AstKind.VariableExpression
						and node.scope == globalScope
						and math.random() <= self.Treshold
					then
						local name = globalScope:getVariableName(node.id)
						local key = name and nameToKey[name]
						if key then
							local nodeScope = data and data.scope or rootScope
							nodeScope:addReferenceToHigherScope(rootScope, proxyId)
							local keyExpr = type(key) == "number" and Ast.NumberExpression(key)
								or Ast.StringExpression(key)
							return Ast.IndexExpression(Ast.VariableExpression(rootScope, proxyId), keyExpr)
						end
					end
				end)
				for i = #initStmts, 1, -1 do
					table.insert(ast.body.statements, 1, initStmts[i])
				end
				return ast
			end
			return VirtualGlobals
		end
		function _ZukOfficial.F()
			local v = _ZukOfficial.cache.F
			if not v then
				v = { c = __modImpl() }
				_ZukOfficial.cache.F = v
			end
			return v.c
		end
	end
	do
		local function __modImpl()
			local Step = _ZukOfficial.n()
			local Ast = _ZukOfficial.b()
			local Scope = _ZukOfficial.i()
			local visitast = _ZukOfficial.q()
			local AstKind = Ast.AstKind
			local FakeLoopWrap = Step:extend()
			FakeLoopWrap.Description =
				"Wraps random statements in fake single-iteration while-true-break loops (Luarmor-style control flow obfuscation)"
			FakeLoopWrap.Name = "Fake Loop Wrap"
			FakeLoopWrap.SettingsDescriptor = {
				Treshold = {
					type = "number",
					default = 0.35,
					min = 0,
					max = 1,
				},
			}
			function FakeLoopWrap:init(settings) end
			local UNSAFE_WRAP = {
				[AstKind.ReturnStatement] = true,
				[AstKind.BreakStatement] = true,
				[AstKind.ContinueStatement] = true,
			}
			local REAL_LOOP_STMT = {
				[AstKind.WhileStatement] = true,
				[AstKind.RepeatStatement] = true,
				[AstKind.ForStatement] = true,
				[AstKind.ForInStatement] = true,
			}
			local function containsLooseFlowControl(node)
				if type(node) ~= "table" or not node.kind then
					return false
				end
				if node.kind == AstKind.BreakStatement or node.kind == AstKind.ContinueStatement then
					return true
				end
				if REAL_LOOP_STMT[node.kind] then
					return false
				end
				for _, v in pairs(node) do
					if type(v) == "table" then
						if v.kind then
							if containsLooseFlowControl(v) then
								return true
							end
						else
							for _, child in ipairs(v) do
								if type(child) == "table" and child.kind then
									if containsLooseFlowControl(child) then
										return true
									end
								end
							end
						end
					end
				end
				return false
			end
			function FakeLoopWrap:apply(ast)
				local treshold = self.Treshold
				visitast(ast, function(node, data)
					if REAL_LOOP_STMT[node.kind] and node.body then
						node.body.__insideRealLoop = true
					end
				end, function(node, data)
					if node.kind ~= AstKind.Block then
						return
					end
					if node.__insideRealLoop then
						return
					end
					local i = 1
					while i <= #node.statements do
						local stmt = node.statements[i]
						local safeToWrap = not UNSAFE_WRAP[stmt.kind] and not containsLooseFlowControl(stmt)
						if safeToWrap and math.random() <= treshold then
							local loopScope = Scope:new(node.scope)
							local whileNode =
								Ast.WhileStatement(Ast.Block({}, loopScope), Ast.BooleanExpression(true), node.scope)
							local breakStmt = Ast.BreakStatement(whileNode, loopScope)
							local loopBody = Ast.Block({ stmt, breakStmt }, loopScope)
							whileNode.body = loopBody
							node.statements[i] = whileNode
						end
						i = i + 1
					end
				end)
			end
			return FakeLoopWrap
		end
		function _ZukOfficial.G()
			local v = _ZukOfficial.cache.G
			if not v then
				v = { c = __modImpl() }
				_ZukOfficial.cache.G = v
			end
			return v.c
		end
	end
	do
		local function __modImpl()
			local Step = _ZukOfficial.n()
			local Ast = _ZukOfficial.b()
			local Scope = _ZukOfficial.i()
			local WrapInFunction = Step:extend()
			WrapInFunction.Description = "This Step Wraps the Entire Script into a Function"
			WrapInFunction.Name = "Wrap in Function"
			WrapInFunction.SettingsDescriptor = {
				Iterations = {
					name = "Iterations",
					description = "The Number Of Iterations",
					type = "number",
					default = 1,
					min = 1,
					max = nil,
				},
			}
			function WrapInFunction:init(settings) end
			function WrapInFunction:apply(ast)
				for i = 1, self.Iterations, 1 do
					local body = ast.body
					local scope = Scope:new(ast.globalScope)
					body.scope:setParent(scope)
					ast.body = Ast.Block({
						Ast.ReturnStatement({
							Ast.FunctionCallExpression(
								Ast.FunctionLiteralExpression({ Ast.VarargExpression() }, body),
								{ Ast.VarargExpression() }
							),
						}),
					}, scope)
				end
			end
			return WrapInFunction
		end
		function _ZukOfficial.H()
			local v = _ZukOfficial.cache.H
			if not v then
				v = { c = __modImpl() }
				_ZukOfficial.cache.H = v
			end
			return v.c
		end
	end
	do
		local function __modImpl()
			local Step = _ZukOfficial.n()
			local Ast = _ZukOfficial.b()
			local Compressor = Step:extend()
			Compressor.Description = "Strips comments and collapses whitespace in the final source output."
			Compressor.Name = "Compressor"
			Compressor.SettingsDescriptor = {
				MinLength = {
					type = "number",
					default = 10,
					min = 0,
					max = 1e9,
				},
			}
			local LUA_KEYWORDS = {
				"and",
				"break",
				"do",
				"else",
				"elseif",
				"end",
				"false",
				"for",
				"function",
				"goto",
				"if",
				"in",
				"local",
				"nil",
				"not",
				"or",
				"repeat",
				"return",
				"then",
				"true",
				"until",
				"while",
			}
			local KW_PRE = "@@KW_"
			local KW_POST = "_KW@@"
			local ST_PRE = "@@S_"
			local ST_POST = "_S@@"
			local function compress(code, minLength)
				if type(code) ~= "string" then
					return code
				end
				if #code < (minLength or 10) then
					return code
				end
				local strings = {}
				local string_count = 0
				local keywords_map = {}
				local function preserveStrings(c)
					c = c:gsub("%[(=*)%[(.-)%]%1%]", function(equals, str)
						string_count = string_count + 1
						local key = ST_PRE .. string_count .. ST_POST
						strings[key] = "[" .. equals .. "[" .. str .. "]" .. equals .. "]"
						return key
					end)
					c = c:gsub('"(.-)"', function(str)
						if str:find(ST_PRE, 1, true) then
							return '"' .. str .. '"'
						end
						string_count = string_count + 1
						local key = ST_PRE .. string_count .. ST_POST
						strings[key] = '"' .. str .. '"'
						return key
					end)
					c = c:gsub("('.-')", function(str)
						if str:find(ST_PRE, 1, true) then
							return str
						end
						string_count = string_count + 1
						local key = ST_PRE .. string_count .. ST_POST
						strings[key] = str
						return key
					end)
					return c
				end
				local function preserveKeywords(c)
					for _, kw in ipairs(LUA_KEYWORDS) do
						local ph = KW_PRE .. kw .. KW_POST
						keywords_map[ph] = kw
						c = c:gsub("([^%w_])(" .. kw .. ")([^%w_])", "%1" .. ph .. "%3")
						c = c:gsub("^(" .. kw .. ")([^%w_])", ph .. "%2")
						c = c:gsub("([^%w_])(" .. kw .. ")$", "%1" .. ph)
						c = c:gsub("^(" .. kw .. ")$", ph)
					end
					return c
				end
				local function restoreKeywords(c)
					for ph, kw in pairs(keywords_map) do
						c = c:gsub(ph, function()
							return kw
						end)
					end
					return c
				end
				local function restoreStrings(c)
					for i = string_count, 1, -1 do
						local key = ST_PRE .. i .. ST_POST
						c = c:gsub(key, function()
							return strings[key]
						end)
					end
					return c
				end
				code = preserveStrings(code)
				code = preserveKeywords(code)
				code = code:gsub("%-%-%[%[.-%]%]", "")
				code = code:gsub("%-%-[^\n]*", "")
				code = code:gsub("[\n\r]+", " ")
				code = code:gsub("%s+", " ")
				code = code:gsub("%s*%.%.%s*", "..")
				code = code:gsub("%s*([%+%-%*/%%\\^#%<%>%~%=%,%;:%(%){}%[%]])%s*", "%1")
				code = code:gsub("%s*%.%s*", ".")
				code = code:gsub("%.%.", "..")
				code = code:match("^%s*(.-)%s*$") or ""
				code = restoreKeywords(code)
				code = restoreStrings(code)
				return code
			end
			function Compressor:init(settings) end
			function Compressor:apply(ast, pipeline)
				pipeline._compressorStep = self
				return ast
			end
			function Compressor:compressSource(source)
				return compress(source, self.MinLength)
			end
			return Compressor
		end
		function _ZukOfficial.I()
			local v = _ZukOfficial.cache.I
			if not v then
				v = { c = __modImpl() }
				_ZukOfficial.cache.I = v
			end
			return v.c
		end
	end
	do
		local function __modImpl()
			local Step = _ZukOfficial.n()
			local Ast = _ZukOfficial.b()
			local visitast = _ZukOfficial.q()
			local AstKind = Ast.AstKind
			local DeadCodeEliminator = Step:extend()
			DeadCodeEliminator.Description =
				"Removes dead junk code injected by obfuscation passes, reducing output size. Run last, before Compressor."
			DeadCodeEliminator.Name = "Dead Code Eliminator"
			DeadCodeEliminator.SettingsDescriptor = {
				EliminateJunkLocals = {
					type = "boolean",
					default = true,
					description = "Remove write-only local variables (JunkStatements output).",
				},
				EliminateDeadIf = {
					type = "boolean",
					default = true,
					description = "Remove if-blocks with a literal false/nil condition.",
				},
				FoldIdentities = {
					type = "boolean",
					default = true,
					description = "Collapse (x+0), (x*1), (x-0), (0+x), (1*x) to x.",
				},
				EliminateEmptyDo = {
					type = "boolean",
					default = true,
					description = "Remove do-end blocks that become empty after other passes.",
				},
			}
			function DeadCodeEliminator:init(settings) end
			local function isZeroNode(node)
				return node.kind == AstKind.NumberExpression and node.value == 0
			end
			local function isOneNode(node)
				return node.kind == AstKind.NumberExpression and node.value == 1
			end
			local function foldIdentities(ast)
				visitast(ast, nil, function(node)
					if node.kind == AstKind.AddExpression then
						if isZeroNode(node.rhs) then
							return node.lhs
						end
						if isZeroNode(node.lhs) then
							return node.rhs
						end
					end
					if node.kind == AstKind.SubExpression then
						if isZeroNode(node.rhs) then
							return node.lhs
						end
					end
					if node.kind == AstKind.MulExpression then
						if isOneNode(node.rhs) then
							return node.lhs
						end
						if isOneNode(node.lhs) then
							return node.rhs
						end
					end
					if node.kind == AstKind.DivExpression then
						if
							isOneNode(node.rhs)
							and node.lhs.kind == AstKind.NumberExpression
							and node.lhs.value == math.floor(node.lhs.value)
						then
							return node.lhs
						end
					end
					if node.kind == AstKind.MulExpression then
						if isZeroNode(node.rhs) then
							return Ast.NumberExpression(0)
						end
						if isZeroNode(node.lhs) then
							return Ast.NumberExpression(0)
						end
					end
				end)
			end
			local function eliminateDeadIf(ast)
				visitast(ast, nil, function(node)
					if node.kind == AstKind.IfStatement then
						local cond = node.condition
						if cond and cond.kind == AstKind.NilExpression then
							return Ast.DoStatement(Ast.Block({}, node.body.scope))
						end
						if cond and cond.kind == AstKind.BoolExpression and cond.value == false then
							return Ast.DoStatement(Ast.Block({}, node.body.scope))
						end
					end
				end)
			end
			local function getLocalVarName(scope, id)
				if scope and scope.getVariableName then
					local ok, name = pcall(function()
						return scope:getVariableName(id)
					end)
					if ok then
						return name
					end
				end
				return nil
			end
			local function containsRead(node, varScope, varId)
				if node == nil then
					return false
				end
				local found = false
				local function check(n)
					if found then
						return
					end
					if n == nil then
						return
					end
					if n.kind == AstKind.VariableExpression then
						if n.scope == varScope and n.id == varId then
							found = true
							return
						end
					end
					for _, field in ipairs({
						"lhs",
						"rhs",
						"condition",
						"value",
						"base",
						"index",
						"body",
						"args",
						"statements",
						"expression",
					}) do
						if n[field] then
							if type(n[field]) == "table" and n[field].kind then
								check(n[field])
							elseif type(n[field]) == "table" then
								for _, child in ipairs(n[field]) do
									if type(child) == "table" and child.kind then
										check(child)
									end
								end
							end
						end
					end
					if n.entries then
						for _, e in ipairs(n.entries) do
							if e.key then
								check(e.key)
							end
							if e.value then
								check(e.value)
							end
						end
					end
				end
				check(node)
				return found
			end
			local function eliminateWriteOnlyLocals(ast)
				local function processBlock(stmts, parentScope)
					if not stmts then
						return
					end
					local i = 1
					while i <= #stmts do
						local stmt = stmts[i]
						if stmt.kind == AstKind.LocalVariableDeclaration and stmt.ids and #stmt.ids == 1 then
							local varId = stmt.ids[1]
							local varScope = stmt.scope or parentScope
							local isWriteOnly = true
							for j = i + 1, #stmts do
								local s = stmts[j]
								if s.kind == AstKind.AssignmentStatement then
									if s.rhs then
										for _, rhs in ipairs(s.rhs) do
											if containsRead(rhs, varScope, varId) then
												isWriteOnly = false
												break
											end
										end
									end
									if isWriteOnly and s.lhs then
										for _, lhs in ipairs(s.lhs) do
											if
												lhs.kind ~= AstKind.VariableExpression
												or lhs.scope ~= varScope
												or lhs.id ~= varId
											then
												if containsRead(lhs, varScope, varId) then
													isWriteOnly = false
													break
												end
											end
										end
									end
								else
									if containsRead(s, varScope, varId) then
										isWriteOnly = false
										break
									end
								end
								if not isWriteOnly then
									break
								end
							end
							if isWriteOnly then
								table.remove(stmts, i)
								local j = i
								while j <= #stmts do
									local s = stmts[j]
									local isWriteToVar = false
									if s.kind == AstKind.AssignmentStatement and s.lhs then
										isWriteToVar = true
										for _, lhs in ipairs(s.lhs) do
											if
												lhs.kind ~= AstKind.VariableExpression
												or lhs.scope ~= varScope
												or lhs.id ~= varId
											then
												isWriteToVar = false
												break
											end
										end
									end
									if isWriteToVar then
										table.remove(stmts, j)
									else
										j = j + 1
									end
								end
							else
								i = i + 1
							end
						else
							i = i + 1
						end
					end
					for _, stmt in ipairs(stmts) do
						if stmt.body and stmt.body.statements then
							processBlock(stmt.body.statements, stmt.body.scope)
						end
						if stmt.thenBlock and stmt.thenBlock.statements then
							processBlock(stmt.thenBlock.statements, stmt.thenBlock.scope)
						end
						if stmt.elseBlock and stmt.elseBlock.statements then
							processBlock(stmt.elseBlock.statements, stmt.elseBlock.scope)
						end
						if stmt.elseifs then
							for _, ei in ipairs(stmt.elseifs) do
								if ei.body and ei.body.statements then
									processBlock(ei.body.statements, ei.body.scope)
								end
							end
						end
					end
				end
				if ast.body and ast.body.statements then
					processBlock(ast.body.statements, ast.body.scope)
				end
			end
			local function removeEmptyDo(stmts)
				if not stmts then
					return
				end
				local i = 1
				while i <= #stmts do
					local s = stmts[i]
					if s.kind == AstKind.DoStatement then
						if s.body and s.body.statements and #s.body.statements == 0 then
							table.remove(stmts, i)
						else
							if s.body and s.body.statements then
								removeEmptyDo(s.body.statements)
							end
							if s.body and s.body.statements and #s.body.statements == 0 then
								table.remove(stmts, i)
							else
								i = i + 1
							end
						end
					else
						for _, field in ipairs({ "body", "thenBlock", "elseBlock" }) do
							if s[field] and s[field].statements then
								removeEmptyDo(s[field].statements)
							end
						end
						if s.elseifs then
							for _, ei in ipairs(s.elseifs) do
								if ei.body then
									removeEmptyDo(ei.body.statements)
								end
							end
						end
						i = i + 1
					end
				end
			end
			function DeadCodeEliminator:apply(ast, pipeline)
				if self.FoldIdentities ~= false then
					local ok, err = pcall(foldIdentities, ast)
					if not ok then
					end
				end
				if self.EliminateDeadIf ~= false then
					local ok, err = pcall(eliminateDeadIf, ast)
					if not ok then
					end
				end
				if self.EliminateJunkLocals ~= false then
					local ok, err = pcall(eliminateWriteOnlyLocals, ast)
					if not ok then
					end
				end
				if self.EliminateEmptyDo ~= false then
					local ok, err = pcall(function()
						if ast.body and ast.body.statements then
							removeEmptyDo(ast.body.statements)
						end
					end)
					if not ok then
					end
				end
				return ast
			end
			return DeadCodeEliminator
		end
		function _ZukOfficial.J()
			local v = _ZukOfficial.cache.J
			if not v then
				v = { c = __modImpl() }
				_ZukOfficial.cache.J = v
			end
			return v.c
		end
	end
	do
		local function __modImpl()
			local Step = _ZukOfficial.n()
			local Ast = _ZukOfficial.b()
			local Scope = _ZukOfficial.i()
			local logger = _ZukOfficial.d()
			local AstKind = Ast.AstKind
			local BootstrapObfuscator = Step:extend()
			BootstrapObfuscator.Name = "BootstrapObfuscator"
			BootstrapObfuscator.Description = "Wraps the VM body in a 77fuscator-style counter state machine. "
				.. "Hides every VM setup statement inside a numbered if/elseif tree "
				.. "driven by a single incrementing counter variable."
			BootstrapObfuscator.SettingsDescriptor = {
				StatementsPerState = {
					type = "number",
					default = 1,
					min = 1,
					max = 4,
				},
				AddJunkState = {
					type = "boolean",
					default = true,
				},
			}
			local function buildTree(states, lo, hi, ctrScope, ctrId, bodyScope)
				if lo == hi then
					local stmts = states[lo]
					if #stmts == 1 then
						return stmts[1]
					end
					return Ast.DoStatement(Ast.Block(stmts, bodyScope))
				end
				local mid = math.floor((lo + hi) / 2)
				local left = buildTree(states, lo, mid, ctrScope, ctrId, bodyScope)
				local right = buildTree(states, mid + 1, hi, ctrScope, ctrId, bodyScope)
				local cond =
					Ast.LessThanOrEqualsExpression(Ast.VariableExpression(ctrScope, ctrId), Ast.NumberExpression(mid))
				return Ast.IfStatement(cond, Ast.Block({ left }, bodyScope), {}, Ast.Block({ right }, bodyScope))
			end
			function BootstrapObfuscator:init() end
			function BootstrapObfuscator:apply(ast, pipeline)
				local sps = self.StatementsPerState or 1
				local addJunk = self.AddJunkState ~= false
				local stmts = ast.body.statements
				local bodyScope = ast.body.scope
				local returnStmt = nil
				local mainStmts = {}
				for _, s in ipairs(stmts) do
					if s.kind == AstKind.ReturnStatement then
						returnStmt = s
					else
						table.insert(mainStmts, s)
					end
				end
				if #mainStmts == 0 then
					logger:warn("[BootstrapObfuscator] No statements to wrap, skipping.")
					return
				end
				local stateBuckets = {}
				local bucket = {}
				for _, s in ipairs(mainStmts) do
					table.insert(bucket, s)
					if #bucket >= sps then
						table.insert(stateBuckets, bucket)
						bucket = {}
					end
				end
				if #bucket > 0 then
					table.insert(stateBuckets, bucket)
				end
				if addJunk then
					local junkScope = Scope:new(bodyScope)
					local junkId = junkScope:addVariable()
					local junkStmt = Ast.LocalVariableDeclaration(
						junkScope,
						{ junkId },
						{ Ast.NumberExpression(math.random(1, 0xFFFF)) }
					)
					table.insert(stateBuckets, 1, { junkStmt })
				end
				local numStates = #stateBuckets
				local outerScope = Scope:new(ast.globalScope)
				bodyScope:setParent(outerScope)
				local ctrId = outerScope:addVariable()
				local ctrScope = outerScope
				local states = {}
				for i, b in ipairs(stateBuckets) do
					states[i - 1] = b
				end
				local tree = buildTree(states, 0, numStates - 1, ctrScope, ctrId, bodyScope)
				local incrStmt = Ast.AssignmentStatement(
					{ Ast.AssignmentVariable(ctrScope, ctrId) },
					{ Ast.AddExpression(Ast.VariableExpression(ctrScope, ctrId), Ast.NumberExpression(1)) }
				)
				local loopBodyScope = Scope:new(outerScope)
				local loopBody = Ast.Block({ tree, incrStmt }, loopBodyScope)
				local loopCond = Ast.LessThanOrEqualsExpression(
					Ast.VariableExpression(ctrScope, ctrId),
					Ast.NumberExpression(numStates - 1)
				)
				local whileStmt = Ast.WhileStatement(loopBody, loopCond, outerScope)
				local ctrDecl = Ast.LocalVariableDeclaration(outerScope, { ctrId }, { Ast.NumberExpression(0) })
				local newStatements = { ctrDecl, whileStmt }
				if returnStmt then
					table.insert(newStatements, returnStmt)
				end
				ast.body = Ast.Block(newStatements, outerScope)
				ast.body.scope = outerScope
				logger:info(
					string.format("[BootstrapObfuscator] Wrapped %d statements into %d states.", #mainStmts, numStates)
				)
			end
			return BootstrapObfuscator
		end
		function _ZukOfficial.P()
			local v = _ZukOfficial.cache.P
			if not v then
				v = { c = __modImpl() }
				_ZukOfficial.cache.P = v
			end
			return v.c
		end
	end
	do
		local function __modImpl()
			local ISA = {}
			ISA.OP = {
				LOADNIL = 0,
				LOADBOOL = 1,
				LOADINT = 2,
				LOADFLOAT = 3,
				LOADSTR = 4,
				MOVE = 5,
				GETGLOBAL = 6,
				SETGLOBAL = 7,
				GETTABLE = 8,
				SETTABLE = 9,
				NEWTABLE = 10,
				ADD = 11,
				SUB = 12,
				MUL = 13,
				DIV = 14,
				MOD = 15,
				POW = 16,
				CONCAT = 17,
				LT = 18,
				LE = 19,
				EQ = 20,
				NE = 21,
				GT = 22,
				GE = 23,
				NOT = 24,
				UNM = 25,
				LEN = 26,
				CALL = 27,
				CALLM = 28,
				VCALL = 29,
				JMP = 30,
				JMPT = 31,
				JMPF = 32,
				RETURN = 33,
				RETURNM = 34,
				ALLOC_UPVAL = 35,
				GET_UPVAL = 36,
				SET_UPVAL = 37,
				UPVAL_GET = 38,
				UPVAL_SET = 39,
				CLOSURE = 40,
				VARARG = 41,
				SETRET = 42,
				SETRETM = 43,
				FREE_UPVAL = 44,
			}
			ISA.OP_COUNT = 45
			function ISA.makeOpcodeMap(seed)
				local s
				if seed then
					s = seed % 4294967296
				else
					s = (math.random(0, 2147483647) * 6364136223846793005 + os.time()) % 4294967296
				end
				local function lcgNext(lo, hi)
					s = (s * 1664525 + 1013904223) % 4294967296
					return lo + (s % (hi - lo + 1))
				end
				local perm = {}
				for i = 0, 255 do
					perm[i + 1] = i
				end
				for i = 256, 2, -1 do
					local j = lcgNext(1, i)
					perm[i], perm[j] = perm[j], perm[i]
				end
				local encode, decode = {}, {}
				for canonical = 0, ISA.OP_COUNT - 1 do
					local wire = perm[canonical + 1]
					encode[canonical] = wire
					decode[wire] = canonical
				end
				return encode, decode
			end
			local function bxor8(a, b)
				local r, m = 0, 1
				while a > 0 or b > 0 do
					local ra, rb = a % 2, b % 2
					if ra ~= rb then
						r = r + m
					end
					a = math.floor(a / 2)
					b = math.floor(b / 2)
					m = m * 2
				end
				return r % 256
			end
			local function pack2(n)
				n = n % 65536
				return string.char(math.floor(n / 256), n % 256)
			end
			local function pack4(n)
				if n < 0 then
					n = n + 4294967296
				end
				n = n % 4294967296
				return string.char(
					math.floor(n / 16777216) % 256,
					math.floor(n / 65536) % 256,
					math.floor(n / 256) % 256,
					n % 256
				)
			end
			local function unpack2(s, pos)
				return s:byte(pos) * 256 + s:byte(pos + 1), pos + 2
			end
			local function unpack4(s, pos)
				local v = s:byte(pos) * 16777216 + s:byte(pos + 1) * 65536 + s:byte(pos + 2) * 256 + s:byte(pos + 3)
				if v >= 2147483648 then
					v = v - 4294967296
				end
				return v, pos + 4
			end
			local function packFloat(n)
				if n == 0 then
					return string.rep("\0", 8)
				end
				local sign = 0
				if n < 0 then
					sign = 1
					n = -n
				end
				local exp, mant = 0, n
				if mant >= 1 then
					while mant >= 2 do
						mant = mant / 2
						exp = exp + 1
					end
				else
					while mant < 1 do
						mant = mant * 2
						exp = exp - 1
					end
				end
				exp = exp + 1023
				mant = mant - 1
				local m52 = mant * (2 ^ 52)
				local mlo = m52 % 4294967296
				local mhi = math.floor(m52 / 4294967296) % 1048576
				local hi32 = sign * 2147483648 + exp * 1048576 + mhi
				local lo, hi = mlo, hi32
				local function b(v, sh)
					return math.floor(v / 2 ^ sh) % 256
				end
				return string.char(b(lo, 0), b(lo, 8), b(lo, 16), b(lo, 24), b(hi, 0), b(hi, 8), b(hi, 16), b(hi, 24))
			end
			local function unpackFloat(s, pos)
				local b = { s:byte(pos, pos + 7) }
				local lo = b[1] + b[2] * 256 + b[3] * 65536 + b[4] * 16777216
				local hi = b[5] + b[6] * 256 + b[7] * 65536 + b[8] * 16777216
				if lo == 0 and hi == 0 then
					return 0, pos + 8
				end
				local sign = math.floor(hi / 2147483648)
				local exp = math.floor(hi / 1048576) % 2048
				local mhi2 = hi % 1048576
				local mant = (mhi2 * 4294967296 + lo) / (2 ^ 52) + 1
				return ((-1) ^ sign) * (2 ^ (exp - 1023)) * mant, pos + 8
			end
			local function serialiseConst(v)
				local t = type(v)
				if t == "nil" then
					return "\0"
				elseif t == "boolean" then
					return "\1" .. (v and "\1" or "\0")
				elseif t == "number" then
					if v == math.floor(v) and v >= -2147483648 and v <= 2147483647 then
						return "\2" .. pack4(math.floor(v))
					else
						return "\3" .. packFloat(v)
					end
				elseif t == "string" then
					return "\4" .. pack2(#v) .. v
				end
				error("Cannot serialise const type " .. t)
			end
			local function deserialiseConst(s, pos)
				local ctype = s:byte(pos)
				pos = pos + 1
				if ctype == 0 then
					return nil, pos
				elseif ctype == 1 then
					local v = s:byte(pos) ~= 0
					pos = pos + 1
					return v, pos
				elseif ctype == 2 then
					local v
					v, pos = unpack4(s, pos)
					return v, pos
				elseif ctype == 3 then
					local v
					v, pos = unpackFloat(s, pos)
					return v, pos
				elseif ctype == 4 then
					local len
					len, pos = unpack2(s, pos)
					local v = s:sub(pos, pos + len - 1)
					return v, pos + len
				end
				error("Unknown const type " .. tostring(ctype))
			end
			local function makeLCGStream(seed)
				local s = seed % 4294967296
				return function()
					s = (s * 1664525 + 1013904223) % 4294967296
					return s % 256
				end
			end
			local function protoSeed(xorKey, depth)
				local lo = bxor8(xorKey % 256, math.floor(depth * 0x9E) % 256)
				return (lo + math.floor(xorKey / 256) * 256) % 4294967296
			end
			function ISA.serialiseProto(proto, xorKey, encodeOp, _depth)
				xorKey = xorKey or 0
				encodeOp = encodeOp or function(op)
					return op
				end
				_depth = _depth or 0
				local parts = {}
				parts[#parts + 1] = string.char(proto.params % 256, (proto.is_vararg and 1 or 0), proto.max_reg % 256)
				local constData = {}
				for _, v in ipairs(proto.consts) do
					constData[#constData + 1] = serialiseConst(v)
				end
				local constBlob = table.concat(constData)
				parts[#parts + 1] = pack2(#proto.consts) .. constBlob
				local instrData = {}
				local stream = makeLCGStream(protoSeed(xorKey, _depth))
				for _, instr in ipairs(proto.instrs) do
					local op = encodeOp(instr[1]) % 256
					local a = (instr[2] or 0) % 256
					local b = (instr[3] or 0) % 65536
					local c = (instr[4] or 0) % 65536
					local b_hi = math.floor(b / 256) % 256
					local b_lo = b % 256
					local c_hi = math.floor(c / 256) % 256
					local c_lo = c % 256
					instrData[#instrData + 1] = string.char(
						bxor8(op, stream()),
						bxor8(a, stream()),
						bxor8(b_hi, stream()),
						bxor8(b_lo, stream()),
						bxor8(c_hi, stream()),
						bxor8(c_lo, stream())
					)
				end
				parts[#parts + 1] = pack2(#proto.instrs) .. table.concat(instrData)
				parts[#parts + 1] = string.char(#proto.protos % 256)
				for _, sub in ipairs(proto.protos) do
					parts[#parts + 1] = ISA.serialiseProto(sub, xorKey, encodeOp, _depth + 1)
				end
				return table.concat(parts)
			end
			ISA.serialiseConst = serialiseConst
			ISA.deserialiseConst = deserialiseConst
			ISA.pack2 = pack2
			ISA.unpack2 = unpack2
			ISA.pack4 = pack4
			ISA.unpack4 = unpack4
			ISA.packFloat = packFloat
			ISA.unpackFloat = unpackFloat
			return ISA
		end
		function _ZukOfficial.Q()
			local v = _ZukOfficial.cache.Q
			if not v then
				v = { c = __modImpl() }
				_ZukOfficial.cache.Q = v
			end
			return v.c
		end
	end
	do
		local function __modImpl()
			local ISA = _ZukOfficial.Q()
			local Ast = _ZukOfficial.b()
			local logger = _ZukOfficial.d()
			local util = _ZukOfficial.f()
			local visitast = _ZukOfficial.q()
			local AstKind = Ast.AstKind
			local OP = ISA.OP
			local unpack = unpack or table.unpack
			local function lookupify(t)
				local r = {}
				for _, v in ipairs(t) do
					r[v] = true
				end
				return r
			end
			local BIN_OP_MAP = {
				[AstKind.AddExpression] = OP.ADD,
				[AstKind.SubExpression] = OP.SUB,
				[AstKind.MulExpression] = OP.MUL,
				[AstKind.DivExpression] = OP.DIV,
				[AstKind.ModExpression] = OP.MOD,
				[AstKind.PowExpression] = OP.POW,
				[AstKind.StrCatExpression] = OP.CONCAT,
				[AstKind.LessThanExpression] = OP.LT,
				[AstKind.LessThanOrEqualsExpression] = OP.LE,
				[AstKind.EqualsExpression] = OP.EQ,
				[AstKind.NotEqualsExpression] = OP.NE,
				[AstKind.GreaterThanExpression] = OP.GT,
				[AstKind.GreaterThanOrEqualsExpression] = OP.GE,
			}
			local BC = {}
			BC.__index = BC
			function BC:new()
				local o = setmetatable({}, BC)
				o.RETURN_ALL = {}
				o.VAR_REG = {}
				return o
			end
			function BC:newProto(params, isVararg)
				return {
					params = params or 0,
					is_vararg = isVararg or false,
					max_reg = 0,
					consts = {},
					constMap = {},
					instrs = {},
					protos = {},
					regNext = 0,
					maxRegSeen = 0,
				}
			end
			function BC:addConst(proto, value)
				local key
				if type(value) == "number" then
					key = "n:" .. tostring(value)
				elseif type(value) == "string" then
					key = "s:" .. value
				elseif type(value) == "boolean" then
					key = "b:" .. tostring(value)
				else
					key = "nil"
				end
				if proto.constMap[key] then
					return proto.constMap[key] - 1
				end
				local idx = #proto.consts + 1
				proto.consts[idx] = value
				proto.constMap[key] = idx
				return idx - 1
			end
			function BC:emit(proto, op, a, b, c)
				a = a or 0
				b = b or 0
				c = c or 0
				proto.instrs[#proto.instrs + 1] = { op, a, b, c }
				if a > proto.maxRegSeen then
					proto.maxRegSeen = a
				end
				return #proto.instrs
			end
			function BC:emitJmp(proto, op, a)
				return self:emit(proto, op, a or 0, 0xFFFF, 0)
			end
			function BC:patchJmp(proto, instrIdx, target)
				proto.instrs[instrIdx][3] = target
			end
			function BC:allocReg(proto)
				local r = proto.regNext
				proto.regNext = proto.regNext + 1
				if proto.regNext > proto.maxRegSeen then
					proto.maxRegSeen = proto.regNext
				end
				return r
			end
			function BC:freeReg(proto, r)
				if r == proto.regNext - 1 then
					proto.regNext = proto.regNext - 1
				end
			end
			function BC:markUpvalue(scope, id)
				if not self.upvalVars[scope] then
					self.upvalVars[scope] = {}
				end
				self.upvalVars[scope][id] = true
			end
			function BC:isUpvalue(scope, id)
				return self.upvalVars[scope] and self.upvalVars[scope][id]
			end
			function BC:compile(ast)
				self.upvalVars = {}
				self.scopeFuncDepths = {}
				local varAccessKinds = lookupify({
					AstKind.AssignmentVariable,
					AstKind.VariableExpression,
					AstKind.FunctionDeclaration,
					AstKind.LocalFunctionDeclaration,
				})
				visitast(ast, function(node, data)
					if node.kind == AstKind.Block then
						node.scope.__depth = data.functionData.depth
					end
					if varAccessKinds[node.kind] and not node.scope.isGlobal then
						if node.scope.__depth < data.functionData.depth then
							self:markUpvalue(node.scope, node.id)
						end
					end
				end, nil, nil)
				local proto = self:compileFunction(ast, nil, 0, true)
				proto.is_vararg = true
				proto.params = 0
				proto.max_reg = proto.maxRegSeen + 1
				return proto
			end
			function BC:compileFunction(node, parentProto, funcDepth, isTop)
				funcDepth = funcDepth or 0
				local args = isTop and {} or (node.args or {})
				local isVararg = false
				local paramCount = 0
				for _, arg in ipairs(args) do
					if arg.kind == AstKind.VarargExpression then
						isVararg = true
					else
						paramCount = paramCount + 1
					end
				end
				local proto = self:newProto(paramCount, isVararg)
				self.scopeFuncDepths[node] = funcDepth
				local regMap = {}
				local function getVarReg(scope, id)
					local key = tostring(scope) .. ":" .. tostring(id)
					if regMap[key] then
						return regMap[key]
					end
					local r = self:allocReg(proto)
					regMap[key] = r
					return r
				end
				for i, arg in ipairs(args) do
					if arg.kind ~= AstKind.VarargExpression then
						local key = tostring(arg.scope) .. ":" .. tostring(arg.id)
						regMap[key] = i - 1
					end
				end
				proto.regNext = paramCount
				local varargReg = nil
				if isVararg then
					varargReg = self:allocReg(proto)
					self:emit(proto, OP.VARARG, varargReg, 0, 0)
				end
				local envR = self:allocReg(proto)
				self:emit(proto, OP.GETGLOBAL, envR, self:addConst(proto, "_ENV"), 0)
				self:compileBlock(proto, isTop and node.body or node.body, funcDepth, getVarReg, varargReg, envR)
				self:emit(proto, OP.RETURN, 0, 1, 0)
				proto.max_reg = proto.maxRegSeen + 1
				return proto
			end
			function BC:compileBlock(proto, block, funcDepth, getVarReg, varargReg, envR)
				if not block or not block.statements then
					return
				end
				for _, stmt in ipairs(block.statements) do
					self:compileStmt(proto, stmt, funcDepth, getVarReg, varargReg, envR)
				end
			end
			function BC:compileStmt(proto, stmt, funcDepth, getVarReg, varargReg, envR)
				local k = stmt.kind
				if k == AstKind.LocalVariableDeclaration then
					local ids = stmt.ids or {}
					local exprs = stmt.expressions or {}
					for i, id in ipairs(ids) do
						local r = getVarReg(stmt.scope, id)
						if exprs[i] then
							local src = self:compileExpr(proto, exprs[i], funcDepth, getVarReg, varargReg, envR, 1)
							if src ~= r then
								self:emit(proto, OP.MOVE, r, src, 0)
							end
							self:freeReg(proto, src)
						else
							self:emit(proto, OP.LOADNIL, r, 0, 0)
						end
					end
					return
				end
				if k == AstKind.AssignmentStatement then
					local lhsList = stmt.lhs or {}
					local rhsList = stmt.rhs or stmt.values or {}
					local temps = {}
					for i, rhs in ipairs(lhsList) do
						local expr = rhsList[i]
						if expr then
							temps[i] = self:compileExpr(proto, expr, funcDepth, getVarReg, varargReg, envR, 1)
						end
					end
					for i, lhs in ipairs(lhsList) do
						local src = temps[i]
						if lhs.kind == AstKind.AssignmentVariable then
							if lhs.scope.isGlobal then
								local kIdx = self:addConst(proto, lhs.scope:getVariableName(lhs.id))
								local nameR = self:allocReg(proto)
								self:emit(proto, OP.LOADSTR, nameR, kIdx, 0)
								if not src then
									src = self:allocReg(proto)
									self:emit(proto, OP.LOADNIL, src, 0, 0)
								end
								self:emit(proto, OP.SETTABLE, envR, nameR, src)
								self:freeReg(proto, nameR)
							else
								local r = getVarReg(lhs.scope, lhs.id)
								if src then
									if src ~= r then
										self:emit(proto, OP.MOVE, r, src, 0)
									end
								else
									self:emit(proto, OP.LOADNIL, r, 0, 0)
								end
							end
						elseif lhs.kind == AstKind.AssignmentIndexing then
							local baseR = self:compileExpr(proto, lhs.base, funcDepth, getVarReg, varargReg, envR, 1)
							local idxR = self:compileExpr(proto, lhs.index, funcDepth, getVarReg, varargReg, envR, 1)
							if not src then
								src = self:allocReg(proto)
								self:emit(proto, OP.LOADNIL, src, 0, 0)
							end
							self:emit(proto, OP.SETTABLE, baseR, idxR, src)
							self:freeReg(proto, baseR)
							self:freeReg(proto, idxR)
						end
						if src then
							self:freeReg(proto, src)
						end
					end
					return
				end
				local COMPOUND_OP = {
					[AstKind.CompoundAddStatement] = OP.ADD,
					[AstKind.CompoundSubStatement] = OP.SUB,
					[AstKind.CompoundMulStatement] = OP.MUL,
					[AstKind.CompoundDivStatement] = OP.DIV,
					[AstKind.CompoundModStatement] = OP.MOD,
					[AstKind.CompoundPowStatement] = OP.POW,
					[AstKind.CompoundConcatStatement] = OP.CONCAT,
				}
				if COMPOUND_OP[k] then
					local op = COMPOUND_OP[k]
					local lhs = stmt.lhs
					local rhsR = self:compileExpr(proto, stmt.rhs, funcDepth, getVarReg, varargReg, envR, 1)
					if lhs.kind == AstKind.AssignmentIndexing then
						local baseR = self:compileExpr(proto, lhs.base, funcDepth, getVarReg, varargReg, envR, 1)
						local idxR = self:compileExpr(proto, lhs.index, funcDepth, getVarReg, varargReg, envR, 1)
						local curR = self:allocReg(proto)
						self:emit(proto, OP.GETTABLE, curR, baseR, idxR)
						local resR = self:allocReg(proto)
						self:emit(proto, op, resR, curR, rhsR)
						self:emit(proto, OP.SETTABLE, baseR, idxR, resR)
						self:freeReg(proto, resR)
						self:freeReg(proto, curR)
						self:freeReg(proto, baseR)
						self:freeReg(proto, idxR)
					else
						local r = getVarReg(lhs.scope, lhs.id)
						local resR = self:allocReg(proto)
						self:emit(proto, op, resR, r, rhsR)
						self:emit(proto, OP.MOVE, r, resR, 0)
						self:freeReg(proto, resR)
					end
					self:freeReg(proto, rhsR)
					return
				end
				if k == AstKind.LocalFunctionDeclaration then
					local r = getVarReg(stmt.scope, stmt.id)
					local fnR = self:compileFunctionNode(proto, stmt, funcDepth, getVarReg, varargReg, envR)
					if fnR ~= r then
						self:emit(proto, OP.MOVE, r, fnR, 0)
					end
					self:freeReg(proto, fnR)
					return
				end
				if k == AstKind.FunctionDeclaration then
					local fnR = self:compileFunctionNode(proto, stmt, funcDepth, getVarReg, varargReg, envR)
					if stmt.scope and stmt.scope.isGlobal then
						local kIdx = self:addConst(proto, stmt.scope:getVariableName(stmt.id))
						local nameR = self:allocReg(proto)
						self:emit(proto, OP.LOADSTR, nameR, kIdx, 0)
						self:emit(proto, OP.SETTABLE, envR, nameR, fnR)
						self:freeReg(proto, nameR)
					end
					self:freeReg(proto, fnR)
					return
				end
				if k == AstKind.ReturnStatement then
					local vals = stmt.values or {}
					if #vals == 0 then
						self:emit(proto, OP.RETURN, 0, 1, 0)
					elseif #vals == 1 then
						local r = self:compileExpr(proto, vals[1], funcDepth, getVarReg, varargReg, envR, 1)
						self:emit(proto, OP.RETURN, r, 2, 0)
						self:freeReg(proto, r)
					else
						local base = proto.regNext
						for i, v in ipairs(vals) do
							local r = self:compileExpr(proto, v, funcDepth, getVarReg, varargReg, envR, 1)
							if r ~= base + i - 1 then
								local slot = base + i - 1
								if slot >= proto.regNext then
									proto.regNext = slot + 1
								end
								self:emit(proto, OP.MOVE, slot, r, 0)
								self:freeReg(proto, r)
							end
						end
						self:emit(proto, OP.RETURN, base, #vals + 1, 0)
						proto.regNext = base
					end
					return
				end
				if k == AstKind.DoStatement then
					self:compileBlock(proto, stmt.body, funcDepth, getVarReg, varargReg, envR)
					return
				end
				if k == AstKind.WhileStatement then
					local loopTop = #proto.instrs + 1
					local condR = self:compileExpr(proto, stmt.condition, funcDepth, getVarReg, varargReg, envR, 1)
					local exitJmp = self:emitJmp(proto, OP.JMPF, condR)
					self:freeReg(proto, condR)
					stmt.__bc_loopTop = loopTop
					stmt.__bc_exitJmps = { exitJmp }
					stmt.__bc_contJmps = {}
					self:compileBlock(proto, stmt.body, funcDepth, getVarReg, varargReg, envR)
					self:emit(proto, OP.JMP, 0, loopTop, 0)
					local afterLoop = #proto.instrs + 1
					for _, j in ipairs(stmt.__bc_exitJmps) do
						self:patchJmp(proto, j, afterLoop)
					end
					return
				end
				if k == AstKind.RepeatStatement then
					local loopTop = #proto.instrs + 1
					stmt.__bc_loopTop = loopTop
					stmt.__bc_exitJmps = {}
					stmt.__bc_contJmps = {}
					self:compileBlock(proto, stmt.body, funcDepth, getVarReg, varargReg, envR)
					local condR = self:compileExpr(proto, stmt.condition, funcDepth, getVarReg, varargReg, envR, 1)
					local exitJmp = self:emitJmp(proto, OP.JMPT, condR)
					self:freeReg(proto, condR)
					self:emit(proto, OP.JMP, 0, loopTop, 0)
					local afterLoop = #proto.instrs + 1
					table.insert(stmt.__bc_exitJmps, exitJmp)
					for _, j in ipairs(stmt.__bc_exitJmps) do
						self:patchJmp(proto, j, afterLoop)
					end
					return
				end
				if k == AstKind.ForStatement then
					local startR = self:compileExpr(proto, stmt.start, funcDepth, getVarReg, varargReg, envR, 1)
					local stopR = self:compileExpr(proto, stmt.stop, funcDepth, getVarReg, varargReg, envR, 1)
					local stepR
					if stmt.step then
						stepR = self:compileExpr(proto, stmt.step, funcDepth, getVarReg, varargReg, envR, 1)
					else
						stepR = self:allocReg(proto)
						self:emit(proto, OP.LOADINT, stepR, 0, 1)
					end
					local iR = getVarReg(stmt.scope, stmt.id)
					self:emit(proto, OP.MOVE, iR, startR, 0)
					self:freeReg(proto, startR)
					local loopTop = #proto.instrs + 1
					local cmpR = self:allocReg(proto)
					self:emit(proto, OP.LE, cmpR, iR, stopR)
					local exitJmp = self:emitJmp(proto, OP.JMPF, cmpR)
					self:freeReg(proto, cmpR)
					stmt.__bc_loopTop = loopTop
					stmt.__bc_exitJmps = { exitJmp }
					stmt.__bc_contJmps = {}
					self:compileBlock(proto, stmt.body, funcDepth, getVarReg, varargReg, envR)
					local newIR = self:allocReg(proto)
					self:emit(proto, OP.ADD, newIR, iR, stepR)
					self:emit(proto, OP.MOVE, iR, newIR, 0)
					self:freeReg(proto, newIR)
					self:emit(proto, OP.JMP, 0, loopTop, 0)
					local afterLoop = #proto.instrs + 1
					for _, j in ipairs(stmt.__bc_exitJmps) do
						self:patchJmp(proto, j, afterLoop)
					end
					self:freeReg(proto, stopR)
					self:freeReg(proto, stepR)
					return
				end
				if k == AstKind.ForInStatement then
					local exprs = stmt.expressions or {}
					local CALL_KINDS =
						{ [AstKind.FunctionCallExpression] = true, [AstKind.PassSelfFunctionCallExpression] = true }
					if #exprs == 1 and not CALL_KINDS[exprs[1].kind] and exprs[1].kind ~= AstKind.VarargExpression then
						local nextKIdx = self:addConst(proto, "next")
						local nextR = self:allocReg(proto)
						self:emit(proto, OP.LOADSTR, nextR, nextKIdx, 0)
						local tblR = self:compileExpr(proto, exprs[1], funcDepth, getVarReg, varargReg, envR, 1)
						local nilR = self:allocReg(proto)
						self:emit(proto, OP.LOADNIL, nilR, 0, 0)
						local iterR = self:allocReg(proto)
						self:emit(proto, OP.GETTABLE, iterR, envR, nextR)
						self:freeReg(proto, nextR)
						local stateR = tblR
						local ctrlR = nilR
						local ids = stmt.ids or {}
						local loopTop = #proto.instrs + 1
						local callBase = proto.regNext
						proto.regNext = callBase + 1
						if iterR ~= callBase then
							self:emit(proto, OP.MOVE, callBase, iterR, 0)
						end
						self:emit(proto, OP.MOVE, callBase + 1, stateR, 0)
						self:emit(proto, OP.MOVE, callBase + 2, ctrlR, 0)
						proto.regNext = callBase + 3
						self:emit(proto, OP.CALL, callBase, 2, #ids)
						local firstVarR = callBase
						for i, id in ipairs(ids) do
							local vr = getVarReg(stmt.scope, id)
							if callBase + i - 1 ~= vr then
								self:emit(proto, OP.MOVE, vr, callBase + i - 1, 0)
							end
						end
						local nilChk = self:allocReg(proto)
						self:emit(proto, OP.EQ, nilChk, firstVarR, ctrlR)
						local exitJmp = self:emitJmp(proto, OP.JMPT, nilChk)
						self:freeReg(proto, nilChk)
						stmt.__bc_loopTop = loopTop
						stmt.__bc_exitJmps = { exitJmp }
						stmt.__bc_contJmps = {}
						self:compileBlock(proto, stmt.body, funcDepth, getVarReg, varargReg, envR)
						if #ids > 0 then
							local firstId = ids[1]
							local newCtrlR = getVarReg(stmt.scope, firstId)
							self:emit(proto, OP.MOVE, ctrlR, newCtrlR, 0)
						end
						self:emit(proto, OP.JMP, 0, loopTop, 0)
						local afterLoop = #proto.instrs + 1
						for _, j in ipairs(stmt.__bc_exitJmps) do
							self:patchJmp(proto, j, afterLoop)
						end
						self:freeReg(proto, iterR)
						self:freeReg(proto, nilR)
						return
					end
					local iterR = self:compileExpr(proto, exprs[1], funcDepth, getVarReg, varargReg, envR, 1)
					local stateR = exprs[2] and self:compileExpr(
						proto,
						exprs[2],
						funcDepth,
						getVarReg,
						varargReg,
						envR,
						1
					) or (function()
						local r = self:allocReg(proto)
						self:emit(proto, OP.LOADNIL, r, 0, 0)
						return r
					end)()
					local ctrlR = exprs[3] and self:compileExpr(
						proto,
						exprs[3],
						funcDepth,
						getVarReg,
						varargReg,
						envR,
						1
					) or (function()
						local r = self:allocReg(proto)
						self:emit(proto, OP.LOADNIL, r, 0, 0)
						return r
					end)()
					local ids = stmt.ids or {}
					local loopTop = #proto.instrs + 1
					local callBase = proto.regNext
					proto.regNext = callBase + 1
					if iterR ~= callBase then
						self:emit(proto, OP.MOVE, callBase, iterR, 0)
					end
					self:emit(proto, OP.MOVE, callBase + 1, stateR, 0)
					self:emit(proto, OP.MOVE, callBase + 2, ctrlR, 0)
					proto.regNext = callBase + 3
					self:emit(proto, OP.CALL, callBase, 2, #ids)
					local firstVarR = callBase
					for i, id in ipairs(ids) do
						local vr = getVarReg(stmt.scope, id)
						if callBase + i - 1 ~= vr then
							self:emit(proto, OP.MOVE, vr, callBase + i - 1, 0)
						end
					end
					local nilR = self:allocReg(proto)
					self:emit(proto, OP.LOADNIL, nilR, 0, 0)
					local nilChk = self:allocReg(proto)
					self:emit(proto, OP.EQ, nilChk, firstVarR, nilR)
					local exitJmp = self:emitJmp(proto, OP.JMPT, nilChk)
					self:freeReg(proto, nilChk)
					self:freeReg(proto, nilR)
					stmt.__bc_loopTop = loopTop
					stmt.__bc_exitJmps = { exitJmp }
					stmt.__bc_contJmps = {}
					self:compileBlock(proto, stmt.body, funcDepth, getVarReg, varargReg, envR)
					if #ids > 0 then
						local newCtrlR = getVarReg(stmt.scope, ids[1])
						self:emit(proto, OP.MOVE, ctrlR, newCtrlR, 0)
					end
					self:emit(proto, OP.JMP, 0, loopTop, 0)
					local afterLoop = #proto.instrs + 1
					for _, j in ipairs(stmt.__bc_exitJmps) do
						self:patchJmp(proto, j, afterLoop)
					end
					self:freeReg(proto, iterR)
					self:freeReg(proto, stateR)
					self:freeReg(proto, ctrlR)
					return
				end
				if k == AstKind.IfStatement then
					local condR = self:compileExpr(proto, stmt.condition, funcDepth, getVarReg, varargReg, envR, 1)
					local falseJmp = self:emitJmp(proto, OP.JMPF, condR)
					self:freeReg(proto, condR)
					self:compileBlock(proto, stmt.body, funcDepth, getVarReg, varargReg, envR)
					local exitJmps = {}
					local elseifs = stmt.elseifs or {}
					if #elseifs > 0 or stmt.elseBody then
						local skipJmp = self:emitJmp(proto, OP.JMP, 0)
						table.insert(exitJmps, skipJmp)
					end
					local afterCond = #proto.instrs + 1
					self:patchJmp(proto, falseJmp, afterCond)
					for _, ei in ipairs(elseifs) do
						local eiCondR = self:compileExpr(proto, ei.condition, funcDepth, getVarReg, varargReg, envR, 1)
						local eiFalseJmp = self:emitJmp(proto, OP.JMPF, eiCondR)
						self:freeReg(proto, eiCondR)
						self:compileBlock(proto, ei.body, funcDepth, getVarReg, varargReg, envR)
						local eiSkip = self:emitJmp(proto, OP.JMP, 0)
						table.insert(exitJmps, eiSkip)
						self:patchJmp(proto, eiFalseJmp, #proto.instrs + 1)
					end
					if stmt.elseBody then
						self:compileBlock(proto, stmt.elseBody, funcDepth, getVarReg, varargReg, envR)
					end
					local afterIf = #proto.instrs + 1
					for _, j in ipairs(exitJmps) do
						self:patchJmp(proto, j, afterIf)
					end
					return
				end
				if k == AstKind.BreakStatement then
					local loop = stmt.loop
					if loop and loop.__bc_exitJmps then
						local j = self:emitJmp(proto, OP.JMP, 0)
						table.insert(loop.__bc_exitJmps, j)
					end
					return
				end
				if k == AstKind.ContinueStatement then
					local loop = stmt.loop
					if loop and loop.__bc_contJmps then
						local j = self:emitJmp(proto, OP.JMP, 0)
						table.insert(loop.__bc_contJmps, j)
					end
					return
				end
				if k == AstKind.FunctionCallStatement then
					self:emitCall(proto, stmt.base, stmt.args, funcDepth, getVarReg, varargReg, envR, false, 0)
					return
				end
				if k == AstKind.PassSelfFunctionCallStatement then
					self:emitPassSelfCall(
						proto,
						stmt.base,
						stmt.passSelfFunctionName,
						stmt.args,
						funcDepth,
						getVarReg,
						varargReg,
						envR,
						false,
						0
					)
					return
				end
				if k == AstKind.FunctionCallExpression or k == AstKind.PassSelfFunctionCallExpression then
					self:compileExpr(proto, stmt, funcDepth, getVarReg, varargReg, envR, 0)
					return
				end
			end
			function BC:compileExpr(proto, expr, funcDepth, getVarReg, varargReg, envR, numReturns)
				local k = expr.kind
				numReturns = numReturns or 1
				if k == AstKind.NilExpression then
					local r = self:allocReg(proto)
					self:emit(proto, OP.LOADNIL, r, 0, 0)
					return r
				end
				if k == AstKind.BooleanExpression then
					local r = self:allocReg(proto)
					self:emit(proto, OP.LOADBOOL, r, expr.value and 1 or 0, 0)
					return r
				end
				if k == AstKind.NumberExpression then
					local v = expr.value
					if v == math.floor(v) and v >= -2147483648 and v <= 2147483647 then
						local r = self:allocReg(proto)
						local hi = math.floor(v / 65536) % 65536
						local lo = v % 65536
						self:emit(proto, OP.LOADINT, r, hi, lo)
						return r
					else
						local kIdx = self:addConst(proto, v)
						local r = self:allocReg(proto)
						self:emit(proto, OP.LOADFLOAT, r, kIdx, 0)
						return r
					end
				end
				if k == AstKind.StringExpression then
					local kIdx = self:addConst(proto, expr.value)
					local r = self:allocReg(proto)
					self:emit(proto, OP.LOADSTR, r, kIdx, 0)
					return r
				end
				if k == AstKind.VariableExpression then
					if expr.scope.isGlobal then
						local name = expr.scope:getVariableName(expr.id)
						local kIdx = self:addConst(proto, name)
						local nameR = self:allocReg(proto)
						self:emit(proto, OP.LOADSTR, nameR, kIdx, 0)
						local r = self:allocReg(proto)
						self:emit(proto, OP.GETTABLE, r, envR, nameR)
						self:freeReg(proto, nameR)
						return r
					else
						return getVarReg(expr.scope, expr.id)
					end
				end
				if k == AstKind.VarargExpression then
					if varargReg then
						return varargReg
					end
					local r = self:allocReg(proto)
					self:emit(proto, OP.LOADNIL, r, 0, 0)
					return r
				end
				if BIN_OP_MAP[k] then
					local lR = self:compileExpr(proto, expr.lhs, funcDepth, getVarReg, varargReg, envR, 1)
					local rR = self:compileExpr(proto, expr.rhs, funcDepth, getVarReg, varargReg, envR, 1)
					local dstR = self:allocReg(proto)
					self:emit(proto, BIN_OP_MAP[k], dstR, lR, rR)
					self:freeReg(proto, lR)
					self:freeReg(proto, rR)
					return dstR
				end
				if k == AstKind.NotExpression then
					local vR = self:compileExpr(proto, expr.value, funcDepth, getVarReg, varargReg, envR, 1)
					local dstR = self:allocReg(proto)
					self:emit(proto, OP.NOT, dstR, vR, 0)
					self:freeReg(proto, vR)
					return dstR
				end
				if k == AstKind.NegateExpression or k == AstKind.UnOpExpression then
					local vR = self:compileExpr(proto, expr.value, funcDepth, getVarReg, varargReg, envR, 1)
					local dstR = self:allocReg(proto)
					self:emit(proto, OP.UNM, dstR, vR, 0)
					self:freeReg(proto, vR)
					return dstR
				end
				if k == AstKind.LenExpression then
					local vR = self:compileExpr(proto, expr.value, funcDepth, getVarReg, varargReg, envR, 1)
					local dstR = self:allocReg(proto)
					self:emit(proto, OP.LEN, dstR, vR, 0)
					self:freeReg(proto, vR)
					return dstR
				end
				if k == AstKind.AndExpression then
					local lR = self:compileExpr(proto, expr.lhs, funcDepth, getVarReg, varargReg, envR, 1)
					local falseJmp = self:emitJmp(proto, OP.JMPF, lR)
					self:freeReg(proto, lR)
					local rR = self:compileExpr(proto, expr.rhs, funcDepth, getVarReg, varargReg, envR, 1)
					local dstR = self:allocReg(proto)
					self:emit(proto, OP.MOVE, dstR, rR, 0)
					self:freeReg(proto, rR)
					local skipJmp = self:emitJmp(proto, OP.JMP, 0)
					self:patchJmp(proto, falseJmp, #proto.instrs + 1)
					self:emit(proto, OP.LOADBOOL, dstR, 0, 0)
					self:patchJmp(proto, skipJmp, #proto.instrs + 1)
					return dstR
				end
				if k == AstKind.OrExpression then
					local lR = self:compileExpr(proto, expr.lhs, funcDepth, getVarReg, varargReg, envR, 1)
					local dstR = self:allocReg(proto)
					self:emit(proto, OP.MOVE, dstR, lR, 0)
					self:freeReg(proto, lR)
					local trueJmp = self:emitJmp(proto, OP.JMPT, dstR)
					local rR = self:compileExpr(proto, expr.rhs, funcDepth, getVarReg, varargReg, envR, 1)
					self:emit(proto, OP.MOVE, dstR, rR, 0)
					self:freeReg(proto, rR)
					self:patchJmp(proto, trueJmp, #proto.instrs + 1)
					return dstR
				end
				if k == AstKind.IndexExpression then
					local baseR = self:compileExpr(proto, expr.base, funcDepth, getVarReg, varargReg, envR, 1)
					local idxR = self:compileExpr(proto, expr.index, funcDepth, getVarReg, varargReg, envR, 1)
					local dstR = self:allocReg(proto)
					self:emit(proto, OP.GETTABLE, dstR, baseR, idxR)
					self:freeReg(proto, baseR)
					self:freeReg(proto, idxR)
					return dstR
				end
				if k == AstKind.TableConstructorExpression then
					local tR = self:allocReg(proto)
					self:emit(proto, OP.NEWTABLE, tR, 0, 0)
					local arrIdx = 0
					for _, entry in ipairs(expr.entries or {}) do
						if entry.kind == AstKind.TableEntry then
							local vR = self:compileExpr(proto, entry.value, funcDepth, getVarReg, varargReg, envR, 1)
							arrIdx = arrIdx + 1
							local kIdx = self:addConst(proto, arrIdx)
							local kR = self:allocReg(proto)
							self:emit(proto, OP.LOADINT, kR, 0, arrIdx)
							self:emit(proto, OP.SETTABLE, tR, kR, vR)
							self:freeReg(proto, kR)
							self:freeReg(proto, vR)
						else
							local keyR = self:compileExpr(proto, entry.key, funcDepth, getVarReg, varargReg, envR, 1)
							local valR = self:compileExpr(proto, entry.value, funcDepth, getVarReg, varargReg, envR, 1)
							self:emit(proto, OP.SETTABLE, tR, keyR, valR)
							self:freeReg(proto, keyR)
							self:freeReg(proto, valR)
						end
					end
					return tR
				end
				if k == AstKind.FunctionLiteralExpression then
					return self:compileFunctionNode(proto, expr, funcDepth, getVarReg, varargReg, envR)
				end
				if k == AstKind.FunctionCallExpression then
					if numReturns == 0 then
						self:emitCall(proto, expr.base, expr.args, funcDepth, getVarReg, varargReg, envR, false, 1)
						return nil
					end
					return self:emitCall(
						proto,
						expr.base,
						expr.args,
						funcDepth,
						getVarReg,
						varargReg,
						envR,
						true,
						numReturns
					)
				end
				if k == AstKind.PassSelfFunctionCallExpression then
					if numReturns == 0 then
						self:emitPassSelfCall(
							proto,
							expr.base,
							expr.method,
							expr.args,
							funcDepth,
							getVarReg,
							varargReg,
							envR,
							false,
							1
						)
						return nil
					end
					return self:emitPassSelfCall(
						proto,
						expr.base,
						expr.method,
						expr.args,
						funcDepth,
						getVarReg,
						varargReg,
						envR,
						true,
						numReturns
					)
				end
				local r = self:allocReg(proto)
				self:emit(proto, OP.LOADNIL, r, 0, 0)
				return r
			end
			function BC:emitCall(proto, baseExpr, args, funcDepth, getVarReg, varargReg, envR, wantResult, numReturns)
				local callBase = proto.regNext
				proto.regNext = callBase + 1
				local fnR = self:compileExpr(proto, baseExpr, funcDepth, getVarReg, varargReg, envR, 1)
				if fnR ~= callBase then
					self:emit(proto, OP.MOVE, callBase, fnR, 0)
					self:freeReg(proto, fnR)
				end
				local nArgs = 0
				local isVarargLast = false
				for i, arg in ipairs(args or {}) do
					local slot = callBase + 1 + nArgs
					if slot >= proto.regNext then
						proto.regNext = slot + 1
					end
					local isLast = (i == #args)
					if
						isLast
						and (
							arg.kind == AstKind.FunctionCallExpression
							or arg.kind == AstKind.PassSelfFunctionCallExpression
							or arg.kind == AstKind.VarargExpression
						)
					then
						local r = self:compileExpr(proto, arg, funcDepth, getVarReg, varargReg, envR, self.RETURN_ALL)
						if r and r ~= slot then
							self:emit(proto, OP.MOVE, slot, r, 0)
						end
						nArgs = nArgs + 1
						isVarargLast = true
					else
						local r = self:compileExpr(proto, arg, funcDepth, getVarReg, varargReg, envR, 1)
						if r and r ~= slot then
							self:emit(proto, OP.MOVE, slot, r, 0)
						end
						nArgs = nArgs + 1
					end
				end
				proto.regNext = callBase + 1 + nArgs
				local emitNArgs = isVarargLast and 0 or nArgs
				if not wantResult then
					self:emit(proto, OP.VCALL, callBase, emitNArgs, 0)
					proto.regNext = callBase
					return nil
				end
				if numReturns == self.RETURN_ALL then
					local tblR = self:allocReg(proto)
					self:emit(proto, OP.CALLM, callBase, emitNArgs, tblR)
					proto.regNext = callBase
					return tblR
				else
					self:emit(proto, OP.CALL, callBase, emitNArgs, numReturns)
					proto.regNext = callBase + (numReturns > 0 and numReturns or 1)
					return callBase
				end
			end
			function BC:emitPassSelfCall(
				proto,
				baseExpr,
				method,
				args,
				funcDepth,
				getVarReg,
				varargReg,
				envR,
				wantResult,
				numReturns
			)
				local callBase = proto.regNext
				proto.regNext = callBase + 1
				local selfR = self:compileExpr(proto, baseExpr, funcDepth, getVarReg, varargReg, envR, 1)
				local selfSlot = callBase + 1
				if selfSlot >= proto.regNext then
					proto.regNext = selfSlot + 1
				end
				if selfR ~= selfSlot then
					self:emit(proto, OP.MOVE, selfSlot, selfR, 0)
					self:freeReg(proto, selfR)
				end
				proto.regNext = callBase + 2
				local kIdx = self:addConst(proto, method)
				local methodR = self:allocReg(proto)
				self:emit(proto, OP.LOADSTR, methodR, kIdx, 0)
				self:emit(proto, OP.GETTABLE, callBase, selfSlot, methodR)
				self:freeReg(proto, methodR)
				proto.regNext = callBase + 2
				local nArgs = 1
				local isVarargLast = false
				for i, arg in ipairs(args or {}) do
					local slot = callBase + 1 + nArgs
					if slot >= proto.regNext then
						proto.regNext = slot + 1
					end
					local isLast = (i == #args)
					if
						isLast
						and (
							arg.kind == AstKind.FunctionCallExpression
							or arg.kind == AstKind.PassSelfFunctionCallExpression
							or arg.kind == AstKind.VarargExpression
						)
					then
						local r = self:compileExpr(proto, arg, funcDepth, getVarReg, varargReg, envR, self.RETURN_ALL)
						if r and r ~= slot then
							self:emit(proto, OP.MOVE, slot, r, 0)
						end
						nArgs = nArgs + 1
						isVarargLast = true
					else
						local r = self:compileExpr(proto, arg, funcDepth, getVarReg, varargReg, envR, 1)
						if r and r ~= slot then
							self:emit(proto, OP.MOVE, slot, r, 0)
						end
						nArgs = nArgs + 1
					end
				end
				proto.regNext = callBase + 1 + nArgs
				local emitNArgs = isVarargLast and 0 or nArgs
				if not wantResult then
					self:emit(proto, OP.VCALL, callBase, emitNArgs, 0)
					proto.regNext = callBase
					return nil
				end
				if numReturns == self.RETURN_ALL then
					local tblR = self:allocReg(proto)
					self:emit(proto, OP.CALLM, callBase, emitNArgs, tblR)
					proto.regNext = callBase
					return tblR
				else
					self:emit(proto, OP.CALL, callBase, emitNArgs, numReturns)
					proto.regNext = callBase + (numReturns > 0 and numReturns or 1)
					return callBase
				end
			end
			function BC:compileFunctionNode(parentProto, node, funcDepth, parentGetVarReg, varargReg, envR)
				local args = node.args or {}
				local isVararg = false
				local paramCount = 0
				for _, arg in ipairs(args) do
					if arg.kind == AstKind.VarargExpression then
						isVararg = true
					else
						paramCount = paramCount + 1
					end
				end
				local subProto = self:newProto(paramCount, isVararg)
				local subRegMap = {}
				local captureList = {}
				local captureKeys = {}
				local function safeParentGet(scope, id)
					if not parentGetVarReg then
						return nil
					end
					return parentGetVarReg(scope, id)
				end
				local function subGetVarReg(scope, id)
					local key = tostring(scope) .. ":" .. tostring(id)
					if subRegMap[key] then
						return subRegMap[key]
					end
					local parentReg = safeParentGet(scope, id)
					if parentReg ~= nil then
						local slot = #captureList + 1
						captureList[slot] = parentReg
						captureKeys[key] = slot
						subRegMap[key] = slot
						subRegMap[key .. "__cap"] = slot
						return slot
					end
					local r = self:allocReg(subProto)
					subRegMap[key] = r
					return r
				end
				for i, arg in ipairs(args) do
					if arg.kind ~= AstKind.VarargExpression then
						subRegMap[tostring(arg.scope) .. ":" .. tostring(arg.id)] = i - 1
					end
				end
				subProto.regNext = paramCount
				local subVarargReg = nil
				if isVararg then
					subVarargReg = self:allocReg(subProto)
					self:emit(subProto, OP.VARARG, subVarargReg, 0, 0)
				end
				local subEnvR = self:allocReg(subProto)
				self:emit(subProto, OP.GETGLOBAL, subEnvR, self:addConst(subProto, "_ENV"), 0)
				self:compileBlock(subProto, node.body, funcDepth + 1, subGetVarReg, subVarargReg, subEnvR)
				self:emit(subProto, OP.RETURN, 0, 1, 0)
				subProto.max_reg = subProto.maxRegSeen + 1
				subProto.nCaptures = #captureList
				local protoIdx = #parentProto.protos
				parentProto.protos[protoIdx + 1] = subProto
				local dstR = self:allocReg(parentProto)
				self:emit(parentProto, OP.CLOSURE, dstR, protoIdx, #captureList)
				for _, pReg in ipairs(captureList) do
					self:emit(parentProto, OP.MOVE, 0, pReg, 0)
				end
				return dstR
			end
			return {
				new = function()
					return BC:new()
				end,
				BC = BC,
			}
		end
		function _ZukOfficial.R()
			local v = _ZukOfficial.cache.R
			if not v then
				v = { c = __modImpl() }
				_ZukOfficial.cache.R = v
			end
			return v.c
		end
	end
	do
		local function __modImpl()
			local Step = _ZukOfficial.n()
			local Parser = _ZukOfficial.j()
			local Enums = _ZukOfficial.g()
			local ISA = _ZukOfficial.Q()
			local BCFactory = _ZukOfficial.R()
			local logger = _ZukOfficial.d()
			local LuaVersion = Enums.LuaVersion
			local OP = ISA.OP
			local VmifyBC = Step:extend()
			VmifyBC.Description =
				"Compiles script to a custom ZukaTech bytecode blob + inline VM (custom ISA, per-compile opcode shuffle)."
			VmifyBC.Name = "VmifyBC"
			VmifyBC.SettingsDescriptor = {
				XorKey = {
					name = "XorKey",
					type = "number",
					default = 0,
					min = 0,
					max = 254,
					description = "Bytecode XOR key 1-254 (0=random per compile)",
				},
				ShuffleOpcodes = {
					name = "ShuffleOpcodes",
					type = "boolean",
					default = true,
					description = "Randomly permute opcode wire values each compilation",
				},
			}
			function VmifyBC:init(settings) end
			local C36 = "0123456789abcdefghijklmnopqrstuvwxyz"
			local function b36(n)
				if n == 0 then
					return "0"
				end
				local s = ""
				while n > 0 do
					s = C36:sub(n % 36 + 1, n % 36 + 1) .. s
					n = math.floor(n / 36)
				end
				return s
			end
			local function eCode(n)
				local s = b36(n)
				return b36(#s) .. s
			end
			local function lzw(inp)
				local d, ds = {}, 256
				for i = 0, 255 do
					d[string.char(i)] = i
				end
				local w, o = "", {}
				for i = 1, #inp do
					local c = inp:sub(i, i)
					local wc = w .. c
					if d[wc] then
						w = wc
					else
						o[#o + 1] = eCode(d[w])
						d[wc] = ds
						ds = ds + 1
						w = c
					end
				end
				if w ~= "" then
					o[#o + 1] = eCode(d[w])
				end
				return table.concat(o)
			end
			local function bx(a, b)
				local r, m = 0, 1
				while a > 0 or b > 0 do
					local ra, rb = a % 2, b % 2
					if ra ~= rb then
						r = r + m
					end
					a = math.floor(a / 2)
					b = math.floor(b / 2)
					m = m * 2
				end
				return r
			end
			local function xorB(s, k)
				local t = {}
				for i = 1, #s do
					t[i] = string.char(bx(s:byte(i), k) % 256)
				end
				return table.concat(t)
			end
			local function longStr(s)
				local lv = 0
				while s:find("]" .. string.rep("=", lv) .. "]", 1, true) do
					lv = lv + 1
				end
				local eq = string.rep("=", lv)
				return "[" .. eq .. "[" .. s .. "]" .. eq .. "]"
			end
			local function buildVM(xorSeed, decodeMap)
				local dmParts = {}
				for wire, canon in pairs(decodeMap) do
					dmParts[#dmParts + 1] = "[" .. wire .. "]=" .. canon
				end
				local dmLit = "{" .. table.concat(dmParts, ",") .. "}"
				local function op(name)
					return tostring(OP[name])
				end
				local L = {}
				local function ln(s)
					L[#L + 1] = s
				end
				ln("local _sb=string.byte")
				ln("local _ss=string.sub")
				ln("local _fl=math.floor")
				ln("local _up=unpack or table.unpack")
				ln("local _XS=" .. tostring(xorSeed))
				ln("local _DM=" .. dmLit)
				ln("local function _bx(a,b)")
				ln("    local r,m=0,1")
				ln("    while a>0 or b>0 do")
				ln("        local ra,rb=a%2,b%2")
				ln("        if ra~=rb then r=r+m end")
				ln("        a=_fl(a/2);b=_fl(b/2);m=m*2")
				ln("    end")
				ln("    return r%256")
				ln("end")
				ln("local function _mkS(seed)")
				ln("    local s=seed%4294967296")
				ln("    return function()")
				ln("        s=(s*1664525+1013904223)%4294967296")
				ln("        return s%256")
				ln("    end")
				ln("end")
				ln("local function _pSeed(depth)")
				ln("    local lo=_bx(_XS%256,(_fl(depth*0x9E))%256)")
				ln("    return (lo+_fl(_XS/256)*256)%4294967296")
				ln("end")
				ln("local _ds")
				ln("_ds=function(blob)")
				ln("    local pos=1")
				ln("    local function rb() local v=_sb(blob,pos);pos=pos+1;return v end")
				ln("    local function r2() return rb()*256+rb() end")
				ln("    local function rC()")
				ln("        local t=rb()")
				ln("        if t==0 then return nil")
				ln("        elseif t==1 then return rb()~=0")
				ln("        elseif t==2 then")
				ln("            local a,b,c,d=rb(),rb(),rb(),rb()")
				ln("            local v=a*16777216+b*65536+c*256+d")
				ln("            if v>=2147483648 then v=v-4294967296 end")
				ln("            return v")
				ln("        elseif t==3 then")
				ln("            local bs={}")
				ln("            for _=1,8 do bs[#bs+1]=rb() end")
				ln("            local lo=bs[1]+bs[2]*256+bs[3]*65536+bs[4]*16777216")
				ln("            local hi=bs[5]+bs[6]*256+bs[7]*65536+bs[8]*16777216")
				ln("            if lo==0 and hi==0 then return 0 end")
				ln("            local sg=_fl(hi/2147483648)")
				ln("            local ex=_fl(hi/1048576)%2048")
				ln("            local mh=hi%1048576")
				ln("            return((-1)^sg)*(2^(ex-1023))*((mh*4294967296+lo)/(2^52)+1)")
				ln("        elseif t==4 then")
				ln("            local ln2=r2()")
				ln("            local sv=_ss(blob,pos,pos+ln2-1);pos=pos+ln2;return sv")
				ln("        end")
				ln("    end")
				ln("    local function rP(depth)")
				ln("        local p={pa=rb(),va=rb()~=0,mr=rb(),K={},I={},P={}}")
				ln("        local nc=r2();for i=1,nc do p.K[i]=rC() end")
				ln("        local ni=r2()")
				ln("        local st=_mkS(_pSeed(depth))")
				ln("        for i=1,ni do")
				ln("            local s1,s2,s3,s4,s5,s6=st(),st(),st(),st(),st(),st()")
				ln("            local b1=_bx(_sb(blob,pos),  s1)")
				ln("            local b2=_bx(_sb(blob,pos+1),s2)")
				ln("            local b3=_bx(_sb(blob,pos+2),s3)")
				ln("            local b4=_bx(_sb(blob,pos+3),s4)")
				ln("            local b5=_bx(_sb(blob,pos+4),s5)")
				ln("            local b6=_bx(_sb(blob,pos+5),s6)")
				ln("            pos=pos+6")
				ln("            p.I[i]={_DM[b1] or b1,b2,b3*256+b4,b5*256+b6}")
				ln("        end")
				ln("        local np=rb();for i=1,np do p.P[i]=rP(depth+1) end")
				ln("        return p")
				ln("    end")
				ln("    return rP(0)")
				ln("end")
				local handlers = {
					{ op("LOADNIL"), "Stk[A]=nil" },
					{ op("LOADBOOL"), "Stk[A]=(B~=0)" },
					{ op("LOADINT"), "local v=B*65536+C_", "if v>=2147483648 then v=v-4294967296 end", "Stk[A]=v" },
					{ op("LOADFLOAT"), "Stk[A]=K[B+1]" },
					{ op("LOADSTR"), "Stk[A]=K[B+1]" },
					{ op("MOVE"), "Stk[A]=Stk[B]" },
					{
						op("GETGLOBAL"),
						"local _gn=K[B+1]",
						"local _env=getfenv and getfenv(1) or _ENV",
						"Stk[A]=_env[_gn]",
					},
					{
						op("SETGLOBAL"),
						"local _gn=K[B+1]",
						"local _env=getfenv and getfenv(1) or _ENV",
						"_env[_gn]=Stk[A]",
					},
					{ op("GETTABLE"), "Stk[A]=Stk[B][Stk[C_]]" },
					{ op("SETTABLE"), "Stk[A][Stk[B]]=Stk[C_]" },
					{ op("NEWTABLE"), "Stk[A]={}" },
					{ op("ADD"), "Stk[A]=Stk[B]+Stk[C_]" },
					{ op("SUB"), "Stk[A]=Stk[B]-Stk[C_]" },
					{ op("MUL"), "Stk[A]=Stk[B]*Stk[C_]" },
					{ op("DIV"), "Stk[A]=Stk[B]/Stk[C_]" },
					{ op("MOD"), "Stk[A]=Stk[B]%Stk[C_]" },
					{ op("POW"), "Stk[A]=Stk[B]^Stk[C_]" },
					{ op("CONCAT"), "Stk[A]=Stk[B]..Stk[C_]" },
					{ op("LT"), "Stk[A]=(Stk[B]<Stk[C_])" },
					{ op("LE"), "Stk[A]=(Stk[B]<=Stk[C_])" },
					{ op("EQ"), "Stk[A]=(Stk[B]==Stk[C_])" },
					{ op("NE"), "Stk[A]=(Stk[B]~=Stk[C_])" },
					{ op("GT"), "Stk[A]=(Stk[B]>Stk[C_])" },
					{ op("GE"), "Stk[A]=(Stk[B]>=Stk[C_])" },
					{ op("NOT"), "Stk[A]=not Stk[B]" },
					{ op("UNM"), "Stk[A]=-Stk[B]" },
					{ op("LEN"), "Stk[A]=#Stk[B]" },
					{
						op("CALL"),
						"local _cb=A;local _na=B;local _nr=C_",
						"local _fn=Stk[_cb]",
						"local _a={}",
						"if _na==0 then for _i=_cb+1,#Stk do _a[#_a+1]=Stk[_i] end",
						"else for _i=1,_na do _a[_i]=Stk[_cb+_i] end end",
						"local _res={_fn(_up(_a,1,#_a))}",
						"for _i=1,_nr do Stk[_cb+_i-1]=_res[_i] end",
					},
					{
						op("CALLM"),
						"local _cb=A;local _na=B;local _tr=C_",
						"local _fn=Stk[_cb]",
						"local _a={}",
						"if _na==0 then for _i=_cb+1,#Stk do _a[#_a+1]=Stk[_i] end",
						"else for _i=1,_na do _a[_i]=Stk[_cb+_i] end end",
						"Stk[_tr]={_fn(_up(_a,1,#_a))}",
					},
					{
						op("VCALL"),
						"local _cb=A;local _na=B",
						"local _fn=Stk[_cb]",
						"local _a={}",
						"if _na==0 then for _i=_cb+1,#Stk do _a[#_a+1]=Stk[_i] end",
						"else for _i=1,_na do _a[_i]=Stk[_cb+_i] end end",
						"_fn(_up(_a,1,#_a))",
					},
					{ op("JMP"), "return B,nil,nil,nil,nil" },
					{ op("JMPT"), "if Stk[A] then return B,nil,nil,nil,nil end" },
					{ op("JMPF"), "if not Stk[A] then return B,nil,nil,nil,nil end" },
					{
						op("RETURN"),
						"if B<=1 then return nil,false,nil,false,nil end",
						"if B==2 then return nil,false,Stk[A],false,nil end",
						"local _rv={}",
						"for _i=0,B-2 do _rv[_i+1]=Stk[A+_i] end",
						"return nil,false,_rv,true,nil",
					},
					{ op("RETURNM"), "return nil,false,Stk[A],true,nil" },
					{
						op("VARARG"),
						"if B==0 then Stk[A]={_up(Varg,1,#Varg)}",
						"else for i=1,B-1 do Stk[A+i-1]=Varg[i] end end",
					},
					{ op("GET_UPVAL"), "Stk[A]=capSlots[B] and capSlots[B].v" },
					{ op("SET_UPVAL"), "local _sl=capSlots[A]", "if _sl then _sl.v=Stk[B] end" },
					{
						op("ALLOC_UPVAL"),
						"capC=capC+1",
						"capSlots[capC]={v=Stk[A]}",
						"Stk[A]=capC",
						"return nil,nil,nil,nil,capC",
					},
					{ op("FREE_UPVAL"), "" },
					{
						op("CLOSURE"),
						"local subP=P[B+1]",
						"local childCap={}",
						"local nPC=PC",
						"for _ci=1,C_ do",
						"    local capInst=I[nPC];nPC=nPC+1",
						"    local parentReg=capInst[3]",
						"    local parentVal=Stk[parentReg]",
						"    if type(parentVal)=='number' and capSlots[parentVal] then",
						"        childCap[_ci]=capSlots[parentVal]",
						"    else childCap[_ci]={v=parentVal} end",
						"end",
						"Stk[A]=_ex(subP,childCap,env)",
						"return nPC,nil,nil,nil,nil",
					},
				}
				for i = #handlers, 2, -1 do
					local j = math.random(1, i)
					handlers[i], handlers[j] = handlers[j], handlers[i]
				end
				local junkBodies = { { "Stk[A]=Stk[A]" }, { "local _z=B+C_" }, { "local _z=A*B" }, { "" } }
				for _ = 1, math.random(8, 20) do
					local fakeId = math.random(ISA.OP_COUNT, 254)
					local body = junkBodies[math.random(1, #junkBodies)]
					local h = { tostring(fakeId) }
					for _, bl in ipairs(body) do
						h[#h + 1] = bl
					end
					table.insert(handlers, math.random(1, #handlers + 1), h)
				end
				ln("local _ex")
				ln("local _DT={}")
				for _, h in ipairs(handlers) do
					local canonId = h[1]
					local bodyLines = {}
					for i = 2, #h do
						if h[i] ~= "" then
							bodyLines[#bodyLines + 1] = "    " .. h[i]
						end
					end
					if #bodyLines == 0 then
						ln("_DT[" .. canonId .. "]=function(Stk,K,I,P,A,B,C_,proto,PC,capSlots,capC,Varg,env) end")
					else
						ln("_DT[" .. canonId .. "]=function(Stk,K,I,P,A,B,C_,proto,PC,capSlots,capC,Varg,env)")
						for _, bl in ipairs(bodyLines) do
							ln(bl)
						end
						ln("end")
					end
				end
				ln("_ex=function(proto,capSlots,env)")
				ln("    local K=proto.K;local I=proto.I;local P=proto.P")
				ln("    if not capSlots then capSlots={} end")
				ln("    local capC=0")
				ln("    for k,_ in pairs(capSlots) do if k>capC then capC=k end end")
				ln("    return function(...)")
				ln("        local Stk={};local args={...}")
				ln("        for i=0,proto.pa-1 do Stk[i]=args[i+1] end")
				ln("        local Varg={}")
				ln("        if proto.va then")
				ln("            for i=proto.pa+1,#args do Varg[#Varg+1]=args[i] end")
				ln("        end")
				ln("        local PC=1;local running=true;local retVal=nil;local retMulti=false")
				ln("        while running do")
				ln("            local inst=I[PC]")
				ln("            if not inst then break end")
				ln("            local op_=inst[1];local A=inst[2];local B=inst[3];local C_=inst[4]")
				ln("            PC=PC+1")
				ln("            local _h=_DT[op_]")
				ln("            if _h then")
				ln("                local r1,r2,r3,r4,r5=_h(Stk,K,I,P,A,B,C_,proto,PC,capSlots,capC,Varg,env)")
				ln("                if r1~=nil then PC=r1 end")
				ln("                if r2~=nil then running=r2 end")
				ln("                if r3~=nil or r2==false then retVal=r3 end")
				ln("                if r4~=nil then retMulti=r4 end")
				ln("                if r5~=nil then capC=r5 end")
				ln("            end")
				ln("        end")
				ln("        if retMulti then")
				ln("            local _rn=#retVal;if _rn>200 then _rn=200 end")
				ln("            return _up(retVal,1,_rn)")
				ln("        elseif retVal~=nil then")
				ln("            return retVal")
				ln("        end")
				ln("    end")
				ln("end")
				return table.concat(L, "\n")
			end
			function VmifyBC:apply(ast, pipeline)
				math.randomseed(os.time())
				math.random()
				math.random()
				math.random()
				local bc = BCFactory.new()
				local ok, proto = pcall(function()
					return bc:compile(ast)
				end)
				if not ok then
					logger:warn("[VmifyBC] Compilation failed: " .. tostring(proto))
					logger:warn("[VmifyBC] Falling back — add a Vmify step instead")
					return ast
				end
				local xorSeed = (self.XorKey and self.XorKey > 0) and self.XorKey or math.random(0, 2147483647)
				local encodeMap, decodeMap
				if self.ShuffleOpcodes ~= false then
					local opSeed = (xorSeed * 2654435761) % 4294967296
					encodeMap, decodeMap = ISA.makeOpcodeMap(opSeed)
				else
					encodeMap, decodeMap = {}, {}
					for i = 0, ISA.OP_COUNT - 1 do
						encodeMap[i] = i
						decodeMap[i] = i
					end
				end
				local function encOp(c)
					return encodeMap[c] or c
				end
				local blob = ISA.serialiseProto(proto, xorSeed, encOp)
				local blobKey = math.random(1, 127)
				local rtSalt = math.random(1, 126)
				if rtSalt == blobKey then
					rtSalt = (rtSalt % 126) + 1
				end
				local encoded = xorB(xorB(blob, blobKey), rtSalt)
				local compressed = lzw(encoded)
				logger:info(
					string.format(
						"[VmifyBC] proto: %d instr, %d consts, %d sub-protos | blob %dB -> lzw %dB",
						#proto.instrs,
						#proto.consts,
						#proto.protos,
						#blob,
						#compressed
					)
				)
				local vmSrc = buildVM(xorSeed, decodeMap)
				local blobLit = longStr(compressed)
				local glue =
					table.concat({
						"local function _lzwD(b)",
						"    local c,d,e,f,g='','',{},256,{}",
						"    for h=0,255 do g[h]=string.char(h) end",
						"    local i=1",
						"    local function k()",
						"        local l=tonumber(string.sub(b,i,i),36);i=i+1",
						"        local m=tonumber(string.sub(b,i,i+l-1),36);i=i+l",
						"        return m",
						"    end",
						"    c=string.char(k());e[1]=c",
						"    while i<=#b do",
						"        local n=k()",
						"        if g[n] then d=g[n] else d=c..string.sub(c,1,1) end",
						"        g[f]=c..string.sub(d,1,1);e[#e+1],c,f=d,d,f+1",
						"    end",
						"    return table.concat(e)",
						"end",
						"local function _xdB(s,k)",
						"    local function _bx2(a,b)",
						"        local r,m=0,1",
						"        while a>0 or b>0 do",
						"            local ra,rb=a%2,b%2",
						"            if ra~=rb then r=r+m end",
						"            a=math.floor(a/2);b=math.floor(b/2);m=m*2",
						"        end",
						"        return r",
						"    end",
						"    local t={}",
						"    for i=1,#s do t[i]=string.char(_bx2(s:byte(i),k)%256) end",
						"    return table.concat(t)",
						"end",
						"local _blob=_xdB(_xdB(_lzwD(" .. blobLit .. ")," .. tostring(rtSalt) .. ")," .. tostring(
							blobKey
						) .. ")",
						"local _proto=_ds(_blob)",
						"local _env=getfenv and getfenv(1) or (function() return _ENV end)()",
						"local _fn=_ex(_proto,nil,_env)",
						"_fn(...)",
					}, "\n")
				local fullSrc = vmSrc .. "\n" .. glue
				local parser = Parser:new({ LuaVersion = LuaVersion.Lua51 })
				local ok2, newAst = pcall(function()
					return parser:parse(fullSrc)
				end)
				if not ok2 then
					logger:warn("[VmifyBC] Re-parse failed: " .. tostring(newAst))
					return ast
				end
				return newAst
			end
			return VmifyBC
		end
		function _ZukOfficial.S()
			local v = _ZukOfficial.cache.S
			if not v then
				v = { c = __modImpl() }
				_ZukOfficial.cache.S = v
			end
			return v.c
		end
	end
	do
		local function __modImpl()
			local Step = _ZukOfficial.n()
			local Ast = _ZukOfficial.b()
			local visitast = _ZukOfficial.q()
			local AstKind = Ast.AstKind
			local PolyStringEncode = Step:extend()
			PolyStringEncode.Name = "PolyStringEncode"
			PolyStringEncode.Description = "Encodes each string literal into a runtime string.char(a+k,b-k,...) "
				.. "arithmetic chain so no plaintext appears in the output."
			PolyStringEncode.SettingsDescriptor = {
				Threshold = {
					type = "number",
					default = 0.85,
					min = 0,
					max = 1,
				},
				MinLength = {
					type = "number",
					default = 2,
					min = 1,
					max = 1e9,
				},
			}
			function PolyStringEncode:init(settings) end
			local function encodeStringNode(globalScope, s)
				if #s == 0 then
					local _, charId = globalScope:resolve("string")
					return Ast.StringExpression(s)
				end
				local k1 = math.random(1, 127)
				local k2 = math.random(1, 127)
				local offset = (k1 + k2) % 256
				local charArgs = {}
				for i = 1, #s do
					local b = s:byte(i)
					local enc = (b + offset) % 256
					local inner = Ast.AddExpression(Ast.NumberExpression(enc), Ast.NumberExpression(256 - offset))
					local byteExpr = Ast.ModExpression(inner, Ast.NumberExpression(256))
					charArgs[i] = byteExpr
				end
				local _, stringId = globalScope:resolve("string")
				local _, charMethodId
				local stringExpr = Ast.VariableExpression(globalScope, stringId)
				local charKey = Ast.StringExpression("char")
				local charFnExpr = Ast.IndexExpression(stringExpr, charKey)
				return Ast.FunctionCallExpression(charFnExpr, charArgs)
			end
			function PolyStringEncode:apply(ast, pipeline)
				local thresh = self.Threshold or 0.85
				local minLen = self.MinLength or 2
				local globalScope = ast.globalScope
				if not globalScope then
					return ast
				end
				local ok, stringId = pcall(function()
					local _, id = globalScope:resolve("string")
					return id
				end)
				if not ok or not stringId then
					return ast
				end
				visitast(ast, nil, function(node, data)
					if node.kind == AstKind.StringExpression then
						local s = node.value or ""
						if #s >= minLen and math.random() <= thresh then
							local encoded = encodeStringNode(globalScope, s)
							if encoded then
								return encoded
							end
						end
					end
				end)
				return ast
			end
			return PolyStringEncode
		end
		function _ZukOfficial.T2()
			local v = _ZukOfficial.cache.T2
			if not v then
				v = { c = __modImpl() }
				_ZukOfficial.cache.T2 = v
			end
			return v.c
		end
	end
	do
		local function __modImpl()
			local Step = _ZukOfficial.n()
			local Ast = _ZukOfficial.b()
			local visitast = _ZukOfficial.q()
			local Scope = _ZukOfficial.i()
			local AstKind = Ast.AstKind
			local IdentifierSoup = Step:extend()
			IdentifierSoup.Name = "IdentifierSoup"
			IdentifierSoup.Description = "Renames every local variable to a visually-ambiguous homoglyph cluster "
				.. "(l/I/1/O/0/_ combos) so identifiers appear identical in most editors."
			IdentifierSoup.SettingsDescriptor = {
				Style = {
					type = "string",
					default = "mixed",
				},
				MinLength = {
					type = "number",
					default = 6,
					min = 4,
					max = 24,
				},
				MaxLength = {
					type = "number",
					default = 14,
					min = 4,
					max = 32,
				},
			}
			function IdentifierSoup:init(settings) end
			local CYR = {
				"Ð°",
				"Ðµ",
				"Ð¾",
				"Ñ",
				"Ñ",
				"Ñ",
				"Ñ",
				"Ñ",
				"Ð",
				"Ð",
				"Ð",
				"Ð",
				"Ð ",
				"Ð¡",
				"Ð",
				"Ð",
				"Ð",
				"Ð¢",
				"Ð¥",
			}
			local CYR_MIX = {
				"a",
				"Ð°",
				"e",
				"Ðµ",
				"o",
				"Ð¾",
				"c",
				"Ñ",
				"x",
				"Ñ",
				"p",
				"Ñ",
				"i",
				"Ñ",
				"y",
				"Ñ",
				"A",
				"Ð",
				"E",
				"Ð",
				"O",
				"Ð",
				"C",
				"Ð¡",
				"M",
				"Ð",
				"K",
				"Ð",
				"T",
				"Ð¢",
				"X",
				"Ð¥",
				"B",
				"Ð",
				"P",
				"Ð ",
			}
			local FAMILIES = {
				lI = { "l", "I", "1" },
				O0 = { "O", "0" },
				mixed = { "l", "I", "1", "O", "0" },
				cyrillic = CYR,
				cyrMixed = CYR_MIX,
			}
			local function makeNameGenerator(style, minLen, maxLen)
				local alpha = FAMILIES[style] or FAMILIES.mixed
				local used = {}
				return function()
					local name
					local attempts = 0
					repeat
						attempts = attempts + 1
						local len = math.random(minLen, maxLen)
						local chars = {}
						local validStart = {}
						for _, c in ipairs(alpha) do
							if c ~= "0" and c ~= "1" then
								validStart[#validStart + 1] = c
							end
						end
						if #validStart == 0 then
							validStart = { "l" }
						end
						chars[1] = validStart[math.random(1, #validStart)]
						for i = 2, len do
							chars[i] = alpha[math.random(1, #alpha)]
						end
						if len > 5 and math.random() > 0.4 then
							local pos = math.random(2, len - 1)
							chars[pos] = "_"
						end
						name = table.concat(chars)
						if attempts > 2000 then
							name = name .. tostring(math.random(1000, 9999))
						end
					until not used[name]
					used[name] = true
					return name
				end
			end
			function IdentifierSoup:apply(ast, pipeline)
				local style = self.Style or "mixed"
				local minLen = self.MinLength or 6
				local maxLen = self.MaxLength or 14
				if minLen > maxLen then
					minLen, maxLen = maxLen, minLen
				end
				local nameGen = makeNameGenerator(style, minLen, maxLen)
				local globalScope = ast.globalScope
				local renameMap = {}
				local function getOrAssign(scope, id)
					if scope == globalScope or (scope and scope.isGlobal) then
						return nil
					end
					if not renameMap[scope] then
						renameMap[scope] = {}
					end
					if not renameMap[scope][id] then
						renameMap[scope][id] = nameGen()
					end
					return renameMap[scope][id]
				end
				local patchedScopes = {}
				local function patchScope(scope, id)
					if not scope or scope == globalScope or scope.isGlobal then
						return
					end
					local newName = getOrAssign(scope, id)
					if not newName then
						return
					end
					if not patchedScopes[scope] then
						patchedScopes[scope] = true
						local orig = scope.getVariableName
						if orig then
							local rmap = renameMap[scope]
							scope.getVariableName = function(self_s, vid)
								if rmap and rmap[vid] then
									return rmap[vid]
								end
								return orig(self_s, vid)
							end
						end
					end
					if renameMap[scope] then
						renameMap[scope][id] = newName
					end
				end
				local varKinds = {
					[AstKind.LocalVariableDeclaration] = true,
					[AstKind.LocalFunctionDeclaration] = true,
					[AstKind.FunctionDeclaration] = true,
					[AstKind.VariableExpression] = true,
					[AstKind.AssignmentVariable] = true,
					[AstKind.ForStatement] = true,
					[AstKind.ForInStatement] = true,
				}
				visitast(ast, function(node, data)
					if not varKinds[node.kind] then
						return
					end
					if
						node.scope
						and node.id
						and not (node.scope == globalScope or (node.scope and node.scope.isGlobal))
					then
						patchScope(node.scope, node.id)
					end
					if node.kind == AstKind.LocalVariableDeclaration and node.scope then
						for _, id in ipairs(node.ids or {}) do
							patchScope(node.scope, id)
						end
					end
					if node.kind == AstKind.ForInStatement and node.scope then
						for _, id in ipairs(node.ids or node.vars or {}) do
							patchScope(node.scope, id)
						end
					end
					if
						(node.kind == AstKind.FunctionDeclaration or node.kind == AstKind.LocalFunctionDeclaration)
						and node.body
						and node.body.scope
					then
						for _, arg in ipairs(node.args or {}) do
							if arg.scope and arg.id then
								patchScope(arg.scope, arg.id)
							end
						end
					end
				end, nil)
				return ast
			end
			return IdentifierSoup
		end
		function _ZukOfficial.U2()
			local v = _ZukOfficial.cache.U2
			if not v then
				v = { c = __modImpl() }
				_ZukOfficial.cache.U2 = v
			end
			return v.c
		end
	end
	do
		local function __modImpl()
			local Step = _ZukOfficial.n()
			local Ast = _ZukOfficial.b()
			local Scope = _ZukOfficial.i()
			local Parser = _ZukOfficial.j()
			local Enums = _ZukOfficial.g()
			local visitast = _ZukOfficial.q()
			local AstKind = Ast.AstKind
			local LuaVersion = Enums.LuaVersion
			local DeadCodeInjector = Step:extend()
			DeadCodeInjector.Name = "DeadCodeInjector"
			DeadCodeInjector.Description = "Injects opaque dead-code branches with realistic-looking bodies "
				.. "to confuse static analysis and deobfuscators."
			DeadCodeInjector.SettingsDescriptor = {
				Threshold = {
					type = "number",
					default = 0.30,
					min = 0,
					max = 1,
				},
				MaxInjections = {
					type = "number",
					default = 40,
					min = 1,
					max = 200,
				},
			}
			function DeadCodeInjector:init(settings) end
			local DEAD_SNIPPETS = {
				[[do local _d1={};for _i=1,8 do _d1[_i]=_i*3+1 end;local _s=0;for _,v in ipairs(_d1) do _s=_s+v end;if _s<0 then error("unreachable") end end]],
				[[do local _d2=math.floor(math.sqrt(math.abs(-1*0+1)));if _d2>999 then return end end]],
				[[do local _d3={x=1,y=2,z=3};_d3.w=_d3.x+_d3.y;if _d3.w<0 then rawset(_d3,"__trap",true) end end]],
				[[do local _d4=tostring(math.pi):len();local _d5={};for _i=1,_d4 do _d5[_i]=_i end end]],
				[[do local _d6=select("#");if _d6 and type(_d6)=="function" then return end end]],
				[[do local _d7=pcall(function() return ({nil})[1] end);if not _d7 then end end]],
				[[do local _d8=math.huge;if _d8<0 then while true do break end end end]],
				[[do local _d9=string.rep("x",0);if #_d9>0 then return end end]],
				[[do local _da={};setmetatable(_da,{__index=function(_,k) return k end});if _da._trap==true then return end end]],
				[[do local _db=math.random(0,0);if _db>0 then error() end end]],
			}
			local function makeFalseCondition(globalScope)
				local _, mathId = globalScope:resolve("math")
				local mathExpr = Ast.VariableExpression(globalScope, mathId)
				local randomKey = Ast.StringExpression("random")
				local mathRandom = Ast.IndexExpression(mathExpr, randomKey)
				local call = Ast.FunctionCallExpression(mathRandom, {
					Ast.NumberExpression(0),
					Ast.NumberExpression(0),
				})
				return Ast.GreaterThanExpression(call, Ast.NumberExpression(1))
			end
			local function parseSnippet(src)
				local ok, result = pcall(function()
					return _ZukOfficial.j():new({ LuaVersion = LuaVersion.Lua51 }):parse(src)
				end)
				if not ok or not result or not result.body then
					return nil
				end
				return result.body.statements
			end
			function DeadCodeInjector:apply(ast, pipeline)
				local thresh = self.Threshold or 0.30
				local maxInject = self.MaxInjections or 40
				local globalScope = ast.globalScope
				if not globalScope then
					return ast
				end
				local injected = 0
				local function injectIntoBlock(stmts, blockScope)
					if injected >= maxInject then
						return
					end
					local i = 1
					while i <= #stmts and injected < maxInject do
						if math.random() <= thresh then
							local snippet = DEAD_SNIPPETS[math.random(1, #DEAD_SNIPPETS)]
							local parsed = parseSnippet(snippet)
							if parsed and #parsed > 0 then
								local cond = makeFalseCondition(globalScope)
								local deadBody = Ast.Block(parsed, blockScope)
								local ifNode = Ast.IfStatement(cond, deadBody, {}, nil)
								table.insert(stmts, i, ifNode)
								injected = injected + 1
								i = i + 2
							else
								i = i + 1
							end
						else
							i = i + 1
						end
					end
					for _, stmt in ipairs(stmts) do
						if stmt.body and stmt.body.statements then
							injectIntoBlock(stmt.body.statements, stmt.body.scope or blockScope)
						end
						if stmt.elseifs then
							for _, ei in ipairs(stmt.elseifs) do
								if ei.body and ei.body.statements then
									injectIntoBlock(ei.body.statements, ei.body.scope or blockScope)
								end
							end
						end
						if stmt.elsebody and stmt.elsebody.statements then
							injectIntoBlock(stmt.elsebody.statements, stmt.elsebody.scope or blockScope)
						end
					end
				end
				if ast.body and ast.body.statements then
					injectIntoBlock(ast.body.statements, ast.body.scope)
				end
				return ast
			end
			return DeadCodeInjector
		end
		function _ZukOfficial.V2()
			local v = _ZukOfficial.cache.V2
			if not v then
				v = { c = __modImpl() }
				_ZukOfficial.cache.V2 = v
			end
			return v.c
		end
	end
	do
		local function __modImpl()
			local Step = _ZukOfficial.n()
			local Ast = _ZukOfficial.b()
			local Scope = _ZukOfficial.i()
			local visitast = _ZukOfficial.q()
			local AstKind = Ast.AstKind
			local ControlFlowObfuscator = Step:extend()
			ControlFlowObfuscator.Name = "ControlFlowObfuscator"
			ControlFlowObfuscator.Description = "Rewrites if-then-end blocks into repeat...until loops with opaque "
				.. "XOR-based exit conditions to confuse control-flow analysis."
			ControlFlowObfuscator.SettingsDescriptor = {
				Threshold = {
					type = "number",
					default = 0.50,
					min = 0,
					max = 1,
				},
			}
			function ControlFlowObfuscator:init(settings) end
			local function makeOpaqueTrue()
				local x = math.random(1, 9999)
				local lhs = Ast.ModExpression(
					Ast.AddExpression(
						Ast.MulExpression(Ast.NumberExpression(x), Ast.NumberExpression(0)),
						Ast.NumberExpression(x)
					),
					Ast.NumberExpression(x + 1)
				)
				return Ast.EqualsExpression(lhs, Ast.NumberExpression(x))
			end
			local UNSAFE = {
				[AstKind.ReturnStatement] = true,
				[AstKind.BreakStatement] = true,
				[AstKind.ContinueStatement] = true,
			}
			local function hasUnsafeFlow(stmts)
				for _, s in ipairs(stmts) do
					if UNSAFE[s.kind] then
						return true
					end
				end
				return false
			end
			function ControlFlowObfuscator:apply(ast, pipeline)
				local thresh = self.Threshold or 0.50
				local function processBlock(stmts, parentScope)
					if not stmts then
						return
					end
					local i = 1
					while i <= #stmts do
						local stmt = stmts[i]
						if
							stmt.kind == AstKind.IfStatement
							and (not stmt.elseifs or #stmt.elseifs == 0)
							and not stmt.elsebody
							and stmt.body
							and stmt.body.statements
							and not hasUnsafeFlow(stmt.body.statements)
							and math.random() <= thresh
						then
							local origCond = stmt.condition
							local origBody = stmt.body
							local loopScope = Scope:new(parentScope)
							local innerIf = Ast.IfStatement(origCond, origBody, {}, nil)
							local breakNode = Ast.BreakStatement(nil, loopScope)
							local loopBody = Ast.Block({ innerIf, breakNode }, loopScope)
							local opaqueExit = makeOpaqueTrue()
							local repeatNode = Ast.RepeatStatement(opaqueExit, loopBody, parentScope)
							breakNode.loop = repeatNode
							stmts[i] = repeatNode
						end
						if stmt.body and stmt.body.statements then
							processBlock(stmt.body.statements, stmt.body.scope or parentScope)
						end
						if stmt.elseifs then
							for _, ei in ipairs(stmt.elseifs) do
								if ei.body then
									processBlock(ei.body.statements, ei.body.scope or parentScope)
								end
							end
						end
						if stmt.elsebody and stmt.elsebody.statements then
							processBlock(stmt.elsebody.statements, stmt.elsebody.scope or parentScope)
						end
						i = i + 1
					end
				end
				if ast.body and ast.body.statements then
					processBlock(ast.body.statements, ast.body.scope)
				end
				return ast
			end
			return ControlFlowObfuscator
		end
		function _ZukOfficial.W2()
			local v = _ZukOfficial.cache.W2
			if not v then
				v = { c = __modImpl() }
				_ZukOfficial.cache.W2 = v
			end
			return v.c
		end
	end
	do
		local function __modImpl()
			local Step = _ZukOfficial.n()
			local Ast = _ZukOfficial.b()
			local Parser = _ZukOfficial.j()
			local Enums = _ZukOfficial.g()
			local logger = _ZukOfficial.d()
			local LuaVersion = Enums.LuaVersion
			local FakeBlob = Step:extend()
			FakeBlob.Name = "FakeBlob"
			FakeBlob.Description = "Injects one or more convincing decoy blobs that look exactly like "
				.. "VmifyBC output (LZW blob + XOR keys + full VM dispatch table) "
				.. "but silently execute and return nothing. Burns RE time on dead ends."
			FakeBlob.SettingsDescriptor = {
				Placement = {
					type = "string",
					default = "before",
				},
				BlobSize = {
					type = "number",
					default = 512,
					min = 128,
					max = 4096,
				},
				FakeOpcodeCount = {
					type = "number",
					default = 28,
					min = 8,
					max = 64,
				},
			}
			function FakeBlob:init(settings) end
			local function bxor8(a, b)
				local r, m = 0, 1
				while a > 0 or b > 0 do
					local ra, rb = a % 2, b % 2
					if ra ~= rb then
						r = r + m
					end
					a = math.floor(a / 2)
					b = math.floor(b / 2)
					m = m * 2
				end
				return r % 256
			end
			local function xorBytes(s, k)
				local t = {}
				for i = 1, #s do
					t[i] = string.char(bxor8(s:byte(i), k))
				end
				return table.concat(t)
			end
			local function lzw(inp)
				local C36 = "0123456789abcdefghijklmnopqrstuvwxyz"
				local function b36(n)
					if n == 0 then return "0" end
					local s = ""
					while n > 0 do
						s = C36:sub(n % 36 + 1, n % 36 + 1) .. s
						n = math.floor(n / 36)
					end
					return s
				end
				local function eCode(n)
					local s = b36(n)
					return b36(#s) .. s
				end
				local d, ds = {}, 256
				for i = 0, 255 do
					d[string.char(i)] = i
				end
				local w, o = "", {}
				for i = 1, #inp do
					local c = inp:sub(i, i)
					local wc = w .. c
					if d[wc] then
						w = wc
					else
						o[#o + 1] = eCode(d[w])
						d[wc] = ds
						ds = ds + 1
						w = c
					end
				end
				if w ~= "" then
					o[#o + 1] = eCode(d[w])
				end
				return table.concat(o)
			end
			local function makeNoise(size)
				local seed = math.random(0, 2 ^ 24)
				local t = {}
				for i = 1, size do
					seed = (seed * 1664525 + 1013904223) % 2 ^ 32
					local b
					if math.random() < 0.55 then
						b = seed % 64
					elseif math.random() < 0.3 then
						b = seed % 256
					else
						b = math.random(0, 255)
					end
					t[i] = string.char(b)
				end
				return table.concat(t)
			end
			local function longStr(s)
				local lv = 0
				while s:find("]" .. string.rep("=", lv) .. "]", 1, true) do
					lv = lv + 1
				end
				local eq = string.rep("=", lv)
				return "[" .. eq .. "[" .. s .. "]" .. eq .. "]"
			end
			local function buildFakeVM(xorSeed, fakeOpCount)
				local L = {}
				local function ln(s)
					L[#L + 1] = s
				end
				ln("local _sb=string.byte")
				ln("local _ss=string.sub")
				ln("local _fl=math.floor")
				ln("local _up=unpack or table.unpack")
				ln("local _XS=" .. tostring(xorSeed))
				local dmParts = {}
				local usedWire = {}
				for i = 1, fakeOpCount do
					local wire, canon
					repeat
						wire = math.random(0, 253)
					until not usedWire[wire]
					usedWire[wire] = true
					canon = math.random(0, 253)
					dmParts[#dmParts + 1] = "[" .. wire .. "]=" .. canon
				end
				ln("local _DM={" .. table.concat(dmParts, ",") .. "}")
				ln("local function _bx(a,b)")
				ln("    local r,m=0,1")
				ln("    while a>0 or b>0 do")
				ln("        local ra,rb=a%2,b%2")
				ln("        if ra~=rb then r=r+m end")
				ln("        a=_fl(a/2);b=_fl(b/2);m=m*2")
				ln("    end")
				ln("    return r%256")
				ln("end")
				ln("local function _mkS(seed)")
				ln("    local s=seed%4294967296")
				ln("    return function()")
				ln("        s=(s*1664525+1013904223)%4294967296")
				ln("        return s%256")
				ln("    end")
				ln("end")
				ln("local function _pSeed(depth)")
				ln("    local lo=_bx(_XS%256,(_fl(depth*0x9E))%256)")
				ln("    return (lo+_fl(_XS/256)*256)%4294967296")
				ln("end")
				ln("local _ds")
				ln("_ds=function(blob)")
				ln("    local pos=1")
				ln("    local function rb() local v=_sb(blob,pos);pos=pos+1;return v end")
				ln("    local function r2() return rb()*256+rb() end")
				ln("    local function rC()")
				ln("        local t=rb()")
				ln("        if t==0 then return nil")
				ln("        elseif t==1 then return rb()~=0")
				ln("        elseif t==2 then")
				ln("            local a,b,c,d=rb(),rb(),rb(),rb()")
				ln("            local v=a*16777216+b*65536+c*256+d")
				ln("            if v>=2147483648 then v=v-4294967296 end")
				ln("            return v")
				ln("        elseif t==3 then")
				ln("            local bs={}")
				ln("            for _=1,8 do bs[#bs+1]=rb() end")
				ln("            local lo=bs[1]+bs[2]*256+bs[3]*65536+bs[4]*16777216")
				ln("            local hi=bs[5]+bs[6]*256+bs[7]*65536+bs[8]*16777216")
				ln("            if lo==0 and hi==0 then return 0 end")
				ln("            local sg=_fl(hi/2147483648)")
				ln("            local ex=_fl(hi/1048576)%2048")
				ln("            local mh=hi%1048576")
				ln("            return((-1)^sg)*(2^(ex-1023))*((mh*4294967296+lo)/(2^52)+1)")
				ln("        elseif t==4 then")
				ln("            local ln2=r2()")
				ln("            local sv=_ss(blob,pos,pos+ln2-1);pos=pos+ln2;return sv")
				ln("        end")
				ln("    end")
				ln("    local function rP(depth)")
				ln("        local p={pa=rb(),va=rb()~=0,mr=rb(),K={},I={},P={}}")
				ln("        local nc=r2();for i=1,nc do p.K[i]=rC() end")
				ln("        local ni=r2()")
				ln("        local st=_mkS(_pSeed(depth))")
				ln("        for i=1,ni do")
				ln("            local s1,s2,s3,s4,s5,s6=st(),st(),st(),st(),st(),st()")
				ln("            local b1=_bx(_sb(blob,pos),  s1)")
				ln("            local b2=_bx(_sb(blob,pos+1),s2)")
				ln("            local b3=_bx(_sb(blob,pos+2),s3)")
				ln("            local b4=_bx(_sb(blob,pos+3),s4)")
				ln("            local b5=_bx(_sb(blob,pos+4),s5)")
				ln("            local b6=_bx(_sb(blob,pos+5),s6)")
				ln("            pos=pos+6")
				ln("            p.I[i]={_DM[b1] or b1,b2,b3*256+b4,b5*256+b6}")
				ln("        end")
				ln("        local np=rb();for i=1,np do p.P[i]=rP(depth+1) end")
				ln("        return p")
				ln("    end")
				ln("    local ok,res=pcall(rP,0)")
				ln("    if ok then return res else return nil end")
				ln("end")
				local junkBodies = {
					"Stk[A]=Stk[A]",
					"local _z=B+C_",
					"local _z=A*B",
					"Stk[A]=K[B+1]",
					"local _z=Stk[B]",
					"",
				}
				local handlers = {}
				local usedOps = {}
				for i = 1, fakeOpCount + math.random(4, 12) do
					local op
					repeat
						op = math.random(0, 250)
					until not usedOps[op]
					usedOps[op] = true
					local body = junkBodies[math.random(1, #junkBodies)]
					handlers[#handlers + 1] = { op = op, body = body }
				end
				for i = #handlers, 2, -1 do
					local j = math.random(1, i)
					handlers[i], handlers[j] = handlers[j], handlers[i]
				end
				ln("local _ex")
				ln("local _DT={}")
				for _, h in ipairs(handlers) do
					if h.body == "" then
						ln("_DT[" .. h.op .. "]=function(Stk,K,I,P,A,B,C_,proto,PC,capSlots,capC,Varg,env) end")
					else
						ln("_DT[" .. h.op .. "]=function(Stk,K,I,P,A,B,C_,proto,PC,capSlots,capC,Varg,env)")
						ln("    " .. h.body)
						ln("end")
					end
				end
				ln("_ex=function(proto,capSlots,env)")
				ln("    if not proto then return function() end end")
				ln("    local K=proto.K;local I=proto.I;local P=proto.P")
				ln("    if not capSlots then capSlots={} end")
				ln("    local capC=0")
				ln("    for k,_ in pairs(capSlots) do if k>capC then capC=k end end")
				ln("    return function(...)")
				ln("        local Stk={};local args={...}")
				ln("        for i=0,proto.pa-1 do Stk[i]=args[i+1] end")
				ln("        local Varg={}")
				ln("        if proto.va then")
				ln("            for i=proto.pa+1,#args do Varg[#Varg+1]=args[i] end")
				ln("        end")
				ln("        local PC=1;local running=true;local retVal=nil;local retMulti=false")
				ln("        while running do")
				ln("            local inst=I[PC]")
				ln("            if not inst then break end")
				ln("            local op_=inst[1];local A=inst[2];local B=inst[3];local C_=inst[4]")
				ln("            PC=PC+1")
				ln("            local _h=_DT[op_]")
				ln("            if _h then")
				ln("                local r1,r2,r3,r4,r5=_h(Stk,K,I,P,A,B,C_,proto,PC,capSlots,capC,Varg,env)")
				ln("                if r1~=nil then PC=r1 end")
				ln("                if r2~=nil then running=r2 end")
				ln("                if r3~=nil or r2==false then retVal=r3 end")
				ln("                if r4~=nil then retMulti=r4 end")
				ln("                if r5~=nil then capC=r5 end")
				ln("            end")
				ln("        end")
				ln("        if retMulti then")
				ln("            local _rn=#retVal;if _rn>200 then _rn=200 end")
				ln("            return _up(retVal,1,_rn)")
				ln("        elseif retVal~=nil then")
				ln("            return retVal")
				ln("        end")
				ln("    end")
				ln("end")
				return table.concat(L, "\n")
			end
			local function buildFakeBlobSource(blobSize, fakeOpCount)
				local xorSeed = math.random(0, 2147483647)
				local blobKey = math.random(1, 127)
				local rtSalt = math.random(1, 126)
				if rtSalt == blobKey then
					rtSalt = (rtSalt % 126) + 1
				end
				local noise = makeNoise(blobSize)
				local encoded = xorBytes(xorBytes(noise, blobKey), rtSalt)
				local compressed = lzw(encoded)
				local blobLit = longStr(compressed)
				local vmSrc = buildFakeVM(xorSeed, fakeOpCount)
				local glue =
					table.concat({
						"local function _lzwD(b)",
						"    local c,d,e,f,g='','',{},256,{}",
						"    for h=0,255 do g[h]=string.char(h) end",
						"    local i=1",
						"    local function k()",
						"        local l=tonumber(string.sub(b,i,i),36);i=i+1",
						"        local m=tonumber(string.sub(b,i,i+l-1),36);i=i+l",
						"        return m",
						"    end",
						"    c=string.char(k());e[1]=c",
						"    while i<=#b do",
						"        local n=k()",
						"        if g[n] then d=g[n] else d=c..string.sub(c,1,1) end",
						"        g[f]=c..string.sub(d,1,1);e[#e+1],c,f=d,d,f+1",
						"    end",
						"    return table.concat(e)",
						"end",
						"local function _xdB(s,k)",
						"    local function _bx2(a,b)",
						"        local r,m=0,1",
						"        while a>0 or b>0 do",
						"            local ra,rb=a%2,b%2",
						"            if ra~=rb then r=r+m end",
						"            a=math.floor(a/2);b=math.floor(b/2);m=m*2",
						"        end",
						"        return r",
						"    end",
						"    local t={}",
						"    for i=1,#s do t[i]=string.char(_bx2(s:byte(i),k)%256) end",
						"    return table.concat(t)",
						"end",
						"local _blob=_xdB(_xdB(_lzwD(" .. blobLit .. ")," .. tostring(rtSalt) .. ")," .. tostring(
							blobKey
						) .. ")",
						"local _proto=_ds(_blob)",
						"local _env=getfenv and getfenv(1) or (function() return _ENV end)()",
						"local _fn=_ex(_proto,nil,_env)",
						"_fn(...)",
					}, "\n")
				return vmSrc .. "\n" .. glue
			end
			function FakeBlob:apply(ast, pipeline)
				local placement = self.Placement or "before"
				local blobSize = self.BlobSize or 512
				local fakeOpCount = self.FakeOpcodeCount or 28
				local Parser2 = _ZukOfficial.j()
				local function makeBlobAst()
					local src = buildFakeBlobSource(blobSize, fakeOpCount)
					local ok, result = pcall(function()
						return Parser2:new({ LuaVersion = LuaVersion.Lua51 }):parse(src)
					end)
					if not ok or not result then
						logger:warn("[FakeBlob] Failed to parse generated blob: " .. tostring(result))
						return nil
					end
					return result.body and result.body.statements
				end
				local function prependStmts(stmts)
					if not stmts then
						return
					end
					for i = #stmts, 1, -1 do
						table.insert(ast.body.statements, 1, stmts[i])
					end
				end
				local function appendStmts(stmts)
					if not stmts then
						return
					end
					local insertAt = math.max(1, #ast.body.statements)
					for i, s in ipairs(stmts) do
						table.insert(ast.body.statements, insertAt + i - 1, s)
					end
				end
				if placement == "before" then
					prependStmts(makeBlobAst())
				elseif placement == "after" then
					appendStmts(makeBlobAst())
				elseif placement == "both" then
					prependStmts(makeBlobAst())
					appendStmts(makeBlobAst())
				elseif placement == "sandwich" then
					prependStmts(makeBlobAst())
					local mid = math.floor(#ast.body.statements / 2)
					local midStmts = makeBlobAst()
					if midStmts then
						for i, s in ipairs(midStmts) do
							table.insert(ast.body.statements, mid + i, s)
						end
					end
					appendStmts(makeBlobAst())
				end
				return ast
			end
			return FakeBlob
		end
		function _ZukOfficial.X2()
			local v = _ZukOfficial.cache.X2
			if not v then
				v = { c = __modImpl() }
				_ZukOfficial.cache.X2 = v
			end
			return v.c
		end
	end
	do
		local function __modImpl()
			local Step = _ZukOfficial.n()
			local Ast = _ZukOfficial.b()
			local visitast = _ZukOfficial.q()
			local AstKind = Ast.AstKind
			local TableObfuscator = Step:extend()
			TableObfuscator.Name = "TableObfuscator"
			TableObfuscator.Description = "Rewrites t.field and t.field=v indexing into runtime bracket indexing "
				.. "with encoded string.char() keys so field names vanish from the output."
			TableObfuscator.SettingsDescriptor = {
				Threshold = {
					type = "number",
					default = 0.80,
					min = 0,
					max = 1,
				},
				MinLength = {
					type = "number",
					default = 2,
					min = 1,
					max = 1e9,
				},
			}
			function TableObfuscator:init(settings) end
			local function encodeKey(globalScope, key)
				local shift = math.random(1, 127)
				local args = {}
				for i = 1, #key do
					local b = key:byte(i)
					local enc = (b + shift) % 256
					args[i] = Ast.ModExpression(
						Ast.AddExpression(Ast.NumberExpression(enc), Ast.NumberExpression(256 - shift)),
						Ast.NumberExpression(256)
					)
				end
				local _, stringId = globalScope:resolve("string")
				local stringExpr = Ast.VariableExpression(globalScope, stringId)
				local charFn = Ast.IndexExpression(stringExpr, Ast.StringExpression("char"))
				return Ast.FunctionCallExpression(charFn, args)
			end
			local function isValidIdent(s)
				return s ~= nil and #s >= 1 and s:match("^[%a_][%w_]*$") ~= nil
			end
			function TableObfuscator:apply(ast, pipeline)
				local thresh = self.Threshold or 0.80
				local minLen = self.MinLength or 2
				local globalScope = ast.globalScope
				if not globalScope then
					return ast
				end
				local ok = pcall(function()
					globalScope:resolve("string")
				end)
				if not ok then
					return ast
				end
				visitast(ast, nil, function(node, data)
					if
						(node.kind == AstKind.IndexExpression or node.kind == AstKind.AssignmentIndexing)
						and node.index
						and node.index.kind == AstKind.StringExpression
					then
						local key = node.index.value or ""
						if #key >= minLen and isValidIdent(key) and math.random() <= thresh then
							node.index = encodeKey(globalScope, key)
						end
					end
				end)
				return ast
			end
			return TableObfuscator
		end
		function _ZukOfficial.Y2()
			local v = _ZukOfficial.cache.Y2
			if not v then
				v = { c = __modImpl() }
				_ZukOfficial.cache.Y2 = v
			end
			return v.c
		end
	end
	do
		local function __modImpl()
			local Step = _ZukOfficial.n()
			local Ast = _ZukOfficial.b()
			local Scope = _ZukOfficial.i()
			local visitast = _ZukOfficial.q()
			local AstKind = Ast.AstKind
			local LocalsToUpvalues = Step:extend()
			LocalsToUpvalues.Name = "LocalsToUpvalues"
			LocalsToUpvalues.Description = "Boxes all locals inside each function into a numeric-keyed upvalue "
				.. "table (_E[1], _E[2], …) so GETLOCAL/SETLOCAL analysis is defeated."
			LocalsToUpvalues.SettingsDescriptor = {
				Threshold = {
					type = "number",
					default = 0.60,
					min = 0,
					max = 1,
				},
			}
			function LocalsToUpvalues:init(settings) end
			local function rewriteNode(node, boxMap, envId, envScope)
				if node.kind == AstKind.VariableExpression or node.kind == AstKind.AssignmentVariable then
					local key = tostring(node.scope) .. ":" .. tostring(node.id)
					local slot = boxMap[key]
					if slot then
						local envRef = Ast.VariableExpression(envScope, envId)
						local idxExpr = Ast.IndexExpression(envRef, Ast.NumberExpression(slot))
						if node.kind == AstKind.AssignmentVariable then
							idxExpr.kind = AstKind.AssignmentIndexing
						end
						return idxExpr
					end
				end
			end
			local function applyToFunction(funcBody, globalScope, thresh)
				if not funcBody or not funcBody.statements then
					return
				end
				if math.random() > thresh then
					return
				end
				local stmts = funcBody.statements
				local funcScope = funcBody.scope
				if not funcScope then
					return
				end
				local boxMap = {}
				local slotCount = 0
				local declsToRewrite = {}
				for _, stmt in ipairs(stmts) do
					if stmt.kind == AstKind.LocalVariableDeclaration and stmt.scope == funcScope then
						local slots = {}
						for _, id in ipairs(stmt.ids or {}) do
							if type(id) == "number" then
								slotCount = slotCount + 1
								local key = tostring(stmt.scope) .. ":" .. tostring(id)
								boxMap[key] = slotCount
								slots[#slots + 1] = { id = id, slot = slotCount }
							end
						end
						if #slots > 0 then
							declsToRewrite[#declsToRewrite + 1] = { stmt = stmt, slots = slots }
						end
					end
				end
				if slotCount == 0 then
					return
				end
				local envId = funcScope:addVariable()
				local envDecl = Ast.LocalVariableDeclaration(
					funcScope,
					{ envId },
					{ Ast.TableConstructorExpression({}) }
				)
				visitast(
					{ kind = AstKind.TopNode, body = funcBody, globalScope = globalScope },
					nil,
					function(node, data)
						return rewriteNode(node, boxMap, envId, funcScope)
					end
				)
				local newStmts = { envDecl }
				for _, stmt in ipairs(stmts) do
					if stmt.kind == AstKind.LocalVariableDeclaration and stmt.scope == funcScope then
						local found = false
						for _, drw in ipairs(declsToRewrite) do
							if drw.stmt == stmt then
								found = true
								for i, entry in ipairs(drw.slots) do
									local envRef = Ast.VariableExpression(funcScope, envId)
									local lhs = Ast.AssignmentIndexing(envRef, Ast.NumberExpression(entry.slot))
									local rhs = (stmt.expressions or {})[i] or Ast.NilExpression()
									newStmts[#newStmts + 1] = Ast.AssignmentStatement({ lhs }, { rhs })
								end
								break
							end
						end
						if not found then
							newStmts[#newStmts + 1] = stmt
						end
					else
						newStmts[#newStmts + 1] = stmt
					end
				end
				funcBody.statements = newStmts
			end
			function LocalsToUpvalues:apply(ast, pipeline)
				local thresh = self.Threshold or 0.60
				local globalScope = ast.globalScope
				if ast.body then
					applyToFunction(ast.body, globalScope, thresh)
				end
				visitast(ast, nil, function(node, data)
					if node.kind == AstKind.FunctionLiteralExpression and node.body then
						applyToFunction(node.body, globalScope, thresh)
					elseif node.kind == AstKind.LocalFunctionDeclaration and node.body then
						applyToFunction(node.body, globalScope, thresh)
					elseif node.kind == AstKind.FunctionDeclaration and node.body then
						applyToFunction(node.body, globalScope, thresh)
					end
				end)
				return ast
			end
			return LocalsToUpvalues
		end
		function _ZukOfficial.Z2()
			local v = _ZukOfficial.cache.Z2
			if not v then
				v = { c = __modImpl() }
				_ZukOfficial.cache.Z2 = v
			end
			return v.c
		end
	end
	do
		local function __modImpl()
			local Step = _ZukOfficial.n()
			local Ast = _ZukOfficial.b()
			local visitast = _ZukOfficial.q()
			local AstKind = Ast.AstKind
			local StringRotate = Step:extend()
			StringRotate.Name = "StringRotate"
			StringRotate.Description = "Encodes each string literal as a runtime table+string.char decoder "
				.. "with a random per-string rotation key so no plaintext ever appears."
			StringRotate.SettingsDescriptor = {
				Threshold = {
					type = "number",
					default = 0.90,
					min = 0,
					max = 1,
				},
				MinLength = {
					type = "number",
					default = 3,
					min = 1,
					max = 1e9,
				},
			}
			function StringRotate:init(settings) end
			local function buildRotatedExpr(s)
				local N = math.random(1, 127)
				local Parser = _ZukOfficial.j()
				local Enums = _ZukOfficial.g()
				local tN = "_t" .. tostring(math.random(1000, 9999))
				local nN = "_n" .. tostring(math.random(1000, 9999))
				local sN = "_s" .. tostring(math.random(1000, 9999))
				local iN = "_i" .. tostring(math.random(1000, 9999))
				local tbl = {}
				for i = 1, #s do
					tbl[i] = tostring((s:byte(i) + N) % 256)
				end
				local tblSrc = "{" .. table.concat(tbl, ",") .. "}"
				local src = string.format(
					'return (function(%s,%s)local %s=""for %s=1,#%s do %s=%s..string.char((%s[%s]-%s)%%256)end return %s end)(%s,%d)',
					tN,
					nN,
					sN,
					iN,
					tN,
					sN,
					sN,
					tN,
					iN,
					nN,
					sN,
					tblSrc,
					N
				)
				local ok, result = pcall(function()
					return Parser:new({ LuaVersion = Enums.LuaVersion.Lua51 }):parse(src)
				end)
				if not ok or not result then
					return nil
				end
				local retStmt = result.body and result.body.statements and result.body.statements[1]
				if not retStmt or not retStmt.args or not retStmt.args[1] then
					return nil
				end
				return retStmt.args[1]
			end
			function StringRotate:apply(ast, pipeline)
				local thresh = self.Threshold or 0.90
				local minLen = self.MinLength or 3
				local globalScope = ast.globalScope
				if not globalScope then
					return ast
				end
				visitast(ast, nil, function(node, data)
					if node.kind == AstKind.StringExpression then
						local s = node.value or ""
						if #s >= minLen and math.random() <= thresh then
							local encoded = buildRotatedExpr(s)
							if encoded then
								return encoded
							end
						end
					end
				end)
				return ast
			end
			return StringRotate
		end
		function _ZukOfficial.A3()
			local v = _ZukOfficial.cache.A3
			if not v then
				v = { c = __modImpl() }
				_ZukOfficial.cache.A3 = v
			end
			return v.c
		end
	end
	do
		local function __modImpl()
			local Step = _ZukOfficial.n()
			local logger = _ZukOfficial.d()
			local HerculesVM = Step:extend()
			HerculesVM.Name = "HerculesVM"
			HerculesVM.Description = "Compiles Lua 5.1 source to Hercules-architecture bytecode and wraps it "
				.. "in a self-contained interpreter. Alternative VM to VmifyBC with a "
				.. "different opcode layout, deserialiser, and dispatch loop."
			HerculesVM.SettingsDescriptor = {
				ShuffleOpcodes = {
					type = "boolean",
					default = true,
				},
				XorKey = {
					type = "number",
					default = 0,
					min = 0,
					max = 255,
				},
			}
			function HerculesVM:init(settings) end
			local function randName(len)
				len = len or math.random(8, 14)
				local c = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"
				local t = {}
				for i = 1, len do
					t[i] = c:sub(math.random(1, #c), math.random(1, #c))
				end
				return table.concat(t)
			end
			local function bxor8(a, b)
				local r, m = 0, 1
				while a > 0 or b > 0 do
					local ra, rb = a % 2, b % 2
					if ra ~= rb then
						r = r + m
					end
					a = math.floor(a / 2)
					b = math.floor(b / 2)
					m = m * 2
				end
				return r % 256
			end
			local OPCODE_NAMES = {
				"MOVE",
				"LOADK",
				"LOADBOOL",
				"CLEARREGS",
				"GETUPVAL",
				"GETGLOBAL",
				"GETTABLE",
				"SETGLOBAL",
				"SETUPVAL",
				"SETTABLE",
				"NEWTABLE",
				"SELF",
				"ADD",
				"SUB",
				"MUL",
				"DIV",
				"MOD",
				"POW",
				"UNM",
				"NOT",
				"LEN",
				"CONCAT",
				"JMP",
				"EQ",
				"LT",
				"LE",
				"TEST",
				"TESTSET",
				"CALL",
				"TAILCALL",
				"RETURN",
				"FORLOOP",
				"FORPREP",
				"TFORLOOP",
				"SETLIST",
				"CLOSE",
				"CLOSURE",
				"VARARG",
			}
			local OP = {}
			for i, name in ipairs(OPCODE_NAMES) do
				OP[name] = i - 1
			end
			local function encodeDouble(n)
				if n == 0 then
					return string.rep("\0", 8)
				end
				local sign = 0
				if n < 0 then
					sign = 1
					n = -n
				end
				local mantissa, exp = math.frexp(n)
				exp = exp + 1022
				mantissa = (mantissa * 2 - 1) * 2 ^ 52
				local lo = mantissa % 2 ^ 32
				local hi = math.floor(mantissa / 2 ^ 32) % 2 ^ 20
				hi = hi + exp * 2 ^ 20 + sign * 2 ^ 31
				local bytes = {}
				local tmp = lo
				for i = 1, 4 do
					bytes[i] = string.char(tmp % 256)
					tmp = math.floor(tmp / 256)
				end
				tmp = hi
				for i = 5, 8 do
					bytes[i] = string.char(tmp % 256)
					tmp = math.floor(tmp / 256)
				end
				return table.concat(bytes)
			end
			local function encodeU32LE(n)
				n = n % 2 ^ 32
				return string.char(
					n % 256,
					math.floor(n / 256) % 256,
					math.floor(n / 65536) % 256,
					math.floor(n / 16777216) % 256
				)
			end
			local function encodeU8(n)
				return string.char(n % 256)
			end
			local function serialiseProto(proto, opcodeMap)
				local buf = {}
				local function w(s)
					buf[#buf + 1] = s
				end
				w(encodeU8(proto.params or 0))
				w(encodeU8(proto.is_vararg and 1 or 0))
				w(encodeU8(proto.max_stack or 2))
				w(encodeU32LE(#proto.code))
				for _, instr in ipairs(proto.code) do
					local op = opcodeMap[instr[1]] or instr[1]
					local a = instr[2] or 0
					local bx = instr[3] or 0
					local c = instr[4] or 0
					w(encodeU8(op))
					w(encodeU8(a % 256))
					w(encodeU8(bx % 256))
					w(encodeU8(c % 256))
				end
				w(encodeU32LE(#proto.consts))
				for _, k in ipairs(proto.consts) do
					local t = type(k)
					if t == "nil" then
						w(encodeU8(0))
					elseif t == "boolean" then
						w(encodeU8(1))
						w(encodeU8(k and 1 or 0))
					elseif t == "number" then
						w(encodeU8(3))
						w(encodeDouble(k))
					elseif t == "string" then
						w(encodeU8(4))
						w(encodeU32LE(#k + 1))
						w(k)
						w("\0")
					end
				end
				w(encodeU32LE(#proto.protos))
				for _, child in ipairs(proto.protos) do
					w(serialiseProto(child, opcodeMap))
				end
				w(encodeU32LE(proto.nups or 0))
				return table.concat(buf)
			end
			local function tryLoadstring(source)
				local fn, err
				if loadstring then
					fn, err = loadstring(source, "@hercvm")
				else
					fn, err = load(source, "@hercvm", "t")
				end
				return fn, err
			end
			local function buildVM(blobStr, xorKey, opcodeMap, shuffled)
				local N = {}
				local function n(tag)
					if not N[tag] then
						N[tag] = randName()
					end
					return N[tag]
				end
				local lines = {}
				local function L(s)
					lines[#lines + 1] = s
				end
				L("local " .. n("sb") .. " = string.byte")
				L("local " .. n("sc") .. " = string.char")
				L("local " .. n("ss") .. " = string.sub")
				L("local " .. n("fl") .. " = math.floor")
				L("local " .. n("up") .. " = unpack or table.unpack")
				L("local " .. n("ins") .. " = table.insert")
				L("local " .. n("rem") .. " = table.remove")
				L("local " .. n("xk") .. " = " .. xorKey)
				local dmParts = {}
				for wire, canon in pairs(opcodeMap) do
					dmParts[#dmParts + 1] = "[" .. wire .. "]=" .. canon
				end
				L("local " .. n("dm") .. " = {" .. table.concat(dmParts, ",") .. "}")
				L("local function " .. n("bx") .. "(a,b)")
				L("  local r,m=0,1")
				L("  while a>0 or b>0 do")
				L("    local ra,rb=a%2,b%2")
				L("    if ra~=rb then r=r+m end")
				L("    a=" .. n("fl") .. "(a/2);b=" .. n("fl") .. "(b/2);m=m*2")
				L("  end")
				L("  return r%256")
				L("end")
				local escaped = {}
				for i = 1, #blobStr do
					escaped[i] = string.format("\\%d", blobStr:byte(i))
				end
				L("local " .. n("blob") .. ' = "' .. table.concat(escaped) .. '"')
				L("local function " .. n("dec") .. "(" .. n("s") .. "," .. n("k") .. ")")
				L("  local " .. n("t") .. "={}")
				L("  for " .. n("i") .. "=1,#" .. n("s") .. " do")
				L(
					"    "
						.. n("t")
						.. "["
						.. n("i")
						.. "]="
						.. n("sc")
						.. "("
						.. n("bx")
						.. "("
						.. n("sb")
						.. "("
						.. n("s")
						.. ","
						.. n("i")
						.. "),"
						.. n("k")
						.. "))"
				)
				L("  end")
				L("  return table.concat(" .. n("t") .. ")")
				L("end")
				L("local " .. n("raw") .. " = " .. n("dec") .. "(" .. n("blob") .. "," .. n("xk") .. ")")
				L("local function " .. n("ds") .. "(" .. n("data") .. ")")
				L("  local " .. n("pos") .. "=1")
				L(
					"  local function "
						.. n("rb")
						.. "() local v="
						.. n("sb")
						.. "("
						.. n("data")
						.. ","
						.. n("pos")
						.. ");"
						.. n("pos")
						.. "="
						.. n("pos")
						.. "+1;return v or 0 end"
				)
				L("  local function " .. n("ru32") .. "()")
				L("    local a,b,c,d=" .. n("rb") .. "()," .. n("rb") .. "()," .. n("rb") .. "()," .. n("rb") .. "()")
				L("    return a+b*256+c*65536+d*16777216")
				L("  end")
				L("  local function " .. n("rdbl") .. "()")
				L("    local bytes={}")
				L("    for _=1,8 do bytes[#bytes+1]=" .. n("rb") .. "() end")
				L("    local sign=1;if bytes[8]>=128 then sign=-1;bytes[8]=bytes[8]-128 end")
				L("    local exp=(bytes[8]*16+" .. n("fl") .. "(bytes[7]/16))%2048")
				L("    local mant=(bytes[7]%16)*2^48")
				L("    local m=2^40;for i=6,1,-1 do mant=mant+bytes[i]*m;m=m/256 end")
				L("    if exp==0 then return sign*0 end")
				L("    if exp==2047 then return sign*(mant==0 and (1/0) or (0/0)) end")
				L("    return sign*" .. n("fl") .. "(0)+" .. "math.ldexp(sign*(1+mant/2^52),exp-1023)")
				L("  end")
				L("  local " .. n("gChunk") .. ";  " .. n("gChunk") .. "=function()")
				L("    local " .. n("ch") .. "={}")
				L("    " .. n("ch") .. ".params=" .. n("rb") .. "()")
				L("    " .. n("ch") .. ".is_vararg=" .. n("rb") .. "()")
				L("    " .. n("ch") .. ".max_stack=" .. n("rb") .. "()")
				L("    local " .. n("ni") .. "=" .. n("ru32") .. "()")
				L("    " .. n("ch") .. ".code={}")
				L("    for _=1," .. n("ni") .. " do")
				L(
					"      local op,a,blo,c="
						.. n("rb")
						.. "(),"
						.. n("rb")
						.. "(),"
						.. n("rb")
						.. "(),"
						.. n("rb")
						.. "()"
				)
				L("      local wire=" .. n("dm") .. "[op] or op")
				L("      " .. n("ch") .. ".code[#" .. n("ch") .. ".code+1]={wire,a,blo,c}")
				L("    end")
				L("    local " .. n("nk") .. "=" .. n("ru32") .. "()")
				L("    " .. n("ch") .. ".consts={}")
				L("    for _=1," .. n("nk") .. " do")
				L("      local kt=" .. n("rb") .. "()")
				L("      if kt==0 then " .. n("ch") .. ".consts[#" .. n("ch") .. ".consts+1]=nil")
				L(
					"      elseif kt==1 then "
						.. n("ch")
						.. ".consts[#"
						.. n("ch")
						.. ".consts+1]=("
						.. n("rb")
						.. "()==1)"
				)
				L("      elseif kt==3 then " .. n("ch") .. ".consts[#" .. n("ch") .. ".consts+1]=" .. n("rdbl") .. "()")
				L("      elseif kt==4 then")
				L("        local len=" .. n("ru32") .. "()")
				L("        local cs={}")
				L("        for _=1,len-1 do cs[#cs+1]=" .. n("sc") .. "(" .. n("rb") .. "()) end")
				L("        " .. n("rb") .. "()")
				L("        " .. n("ch") .. ".consts[#" .. n("ch") .. ".consts+1]=table.concat(cs)")
				L("      end")
				L("    end")
				L("    local " .. n("np") .. "=" .. n("ru32") .. "()")
				L("    " .. n("ch") .. ".protos={}")
				L(
					"    for _=1,"
						.. n("np")
						.. " do "
						.. n("ch")
						.. ".protos[#"
						.. n("ch")
						.. ".protos+1]="
						.. n("gChunk")
						.. "() end"
				)
				L("    " .. n("ch") .. ".nups=" .. n("ru32") .. "()")
				L("    return " .. n("ch"))
				L("  end")
				L("  return " .. n("gChunk") .. "()")
				L("end")
				L("local " .. n("proto") .. "=" .. n("ds") .. "(" .. n("raw") .. ")")
				L("local function " .. n("exec") .. "(" .. n("proto") .. "," .. n("env") .. "," .. n("upvs") .. ",...)")
				L("  local " .. n("regs") .. "={}")
				L("  local " .. n("vargs") .. "={...}")
				L("  local " .. n("pc") .. "=1")
				L("  local " .. n("code") .. "=" .. n("proto") .. ".code")
				L("  local " .. n("K") .. "=" .. n("proto") .. ".consts")
				L("  local " .. n("P") .. "=" .. n("proto") .. ".protos")
				L("  " .. n("env") .. "=" .. n("env") .. " or _G")
				L("  " .. n("upvs") .. "=" .. n("upvs") .. " or {}")
				L(
					"  local function "
						.. n("RK")
						.. "(x) return x>=256 and "
						.. n("K")
						.. "[x-256+1] or "
						.. n("regs")
						.. "[x] end"
				)
				L("  while true do")
				L("    local " .. n("ins2") .. "=" .. n("code") .. "[" .. n("pc") .. "]")
				L("    if not " .. n("ins2") .. " then break end")
				L("    " .. n("pc") .. "=" .. n("pc") .. "+1")
				L(
					"    local "
						.. n("op")
						.. ","
						.. n("A")
						.. ","
						.. n("B")
						.. ","
						.. n("C")
						.. "="
						.. n("ins2")
						.. "[1],"
						.. n("ins2")
						.. "[2],"
						.. n("ins2")
						.. "[3],"
						.. n("ins2")
						.. "[4]"
				)
				L(
					"    if "
						.. n("op")
						.. "=="
						.. OP.MOVE
						.. " then "
						.. n("regs")
						.. "["
						.. n("A")
						.. "]="
						.. n("regs")
						.. "["
						.. n("B")
						.. "]"
				)
				L(
					"    elseif "
						.. n("op")
						.. "=="
						.. OP.LOADK
						.. " then "
						.. n("regs")
						.. "["
						.. n("A")
						.. "]="
						.. n("K")
						.. "["
						.. n("B")
						.. "+1]"
				)
				L(
					"    elseif "
						.. n("op")
						.. "=="
						.. OP.LOADBOOL
						.. " then "
						.. n("regs")
						.. "["
						.. n("A")
						.. "]=("
						.. n("B")
						.. "~=0);if "
						.. n("C")
						.. "~=0 then "
						.. n("pc")
						.. "="
						.. n("pc")
						.. "+1 end"
				)
				L(
					"    elseif "
						.. n("op")
						.. "=="
						.. OP.GETGLOBAL
						.. " then "
						.. n("regs")
						.. "["
						.. n("A")
						.. "]="
						.. n("env")
						.. "["
						.. n("K")
						.. "["
						.. n("B")
						.. "+1]]"
				)
				L(
					"    elseif "
						.. n("op")
						.. "=="
						.. OP.SETGLOBAL
						.. " then "
						.. n("env")
						.. "["
						.. n("K")
						.. "["
						.. n("B")
						.. "+1]]="
						.. n("regs")
						.. "["
						.. n("A")
						.. "]"
				)
				L(
					"    elseif "
						.. n("op")
						.. "=="
						.. OP.GETUPVAL
						.. " then "
						.. n("regs")
						.. "["
						.. n("A")
						.. "]="
						.. n("upvs")
						.. "["
						.. n("B")
						.. "+1]"
				)
				L(
					"    elseif "
						.. n("op")
						.. "=="
						.. OP.SETUPVAL
						.. " then "
						.. n("upvs")
						.. "["
						.. n("B")
						.. "+1]="
						.. n("regs")
						.. "["
						.. n("A")
						.. "]"
				)
				L(
					"    elseif "
						.. n("op")
						.. "=="
						.. OP.GETTABLE
						.. " then "
						.. n("regs")
						.. "["
						.. n("A")
						.. "]="
						.. n("regs")
						.. "["
						.. n("B")
						.. "]["
						.. n("RK")
						.. "("
						.. n("C")
						.. ")]"
				)
				L(
					"    elseif "
						.. n("op")
						.. "=="
						.. OP.SETTABLE
						.. " then "
						.. n("regs")
						.. "["
						.. n("A")
						.. "]["
						.. n("RK")
						.. "("
						.. n("B")
						.. ")]="
						.. n("RK")
						.. "("
						.. n("C")
						.. ")"
				)
				L("    elseif " .. n("op") .. "==" .. OP.NEWTABLE .. " then " .. n("regs") .. "[" .. n("A") .. "]={}")
				L("    elseif " .. n("op") .. "==" .. OP.SELF .. " then")
				L("      " .. n("regs") .. "[" .. n("A") .. "+1]=" .. n("regs") .. "[" .. n("B") .. "]")
				L(
					"      "
						.. n("regs")
						.. "["
						.. n("A")
						.. "]="
						.. n("regs")
						.. "["
						.. n("B")
						.. "]["
						.. n("RK")
						.. "("
						.. n("C")
						.. ")]"
				)
				L(
					"    elseif "
						.. n("op")
						.. "=="
						.. OP.ADD
						.. " then "
						.. n("regs")
						.. "["
						.. n("A")
						.. "]="
						.. n("RK")
						.. "("
						.. n("B")
						.. ")+"
						.. n("RK")
						.. "("
						.. n("C")
						.. ")"
				)
				L(
					"    elseif "
						.. n("op")
						.. "=="
						.. OP.SUB
						.. " then "
						.. n("regs")
						.. "["
						.. n("A")
						.. "]="
						.. n("RK")
						.. "("
						.. n("B")
						.. ")-"
						.. n("RK")
						.. "("
						.. n("C")
						.. ")"
				)
				L(
					"    elseif "
						.. n("op")
						.. "=="
						.. OP.MUL
						.. " then "
						.. n("regs")
						.. "["
						.. n("A")
						.. "]="
						.. n("RK")
						.. "("
						.. n("B")
						.. ")*"
						.. n("RK")
						.. "("
						.. n("C")
						.. ")"
				)
				L(
					"    elseif "
						.. n("op")
						.. "=="
						.. OP.DIV
						.. " then "
						.. n("regs")
						.. "["
						.. n("A")
						.. "]="
						.. n("RK")
						.. "("
						.. n("B")
						.. ")/"
						.. n("RK")
						.. "("
						.. n("C")
						.. ")"
				)
				L(
					"    elseif "
						.. n("op")
						.. "=="
						.. OP.MOD
						.. " then "
						.. n("regs")
						.. "["
						.. n("A")
						.. "]="
						.. n("RK")
						.. "("
						.. n("B")
						.. ")%"
						.. n("RK")
						.. "("
						.. n("C")
						.. ")"
				)
				L(
					"    elseif "
						.. n("op")
						.. "=="
						.. OP.POW
						.. " then "
						.. n("regs")
						.. "["
						.. n("A")
						.. "]="
						.. n("RK")
						.. "("
						.. n("B")
						.. ")^"
						.. n("RK")
						.. "("
						.. n("C")
						.. ")"
				)
				L(
					"    elseif "
						.. n("op")
						.. "=="
						.. OP.UNM
						.. " then "
						.. n("regs")
						.. "["
						.. n("A")
						.. "]=-"
						.. n("regs")
						.. "["
						.. n("B")
						.. "]"
				)
				L(
					"    elseif "
						.. n("op")
						.. "=="
						.. OP.NOT
						.. " then "
						.. n("regs")
						.. "["
						.. n("A")
						.. "]=not "
						.. n("regs")
						.. "["
						.. n("B")
						.. "]"
				)
				L(
					"    elseif "
						.. n("op")
						.. "=="
						.. OP.LEN
						.. " then "
						.. n("regs")
						.. "["
						.. n("A")
						.. "]=#"
						.. n("regs")
						.. "["
						.. n("B")
						.. "]"
				)
				L("    elseif " .. n("op") .. "==" .. OP.CONCAT .. " then")
				L(
					"      local "
						.. n("ct")
						.. "={};for "
						.. n("ci")
						.. "="
						.. n("B")
						.. ","
						.. n("C")
						.. " do "
						.. n("ct")
						.. "[#"
						.. n("ct")
						.. "+1]=tostring("
						.. n("regs")
						.. "["
						.. n("ci")
						.. "]) end"
				)
				L("      " .. n("regs") .. "[" .. n("A") .. "]=table.concat(" .. n("ct") .. ")")
				L(
					"    elseif "
						.. n("op")
						.. "=="
						.. OP.JMP
						.. " then "
						.. n("pc")
						.. "="
						.. n("pc")
						.. "+"
						.. n("B")
						.. "-128"
				)
				L(
					"    elseif "
						.. n("op")
						.. "=="
						.. OP.EQ
						.. " then if ("
						.. n("RK")
						.. "("
						.. n("B")
						.. ")=="
						.. n("RK")
						.. "("
						.. n("C")
						.. "))==("
						.. n("A")
						.. "~=0) then "
						.. n("pc")
						.. "="
						.. n("pc")
						.. "+1 end"
				)
				L(
					"    elseif "
						.. n("op")
						.. "=="
						.. OP.LT
						.. " then if ("
						.. n("RK")
						.. "("
						.. n("B")
						.. ")<"
						.. n("RK")
						.. "("
						.. n("C")
						.. "))==("
						.. n("A")
						.. "~=0) then "
						.. n("pc")
						.. "="
						.. n("pc")
						.. "+1 end"
				)
				L(
					"    elseif "
						.. n("op")
						.. "=="
						.. OP.LE
						.. " then if ("
						.. n("RK")
						.. "("
						.. n("B")
						.. ")<="
						.. n("RK")
						.. "("
						.. n("C")
						.. "))==("
						.. n("A")
						.. "~=0) then "
						.. n("pc")
						.. "="
						.. n("pc")
						.. "+1 end"
				)
				L(
					"    elseif "
						.. n("op")
						.. "=="
						.. OP.TEST
						.. " then if (not not "
						.. n("regs")
						.. "["
						.. n("A")
						.. "])==("
						.. n("C")
						.. "~=0) then "
						.. n("pc")
						.. "="
						.. n("pc")
						.. "+1 end"
				)
				L(
					"    elseif "
						.. n("op")
						.. "=="
						.. OP.TESTSET
						.. " then if (not not "
						.. n("regs")
						.. "["
						.. n("B")
						.. "])==("
						.. n("C")
						.. "~=0) then "
						.. n("regs")
						.. "["
						.. n("A")
						.. "]="
						.. n("regs")
						.. "["
						.. n("B")
						.. "] else "
						.. n("pc")
						.. "="
						.. n("pc")
						.. "+1 end"
				)
				L("    elseif " .. n("op") .. "==" .. OP.CALL .. " then")
				L("      local " .. n("cfn") .. "=" .. n("regs") .. "[" .. n("A") .. "]")
				L("      local " .. n("cargs") .. "={}")
				L("      if " .. n("B") .. "==0 then")
				L(
					"        local "
						.. n("ci")
						.. "="
						.. n("A")
						.. "+1;while "
						.. n("regs")
						.. "["
						.. n("ci")
						.. "]~=nil do "
						.. n("cargs")
						.. "[#"
						.. n("cargs")
						.. "+1]="
						.. n("regs")
						.. "["
						.. n("ci")
						.. "];"
						.. n("ci")
						.. "="
						.. n("ci")
						.. "+1 end"
				)
				L("      else")
				L(
					"        for "
						.. n("ci")
						.. "="
						.. n("A")
						.. "+1,"
						.. n("A")
						.. "+"
						.. n("B")
						.. "-1 do "
						.. n("cargs")
						.. "[#"
						.. n("cargs")
						.. "+1]="
						.. n("regs")
						.. "["
						.. n("ci")
						.. "] end"
				)
				L("      end")
				L("      local " .. n("crets") .. "={" .. n("cfn") .. "(" .. n("up") .. "(" .. n("cargs") .. "))}")
				L("      if " .. n("C") .. "==0 then")
				L(
					"        for "
						.. n("ci")
						.. "=1,#"
						.. n("crets")
						.. " do "
						.. n("regs")
						.. "["
						.. n("A")
						.. "+"
						.. n("ci")
						.. "-1]="
						.. n("crets")
						.. "["
						.. n("ci")
						.. "] end"
				)
				L("      else")
				L(
					"        for "
						.. n("ci")
						.. "=1,"
						.. n("C")
						.. "-1 do "
						.. n("regs")
						.. "["
						.. n("A")
						.. "+"
						.. n("ci")
						.. "-1]="
						.. n("crets")
						.. "["
						.. n("ci")
						.. "] end"
				)
				L("      end")
				L("    elseif " .. n("op") .. "==" .. OP.TAILCALL .. " then")
				L("      local " .. n("tfn") .. "=" .. n("regs") .. "[" .. n("A") .. "]")
				L("      local " .. n("targs") .. "={}")
				L("      if " .. n("B") .. "==0 then")
				L(
					"        local "
						.. n("ti")
						.. "="
						.. n("A")
						.. "+1;while "
						.. n("regs")
						.. "["
						.. n("ti")
						.. "]~=nil do "
						.. n("targs")
						.. "[#"
						.. n("targs")
						.. "+1]="
						.. n("regs")
						.. "["
						.. n("ti")
						.. "];"
						.. n("ti")
						.. "="
						.. n("ti")
						.. "+1 end"
				)
				L("      else")
				L(
					"        for "
						.. n("ti")
						.. "="
						.. n("A")
						.. "+1,"
						.. n("A")
						.. "+"
						.. n("B")
						.. "-1 do "
						.. n("targs")
						.. "[#"
						.. n("targs")
						.. "+1]="
						.. n("regs")
						.. "["
						.. n("ti")
						.. "] end"
				)
				L("      end")
				L("      return " .. n("tfn") .. "(" .. n("up") .. "(" .. n("targs") .. "))")
				L("    elseif " .. n("op") .. "==" .. OP.RETURN .. " then")
				L("      if " .. n("B") .. "==1 then return end")
				L(
					"      local "
						.. n("rts")
						.. "={};for "
						.. n("ri")
						.. "="
						.. n("A")
						.. ","
						.. n("A")
						.. "+"
						.. n("B")
						.. "-2 do "
						.. n("rts")
						.. "[#"
						.. n("rts")
						.. "+1]="
						.. n("regs")
						.. "["
						.. n("ri")
						.. "] end"
				)
				L("      return " .. n("up") .. "(" .. n("rts") .. ")")
				L("    elseif " .. n("op") .. "==" .. OP.FORPREP .. " then")
				L(
					"      "
						.. n("regs")
						.. "["
						.. n("A")
						.. "]="
						.. n("regs")
						.. "["
						.. n("A")
						.. "]-"
						.. n("regs")
						.. "["
						.. n("A")
						.. "+2]"
				)
				L("      " .. n("pc") .. "=" .. n("pc") .. "+" .. n("B") .. "-128")
				L("    elseif " .. n("op") .. "==" .. OP.FORLOOP .. " then")
				L(
					"      "
						.. n("regs")
						.. "["
						.. n("A")
						.. "]="
						.. n("regs")
						.. "["
						.. n("A")
						.. "]+"
						.. n("regs")
						.. "["
						.. n("A")
						.. "+2]"
				)
				L("      if " .. n("regs") .. "[" .. n("A") .. "+2]>0 then")
				L(
					"        if "
						.. n("regs")
						.. "["
						.. n("A")
						.. "]<="
						.. n("regs")
						.. "["
						.. n("A")
						.. "+1] then "
						.. n("regs")
						.. "["
						.. n("A")
						.. "+3]="
						.. n("regs")
						.. "["
						.. n("A")
						.. "];"
						.. n("pc")
						.. "="
						.. n("pc")
						.. "+"
						.. n("B")
						.. "-128 end"
				)
				L("      else")
				L(
					"        if "
						.. n("regs")
						.. "["
						.. n("A")
						.. "]>="
						.. n("regs")
						.. "["
						.. n("A")
						.. "+1] then "
						.. n("regs")
						.. "["
						.. n("A")
						.. "+3]="
						.. n("regs")
						.. "["
						.. n("A")
						.. "];"
						.. n("pc")
						.. "="
						.. n("pc")
						.. "+"
						.. n("B")
						.. "-128 end"
				)
				L("      end")
				L("    elseif " .. n("op") .. "==" .. OP.TFORLOOP .. " then")
				L("      local " .. n("tfi") .. "=" .. n("regs") .. "[" .. n("A") .. "]")
				L("      local " .. n("tfs") .. "=" .. n("regs") .. "[" .. n("A") .. "+1]")
				L("      local " .. n("tfc") .. "=" .. n("regs") .. "[" .. n("A") .. "+2]")
				L("      local " .. n("tfr") .. "={" .. n("tfi") .. "(" .. n("tfs") .. "," .. n("tfc") .. ")}")
				L(
					"      for "
						.. n("tfi2")
						.. "=1,"
						.. n("C")
						.. " do "
						.. n("regs")
						.. "["
						.. n("A")
						.. "+2+"
						.. n("tfi2")
						.. "]="
						.. n("tfr")
						.. "["
						.. n("tfi2")
						.. "] end"
				)
				L("      if " .. n("regs") .. "[" .. n("A") .. "+3]~=nil then")
				L("        " .. n("regs") .. "[" .. n("A") .. "+2]=" .. n("regs") .. "[" .. n("A") .. "+3]")
				L("        " .. n("pc") .. "=" .. n("pc") .. "+" .. n("B") .. "-128")
				L("      end")
				L("    elseif " .. n("op") .. "==" .. OP.SETLIST .. " then")
				L("      local " .. n("slbase") .. "=(" .. n("C") .. "-1)*50")
				L(
					"      for "
						.. n("sli")
						.. "=1,"
						.. n("B")
						.. " do "
						.. n("regs")
						.. "["
						.. n("A")
						.. "]["
						.. n("slbase")
						.. "+"
						.. n("sli")
						.. "]="
						.. n("regs")
						.. "["
						.. n("A")
						.. "+"
						.. n("sli")
						.. "] end"
				)
				L("    elseif " .. n("op") .. "==" .. OP.CLOSURE .. " then")
				L("      local " .. n("sub") .. "=" .. n("P") .. "[" .. n("B") .. "+1]")
				L("      local " .. n("cenv") .. "=" .. n("env") .. ";" .. "local " .. n("cupvs") .. "=" .. n("upvs"))
				L("      " .. n("regs") .. "[" .. n("A") .. "]=function(...)")
				L("        return " .. n("exec") .. "(" .. n("sub") .. "," .. n("cenv") .. "," .. n("cupvs") .. ",...)")
				L("      end")
				L("    elseif " .. n("op") .. "==" .. OP.VARARG .. " then")
				L("      local " .. n("vcnt") .. "=" .. n("B") .. "==0 and #" .. n("vargs") .. " or " .. n("B") .. "-1")
				L(
					"      for "
						.. n("vi")
						.. "=1,"
						.. n("vcnt")
						.. " do "
						.. n("regs")
						.. "["
						.. n("A")
						.. "+"
						.. n("vi")
						.. "-1]="
						.. n("vargs")
						.. "["
						.. n("vi")
						.. "] end"
				)
				L("    elseif " .. n("op") .. "==" .. OP.CLOSE .. " then")
				L("      -- upvalues are table refs; no explicit close needed")
				L("    end")
				L("  end")
				L("end")
				L("local " .. n("scriptEnv") .. "=(getfenv and getfenv(1) or (function() return _ENV end)())")
				L(n("exec") .. "(" .. n("proto") .. "," .. n("scriptEnv") .. ",{})")
				return table.concat(lines, "\n")
			end
			function HerculesVM:apply(ast, pipeline)
				local shuffle = (self.ShuffleOpcodes ~= false)
				local xorKey = (self.XorKey and self.XorKey > 0) and self.XorKey or math.random(1, 254)
				local opcodeMap = {}
				local encodeMap = {}
				if shuffle then
					local wires = {}
					for i = 0, 37 do
						wires[i + 1] = i
					end
					for i = #wires, 2, -1 do
						local j = math.random(1, i)
						wires[i], wires[j] = wires[j], wires[i]
					end
					for canon = 0, 37 do
						local wire = wires[canon + 1]
						opcodeMap[wire] = canon
						encodeMap[canon] = wire
					end
				else
					for i = 0, 37 do
						opcodeMap[i] = i
						encodeMap[i] = i
					end
				end
				local Unparser = _ZukOfficial.k()
				local Enums = _ZukOfficial.g()
				local unparser = Unparser:new({ LuaVersion = Enums.LuaVersion.Lua51, PrettyPrint = false })
				local source = unparser:unparse(ast)
				local fn, compErr = tryLoadstring(source)
				if not fn then
					logger:warn("HerculesVM: source failed to load (" .. tostring(compErr) .. "), skipping step")
					return ast
				end
				local wrapProto = {
					params = 0,
					is_vararg = true,
					max_stack = 16,
					nups = 0,
					consts = { "loadstring", source },
					protos = {},
					code = {
						{ OP.GETGLOBAL, 0, 0, 0 },
						{ OP.LOADK,     1, 1, 0 },
						{ OP.CALL,      0, 2, 2 },
						{ OP.VARARG,    1, 0, 0 },
						{ OP.CALL,      0, 0, 1 },
						{ OP.RETURN,    0, 1, 0 },
					},
				}
				local rawBlob = serialiseProto(wrapProto, encodeMap)
				local xored = {}
				for i = 1, #rawBlob do
					xored[i] = string.char(bxor8(rawBlob:byte(i), xorKey))
				end
				local blobStr = table.concat(xored)
				local vmSource = buildVM(blobStr, xorKey, opcodeMap, shuffle)
				local Parser = _ZukOfficial.j()
				local newAst = Parser:new({ LuaVersion = Enums.LuaVersion.Lua51 }):parse(vmSource)
				return newAst
			end
			return HerculesVM
		end
		function _ZukOfficial.B3()
			local v = _ZukOfficial.cache.B3
			if not v then
				v = { c = __modImpl() }
				_ZukOfficial.cache.B3 = v
			end
			return v.c
		end
	end
	do
		local function __modImpl()
			return {
				EncryptStrings = _ZukOfficial.r(),
				SplitStrings = _ZukOfficial.s(),
				AntiTamper = _ZukOfficial.t(),
				DynamicXOR = _ZukOfficial.u(),
				DynamicDecrypt = _ZukOfficial.v(),
				DynamicJumps = _ZukOfficial.w(),
				ConstantsObfuscator = _ZukOfficial.x(),
				NumbersToExpressions = _ZukOfficial.y(),
				OpaquePredicates = _ZukOfficial.z(),
				Vmify = _ZukOfficial.C(),
				StatementFlattener = _ZukOfficial.D(),
				AntiDump = _ZukOfficial.E(),
				VirtualGlobals = _ZukOfficial.F(),
				FakeLoopWrap = _ZukOfficial.G(),
				WrapInFunction = _ZukOfficial.H(),
				Compressor = _ZukOfficial.I(),
				DeadCodeEliminator = _ZukOfficial.J(),
				BootstrapObfuscator = _ZukOfficial.P(),
				VmifyBC = _ZukOfficial.S(),
				PolyStringEncode = _ZukOfficial.T2(),
				IdentifierSoup = _ZukOfficial.U2(),
				DeadCodeInjector = _ZukOfficial.V2(),
				ControlFlowObfuscator = _ZukOfficial.W2(),
				FakeBlob = _ZukOfficial.X2(),
				TableObfuscator = _ZukOfficial.Y2(),
				LocalsToUpvalues = _ZukOfficial.Z2(),
				StringRotate = _ZukOfficial.A3(),
				HerculesVM = _ZukOfficial.B3(),
			}
		end
		function _ZukOfficial.K()
			local v = _ZukOfficial.cache.K
			if not v then
				v = { c = __modImpl() }
				_ZukOfficial.cache.K = v
			end
			return v.c
		end
	end
	do
		local function __modImpl()
			local config = _ZukOfficial.a()
			local Ast = _ZukOfficial.b()
			local Enums = _ZukOfficial.g()
			local util = _ZukOfficial.f()
			local Parser = _ZukOfficial.j()
			local Unparser = _ZukOfficial.k()
			local logger = _ZukOfficial.d()
			local NameGenerators = _ZukOfficial.m()
			local Steps = _ZukOfficial.K()
			local lookupify = util.lookupify
			local LuaVersion = Enums.LuaVersion
			local AstKind = Ast.AstKind
			local _winplatform = package
				and package.config
				and type(package.config) == "string"
				and package.config:sub(1, 1) == "\\"
			local gettime
			if _winplatform then
				gettime = os.clock
			else
				local _socketOk = pcall(function()
					local socket = require("socket")
					gettime = socket.gettime
				end)
				if not _socketOk or not gettime then
					gettime = os.time
				end
			end
			local Pipeline = {
				NameGenerators = NameGenerators,
				Steps = Steps,
				DefaultSettings = {
					LuaVersion = LuaVersion.LuaU,
					PrettyPrint = false,
					Seed = math.random(1, 2 ^ 31 - 1),
					VarNamePrefix = "",
				},
			}
			Pipeline.__index = Pipeline
			local function resolveConventions(luaVersion)
				local conventions = Enums.Conventions[luaVersion]
				if not conventions then
					logger:error(
						string.format(
							'The Lua version "%s" is not recognised. Valid versions: "%s"',
							luaVersion,
							table.concat(util.keys(Enums.Conventions), '", "')
						)
					)
				end
				return conventions
			end
			function Pipeline:new(settings)
				settings = settings or {}
				local luaVersion = settings.luaVersion or settings.LuaVersion or Pipeline.DefaultSettings.LuaVersion
				local conventions = resolveConventions(luaVersion)
				local prettyPrint = settings.PrettyPrint or Pipeline.DefaultSettings.PrettyPrint
				local prefix = settings.VarNamePrefix or Pipeline.DefaultSettings.VarNamePrefix
				local seed = settings.Seed or Pipeline.DefaultSettings.Seed
				local pipeline = setmetatable({
					LuaVersion = luaVersion,
					PrettyPrint = prettyPrint,
					VarNamePrefix = prefix,
					Seed = seed,
					conventions = conventions,
					steps = {},
					namegenerator = nil,
					parser = Parser:new({ LuaVersion = luaVersion }),
					unparser = Unparser:new({
						LuaVersion = luaVersion,
						PrettyPrint = prettyPrint,
						Highlight = settings.Highlight,
					}),
				}, self)
				return pipeline
			end
			function Pipeline:fromConfig(cfg)
				cfg = cfg or {}
				local pipeline = Pipeline:new({
					LuaVersion = cfg.LuaVersion or LuaVersion.Lua51,
					PrettyPrint = cfg.PrettyPrint or false,
					VarNamePrefix = cfg.VarNamePrefix or "",
					Seed = cfg.Seed and cfg.Seed > 0 and cfg.Seed or math.random(1, 2 ^ 31 - 1),
				})
				pipeline:setNameGenerator(cfg.NameGenerator or "Mangled")
				for _, step in ipairs(cfg.Steps or {}) do
					if type(step.Name) ~= "string" then
						logger:error("Step.Name must be a string")
					end
					local constructor = pipeline.Steps[step.Name]
					if not constructor then
						logger:error(string.format('Step "%s" was not found!', step.Name))
					end
					pipeline:addStep(constructor:new(step.Settings or {}))
				end
				return pipeline
			end
			function Pipeline:addStep(step)
				table.insert(self.steps, step)
			end
			function Pipeline:resetSteps()
				self.steps = {}
			end
			function Pipeline:getSteps()
				return self.steps
			end
			function Pipeline:setOption(name, value)
				if Pipeline.DefaultSettings[name] ~= nil then
					self[name] = value
				else
					logger:error(string.format('"%s" is not a valid pipeline option', tostring(name)))
				end
			end
			function Pipeline:setLuaVersion(luaVersion)
				local conventions = resolveConventions(luaVersion)
				self.conventions = conventions
				self.parser = Parser:new({ LuaVersion = luaVersion })
				self.unparser = Unparser:new({ LuaVersion = luaVersion })
				self.LuaVersion = luaVersion
			end
			function Pipeline:getLuaVersion()
				return self.LuaVersion
			end
			function Pipeline:setNameGenerator(nameGenerator)
				if type(nameGenerator) == "string" then
					local resolved = Pipeline.NameGenerators[nameGenerator]
					if not resolved then
						local available = {}
						for k in pairs(Pipeline.NameGenerators) do
							available[#available + 1] = k
						end
						table.sort(available)
						logger:error(
							string.format(
								'NameGenerator "%s" not found. Available: %s',
								nameGenerator,
								table.concat(available, ", ")
							)
						)
					end
					nameGenerator = resolved
				end
				if type(nameGenerator) == "function" or type(nameGenerator) == "table" then
					self.namegenerator = nameGenerator
				else
					logger:error("setNameGenerator: argument must be a generator name string or generator table")
				end
			end
			function Pipeline:apply(code, filename)
				local startTime = gettime()
				filename = filename or "Anonymous Script"
				logger:info(string.format("Processing %s ...", filename))
				math.randomseed(self.Seed > 0 and self.Seed or os.time())
				logger:info("Parsing ...")
				local parserStart = gettime()
				local sourceLen = #code
				local ast = self.parser:parse(code)
				logger:info(string.format("Parsing done in %.2f seconds", gettime() - parserStart))
				for _, step in ipairs(self.steps) do
					local stepStart = gettime()
					logger:info(string.format("Step: %s", step.Name or "unnamed"))
					local newAst = step:apply(ast, self)
					if type(newAst) == "table" then
						ast = newAst
					end
					logger:info(string.format("Step done in %.2f seconds", gettime() - stepStart))
				end
				self:renameVariables(ast)
				code = self:unparse(ast)
				local postPasses = {
					{ field = "_varRenamerStep", label = "VariableRenamer", fn = "process" },
					{ field = "_bytecodeEncoderStep", label = "BytecodeEncoder", fn = "process" },
				}
				for _, pass in ipairs(postPasses) do
					local step = self[pass.field]
					if step then
						logger:info(string.format("Running %s post-pass ...", pass.label))
						code = step[pass.fn](step, code)
						logger:info(string.format("%s done.", pass.label))
					end
				end
				local compressionPasses = {
					{ field = "_compressorStep", label = "Compressor", fn = "compressSource" },
					{ field = "_blobCompressStep", label = "BlobCompress", fn = "compressSource" },
				}
				for _, pass in ipairs(compressionPasses) do
					local step = self[pass.field]
					if step then
						logger:info(string.format("Running %s post-pass ...", pass.label))
						local preLen = #code
						code = step[pass.fn](step, code)
						logger:info(
							string.format(
								"%s: %.1f%% → %.1f%% of input",
								pass.label,
								(preLen / sourceLen) * 100,
								(#code / sourceLen) * 100
							)
						)
					end
				end
				local formatPasses = {
					{ field = "_crewmateFormatStep", label = "CrewmateFormat", fn = "process" },
					{ field = "_zalgoStep", label = "ZukaZalgo", fn = "process" },
				}
				for _, pass in ipairs(formatPasses) do
					local step = self[pass.field]
					if step then
						logger:info(string.format("Running %s post-pass ...", pass.label))
						code = step[pass.fn](step, code)
						logger:info(string.format("%s done.", pass.label))
					end
				end
				local elapsed = gettime() - startTime
				logger:info(string.format("Done in %.2f seconds", elapsed))
				logger:info(string.format("Output is %.2f%% of input size", (#code / sourceLen) * 100))
				return code
			end
			function Pipeline:unparse(ast)
				local startTime = gettime()
				logger:info("Generating output ...")
				local unparsed = self.unparser:unparse(ast)
				logger:info(string.format("Output generated in %.2f seconds", gettime() - startTime))
				return unparsed
			end
			function Pipeline:renameVariables(ast)
				local startTime = gettime()
				logger:info("Renaming ...")
				local generatorFunction = self.namegenerator or Pipeline.NameGenerators.Mangled
				if type(generatorFunction) == "table" then
					if type(generatorFunction.prepare) == "function" then
						generatorFunction.prepare(ast)
					end
					generatorFunction = generatorFunction.generateName
				end
				local prefix = self.VarNamePrefix
				if #prefix ~= 0 and not self.unparser:isValidIdentifier(prefix) then
					logger:error(
						string.format('The prefix "%s" is not a valid identifier in %s', prefix, self.LuaVersion)
					)
				end
				ast.globalScope:renameVariables({
					Keywords = self.conventions.Keywords,
					generateName = generatorFunction,
					prefix = prefix,
				})
				logger:info(string.format("Renaming done in %.2f seconds", gettime() - startTime))
			end
			return Pipeline
		end
		function _ZukOfficial.L()
			local v = _ZukOfficial.cache.L
			if not v then
				v = { c = __modImpl() }
				_ZukOfficial.cache.L = v
			end
			return v.c
		end
	end
	do
		local function __modImpl()
			local Tokenizer = _ZukOfficial.h()
			local colors = _ZukOfficial.c()
			local TokenKind = Tokenizer.TokenKind
			local lookupify = _ZukOfficial.f().lookupify
			return function(code, luaVersion)
				local out = ""
				local tokenizer = Tokenizer:new({
					LuaVersion = luaVersion,
				})
				tokenizer:append(code)
				local tokens = tokenizer:scanAll()
				local nonColorSymbols = lookupify({
					",",
					";",
					"(",
					")",
					"{",
					"}",
					".",
					":",
					"[",
					"]",
				})
				local defaultGlobals = lookupify({
					"string",
					"table",
					"bit32",
					"bit",
				})
				local currentPos = 1
				for _, token in ipairs(tokens) do
					if token.startPos >= currentPos then
						out = out .. string.sub(code, currentPos, token.startPos)
					end
					if token.kind == TokenKind.Ident then
						if defaultGlobals[token.source] then
							out = out .. colors(token.source, "red")
						else
							out = out .. token.source
						end
					elseif token.kind == TokenKind.Keyword then
						if token.source == "nil" then
							out = out .. colors(token.source, "cyan")
						else
							out = out .. colors(token.source, "yellow")
						end
					elseif token.kind == TokenKind.Symbol then
						if nonColorSymbols[token.source] then
							out = out .. token.source
						else
							out = out .. colors(token.source, "yellow")
						end
					elseif token.kind == TokenKind.String then
						out = out .. colors(token.source, "green")
					elseif token.kind == TokenKind.Number then
						out = out .. colors(token.source, "red")
					else
						out = out .. token.source
					end
					currentPos = token.endPos + 1
				end
				return out
			end
		end
		function _ZukOfficial.M()
			local v = _ZukOfficial.cache.M
			if not v then
				v = { c = __modImpl() }
				_ZukOfficial.cache.M = v
			end
			return v.c
		end
	end
	do
		local function __modImpl()
			return {
				["Luraph"] = {
					LuaVersion = "Lua51",
					VarNamePrefix = "",
					NameGenerator = "AN",
					PrettyPrint = false,
					Seed = 0,
					Steps = {
						{ Name = "SplitStrings", Settings = {} },
						{ Name = "PolyStringEncode", Settings = { Threshold = 0.75, MinLength = 2 } },
						{
							Name = "ConstantsObfuscator",
							Settings = {
								ObfuscateNumbers = true,
								ObfuscateStrings = true,
								MockStringChance = 18,
								MinAbsValue = 9,
							},
						},
						{ Name = "NumbersToExpressions", Settings = { Treshold = 0.8, InternalTreshold = 0.4 } },
						{ Name = "AntiTamper", Settings = { UseDebug = false } },
						{ Name = "DeadCodeInjector", Settings = { Threshold = 0.65, MaxInjections = 30 } },
						{ Name = "ControlFlowObfuscator", Settings = { Threshold = 0.45 } },
						{ Name = "OpaquePredicates", Settings = { Treshold = 0.85, InjectionsPerBlock = 2 } },
						{ Name = "DynamicDecrypt", Settings = { Threshold = 0.7, Rounds = 4 } },
						{
							Name = "DynamicJumps",
							Settings = { Threshold = 0.80, PoolSize = 64, MinStatements = 2 },
						},
						{
							Name = "StatementFlattener",
							Settings = { FlattenIf = true, FlattenFunctions = true, Threshold = 0.60 },
						},
						{ Name = "IdentifierSoup", Settings = { Style = "cyrMixed", MinLength = 6, MaxLength = 12 } },
						{ Name = "Vmify", Settings = { OptimizationLevel = 2 } },
						{ Name = "EncryptStrings", Settings = {} },
						{ Name = "AntiDump", Settings = { GCInterval = 50 } },
						{ Name = "VirtualGlobals", Settings = { Treshold = 1, UseNumericKeys = true } },
						{ Name = "FakeLoopWrap", Settings = { Treshold = 0.35 } },
						{
							Name = "FakeBlob",
							Settings = { Placement = "after", BlobSize = 912, FakeOpcodeCount = 28 },
						},
						{ Name = "WrapInFunction", Settings = {} },
						{ Name = "Compressor", Settings = { MinLength = 10 } },
					},
					Hercules = nil,
				},
				["Hercules"] = {
					LuaVersion = "Lua51",
					VarNamePrefix = "",
					NameGenerator = "Chaotic",
					PrettyPrint = false,
					Seed = 0,
					Steps = {
						{ Name = "HerculesVM", Settings = { ShuffleOpcodes = true, XorKey = 0 } },
						{ Name = "WrapInFunction", Settings = {} },
					},
					Hercules = nil,
				},
				["byte"] = {
					LuaVersion = "LuaU",
					VarNamePrefix = "",
					NameGenerator = "Chaotic",
					PrettyPrint = false,
					Seed = 0,
					Steps = {
						{
							Name = "VmifyBC",
							Settings = { XorKey = 0, ShuffleOpcodes = true },
						},
						{ Name = "WrapInFunction", Settings = {} },
					},
					Hercules = nil,
				},
				["Maximum"] = {
					LuaVersion = "Lua51",
					VarNamePrefix = "",
					NameGenerator = "Chaotic",
					PrettyPrint = false,
					Seed = 0,
					Steps = {
						{ Name = "SplitStrings", Settings = {} },
						{ Name = "PolyStringEncode", Settings = { Threshold = 0.95, MinLength = 1 } },
						{
							Name = "ConstantsObfuscator",
							Settings = {
								ObfuscateNumbers = true,
								ObfuscateStrings = true,
								MockStringChance = 12,
								MinAbsValue = 2,
							},
						},
						{ Name = "NumbersToExpressions", Settings = { Treshold = 0.95, InternalTreshold = 0.6 } },
						{ Name = "AntiTamper", Settings = { UseDebug = false } },
						{ Name = "DeadCodeInjector", Settings = { Threshold = 0.50, MaxInjections = 80 } },
						{ Name = "ControlFlowObfuscator", Settings = { Threshold = 0.75 } },
						{ Name = "OpaquePredicates", Settings = { Treshold = 0.95, InjectionsPerBlock = 3 } },
						{ Name = "DynamicDecrypt", Settings = { Threshold = 0.9, Rounds = 6 } },
						{
							Name = "DynamicJumps",
							Settings = { Threshold = 0.95, PoolSize = 128, MinStatements = 1 },
						},
						{
							Name = "StatementFlattener",
							Settings = { FlattenIf = true, FlattenFunctions = true, Threshold = 0.85 },
						},
						{ Name = "FakeLoopWrap", Settings = { Treshold = 0.60 } },
						{ Name = "IdentifierSoup", Settings = { Style = "mixed", MinLength = 8, MaxLength = 16 } },
						{ Name = "BootstrapObfuscator", Settings = { StatementsPerState = 2, AddJunkState = true } },
						{ Name = "Vmify", Settings = { OptimizationLevel = 2 } },
						{ Name = "EncryptStrings", Settings = {} },
						{ Name = "AntiDump", Settings = { GCInterval = 80 } },
						{ Name = "VirtualGlobals", Settings = { Treshold = 1, UseNumericKeys = true } },
						{
							Name = "FakeBlob",
							Settings = { Placement = "sandwich", BlobSize = 768, FakeOpcodeCount = 40 },
						},
						{ Name = "WrapInFunction", Settings = { Iterations = 1 } },
						{
							Name = "DeadCodeEliminator",
							Settings = {
								EliminateJunkLocals = true,
								EliminateDeadIf = true,
								FoldIdentities = true,
								EliminateEmptyDo = true,
							},
						},
						{ Name = "Compressor", Settings = { MinLength = 1 } },
					},
					Hercules = nil,
				},
			}
		end
		function _ZukOfficial.N()
			local v = _ZukOfficial.cache.N
			if not v then
				v = { c = __modImpl() }
				_ZukOfficial.cache.N = v
			end
			return v.c
		end
	end
	do
		local function __modImpl()
			if not pcall(function()
				return math.random(1, 2 ^ 40)
			end) then
				local oldMathRandom = math.random
				math.random = function(a, b)
					if not a and b then
						return oldMathRandom()
					end
					if not b then
						return math.random(1, a)
					end
					if a > b then
						a, b = b, a
					end
					local diff = b - a
					assert(diff >= 0)
					if diff > 2 ^ 31 - 1 then
						return math.floor(oldMathRandom() * diff + a)
					else
						return oldMathRandom(a, b)
					end
				end
			end
			_G.newproxy = _G.newproxy
				or function(arg)
					if arg then
						return setmetatable({}, {})
					end
					return {}
				end
			local Pipeline = _ZukOfficial.L()
			local highlight = _ZukOfficial.M()
			local colors = _ZukOfficial.c()
			local Logger = _ZukOfficial.d()
			local Presets = _ZukOfficial.N()
			local Config = _ZukOfficial.a()
			local util = _ZukOfficial.f()
			return {
				Pipeline = Pipeline,
				colors = colors,
				Config = util.readonly(Config),
				Logger = Logger,
				highlight = highlight,
				Presets = Presets,
			}
		end
		function _ZukOfficial.O()
			local v = _ZukOfficial.cache.O
			if not v then
				v = { c = __modImpl() }
				_ZukOfficial.cache.O = v
			end
			return v.c
		end
	end
end
local ZukaTech = _ZukOfficial.O()
local LUAU_SIGNALS = {
	"compound assignment",
	"continue",
	"type annotation",
	"interpolated string",
}
local function detectLuaVersion(source)
	local stripped = source:gsub("%-%-[^\n]*", ""):gsub('"[^"\\]*"', '""'):gsub("'[^'\\]*'", "''")
	local luauPatterns = {
		"[%+%-%*%/%^%%]%s*=",
		"%.%.%s*=",
		"%bcontinue%b  ",
		"::%s*[%a_]",
		"`",
	}
	for _, pat in ipairs(luauPatterns) do
		if stripped:find(pat) then
			return "LuaU"
		end
	end
	local Enums = _ZukOfficial.g()
	local Parser = _ZukOfficial.j()
	local ok, err = pcall(function()
		Parser:new({ LuaVersion = Enums.LuaVersion.Lua51 }):parse(source)
	end)
	if not ok then
		local msg = tostring(err):lower()
		for _, signal in ipairs(LUAU_SIGNALS) do
			if msg:find(signal, 1, true) then
				return "LuaU"
			end
		end
		return nil, err
	end
	return "Lua51"
end
if arg and arg[0] then
	local inputFile = arg[1]
	local presetName = arg[2] and (arg[2]:sub(1, 1) ~= "-") and arg[2] or "Luraph"
	local outputFile = arg[2] and (arg[2]:sub(1, 1) ~= "-") and arg[3] or arg[2]
	local Presets2 = _ZukOfficial.N()
	if not Presets2[presetName] then
		io.stderr:write("Error: unknown preset '" .. presetName .. "'. Available: ")
		local names = {}
		for k in pairs(Presets2) do
			names[#names + 1] = k
		end
		table.sort(names)
		io.stderr:write(table.concat(names, ", ") .. "\n")
		os.exit(1)
	end
	if not inputFile then
		io.stderr:write("Usage: lua main.lua <input.lua> [preset] [output.lua]\n")
		io.stderr:write("Presets: Luraph (default), byte\n")
		os.exit(1)
	end
	local fh, err = io.open(inputFile, "r")
	if not fh then
		io.stderr:write("Error: cannot open '" .. inputFile .. "': " .. tostring(err) .. "\n")
		os.exit(1)
	end
	local source = fh:read("*a")
	fh:close()
	local detectedVersion, detectionErr = detectLuaVersion(source)
	if not detectedVersion then
		io.stderr:write(
			"Parse error (Lua51 mode): "
				.. tostring(detectionErr)
				.. "\n"
				.. "Hint: if your script uses Luau syntax, this may be a genuine syntax error.\n"
		)
		os.exit(1)
	end
	local Enums = _ZukOfficial.g()
	local luaVersion = Enums.LuaVersion[detectedVersion]
	local preset = {}
	for k, v in pairs(ZukaTech.Presets[presetName]) do
		preset[k] = v
	end
	preset.LuaVersion = detectedVersion
	local pipeline = ZukaTech.Pipeline:fromConfig(preset)
	pipeline:setLuaVersion(luaVersion)
	io.stderr:write(string.format("ZUKATECH: Detected syntax: %s\n", detectedVersion))
	local MAX_ATTEMPTS = 3
	local function runSanityCheck(originalSrc, obfuscatedSrc)
		local ok1, err1
		if loadstring then
			ok1, err1 = pcall(loadstring, obfuscatedSrc)
		else
			ok1, err1 = pcall(load, obfuscatedSrc)
		end
		if not ok1 then
			return false, "load error: " .. tostring(err1)
		end
		if #obfuscatedSrc < (#originalSrc * 0.10) then
			return false,
				string.format("output suspiciously small (%.1f%% of input)", (#obfuscatedSrc / #originalSrc) * 100)
		end
		return true, nil
	end
	local finalResult
	local lastErr
	local attempts = 0
	local success = false
	repeat
		attempts = attempts + 1
		local retrySeed = math.random(1, 2 ^ 31 - 1)
		local retryPreset = {}
		for k, v in pairs(ZukaTech.Presets[presetName]) do
			retryPreset[k] = v
		end
		retryPreset.LuaVersion = detectedVersion
		retryPreset.Seed = retrySeed
		local Enums2 = _ZukOfficial.g()
		local retryPipeline = ZukaTech.Pipeline:fromConfig(retryPreset)
		retryPipeline:setLuaVersion(Enums2.LuaVersion[detectedVersion])
		local ok, result = pcall(function()
			return retryPipeline:apply(source, inputFile)
		end)
		if not ok then
			lastErr = tostring(result)
			io.stderr:write(
				string.format(
					"ZUKATECH: Attempt %d/%d failed (obfuscation error): %s\n",
					attempts,
					MAX_ATTEMPTS,
					lastErr
				)
			)
		else
			local sane, sanityErr = runSanityCheck(source, result)
			if sane then
				finalResult = result
				success = true
			else
				lastErr = sanityErr
				io.stderr:write(
					string.format(
						"ZUKATECH: Attempt %d/%d failed (sanity check): %s — retrying...\n",
						attempts,
						MAX_ATTEMPTS,
						lastErr
					)
				)
			end
		end
	until success or attempts >= MAX_ATTEMPTS
	if not success then
		io.stderr:write(
			string.format("ZUKATECH: All %d attempts failed. Last error: %s\n", MAX_ATTEMPTS, tostring(lastErr))
		)
		os.exit(1)
	end
	if attempts > 1 then
		io.stderr:write(string.format("ZUKATECH: Succeeded on attempt %d/%d\n", attempts, MAX_ATTEMPTS))
	end
	if outputFile then
		local out = assert(io.open(outputFile, "w"))
		out:write(finalResult)
		out:close()
	else
		io.write(finalResult)
	end
	os.exit(0)
end
return ZukaTech