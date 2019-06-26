//
//  Expression.swift
//  JCalc
//
//  Created by Soonkyu Jeong on 2019/06/24.
//  Copyright © 2019 Soonkyu Jeong. All rights reserved.
//

import Foundation

typealias ErrorRange = Range<Int>

enum Error {
	case noError
	case invalidExpression(ErrorRange)
	case divisionByZero(ErrorRange)
}

var error = Error.noError

enum Expression {
	case whitespace(String)
	case numeric(NumericValue)
	case physical(PhysicalValue)
	case unit(Unit)
	case mathOperator(MathOperator)
	//    case function(Function)
	//    case variable(Variable)
}

struct ExpressionWithRange {
	let expression: Expression
	let range: Range<Int>
	
	var description: String {
		switch expression {
		case let .whitespace(str):
			return ""
		case let .numeric(value):
			return String(value)
		case let .physical(value):
			return ""
		case let .unit(unit):
			return ""
		case let .mathOperator(mathOperator):
			return mathOperators[mathOperator]!
		}
	}
}

// generate regular expressions
let whitespaceRegex = try? NSRegularExpression(pattern: #"^[ \t]"#)
let numericRegex = try? NSRegularExpression(pattern: #"^[+-]?(\d+(\.\d+)?|\.\d+)([eE][+-]?\d+)?"#)
let unitRegex = try? NSRegularExpression(pattern: #"^[a-zA-Z]+(([*/][a-zA-Z]+)|(\^-?\d+))*"#)
let operatorRegex = try? NSRegularExpression(pattern: #"^[\(\)^\*\/+\-]"#)
let functionRegex = try? NSRegularExpression(pattern: #"^[a-zA-Z_][a-zA-Z0-9_]*\("#)
let variableRegex = try? NSRegularExpression(pattern: #"^[a-zA-Z_][a-zA-Z0-9_]*"#)

// generate converter closures
let makeUnitExpression = { (s: String) -> Expression? in
	if let unit = units[s] {
		return .unit(unit)
	} else {
		return nil
	}
}

let makeMathOperatorExpression = { (s: String) -> Expression? in
	if let mathOperator = mathOperators[s] {
		return .mathOperator(mathOperator)
	} else {
		return nil
	}
}

func firstMatchingExpression(in string: String, regex: NSRegularExpression, converter: (String) -> Expression?) -> (Expression, String)? {
	//    let string = string.trim()
	//    let trimLength = string.count - string.count
	let range = NSRange(location: 0, length: string.count)
	let matched = regex.firstMatch(in: string, range: range)
	if (matched != nil) {
		let length = matched!.range.length
		let s = String(string.prefix(length))
		guard let expression = converter(s) else {
			return nil
		}
		let newString = String(string.suffix(string.count - length))
		return (expression, newString)
	}
	return nil
}

func parse(_ string: String) -> [ExpressionWithRange] {
	error = .noError
	
	// parsing
	var expressions = [ExpressionWithRange]()
	
	var location = 0
	var remains = string
	while(remains.count > 0) {
		if let (expression, newRemains) = firstMatchingExpression(in: remains, regex: whitespaceRegex!, converter: { .whitespace($0) }) {
			let length = remains.count - newRemains.count
			let range = location ..< location + length
			let expressionWithRange = ExpressionWithRange(expression: expression, range: range)
			expressions.append(expressionWithRange)
			location += length
			remains = newRemains
		}
		else if let (expression, newRemains) = firstMatchingExpression(in: remains, regex: numericRegex!, converter: { .numeric(NumericValue($0)!) }) {
			let length = remains.count - newRemains.count
			let range = location ..< location + length
			let expressionWithRange = ExpressionWithRange(expression: expression, range: range)
			expressions.append(expressionWithRange)
			location += length
			remains = newRemains
		}
		else if let (expression, newRemains) = firstMatchingExpression(in: remains, regex: unitRegex!, converter: makeUnitExpression) {
			let length = remains.count - newRemains.count
			let range = location ..< location + length
			let expressionWithRange = ExpressionWithRange(expression: expression, range: range)
			expressions.append(expressionWithRange)
			location += length
			remains = newRemains
		}
		else if let (expression, newRemains) = firstMatchingExpression(in: remains, regex: operatorRegex!, converter: makeMathOperatorExpression) {
			let length = remains.count - newRemains.count
			let range = location ..< location + length
			let expressionWithRange = ExpressionWithRange(expression: expression, range: range)
			expressions.append(expressionWithRange)
			location += length
			remains = newRemains
		}
		else {
			error = .invalidExpression(location ..< location + 1)
			return expressions
		}
	}
	
	return expressions
}

func infixToPostfix(_ expressionWithRanges: [ExpressionWithRange]) -> Queue<ExpressionWithRange> {
	var stack = Stack<ExpressionWithRange>()
	var queue = Queue<ExpressionWithRange>()
	
	for expressionWithRange in expressionWithRanges {
		let expression = expressionWithRange.expression
		
		switch expression {
		case .whitespace:
			break
		case .numeric:
			queue.push(expressionWithRange)
		case .physical:
			queue.push(expressionWithRange)
		case .unit:
			break
			//            let mul = MathOperator.multiplication
			//            repeat {
			//                let item = stack.pop()
			//                if let expr = item?.expression {
			//                    switch expr {
			//                    case let .mathOperator(mathOperator):
			//                        if mul.priority >= mathOperator.priority {
			//                            queue.push(item!)
			//                        }
			//                    default:
			//                        break
			//                    }
			//                }
		//            } while (oper != nil)
		case let .mathOperator(mathOperator):
			let priority = mathOperator.priority
			var popped: ExpressionWithRange?
			loop: repeat {
				popped = stack.pop()
				if popped == nil {
					stack.push(expressionWithRange)
				} else {
					let expression = popped!.expression
					switch expression {
					case let .mathOperator(mathOperator):
						let poppedPriority = mathOperator.priority
						if poppedPriority >= priority {
							queue.push(popped!)
						} else {
							stack.push(popped!)
							stack.push(expressionWithRange)
							break loop
						}
					default:
						break loop
					}
				}
			} while (popped != nil)
		}
	}
	// pop every operators in stack
	var popped: ExpressionWithRange?
	repeat {
		popped = stack.pop()
		if popped != nil {
			queue.push(popped!)
		}
	} while (popped != nil)
	
	return queue
}

func evaluate(_ string: String) -> PhysicalValue {
	var stack = Stack<ExpressionWithRange>()
	
	let expressions = parse(string)
	var queue = infixToPostfix(expressions)
	
	var popped: ExpressionWithRange?
	repeat {
		popped = queue.pop()
		if popped != nil {
			print(popped!.description)
			
			let expression = popped!.expression
			let range = popped!.range
			
			switch expression {
			case let .whitespace(str):
				break
			case let .numeric(value):
				stack.push(popped!)
			case let .physical(value):
				break
			case let .unit(unit):
				break
			case let .mathOperator(mathOperator):
				var lhs = 0.0
				var rhs = 0.0
				let rightOperand = stack.pop()!.expression
				switch rightOperand {
				case let .numeric(value):
					rhs = value
				default:
					break
				}
				let leftOperand = stack.pop()!.expression
				switch leftOperand {
				case let .numeric(value):
					lhs = value
				default:
					break
				}
				var ans = 0.0
				switch mathOperator {
				case .power:
					ans = pow(lhs, rhs)
				case .multiplication:
					ans = lhs * rhs
				case .division:
					ans = lhs / rhs
				case .addition:
					ans = lhs + rhs
				case .subtraction:
					ans = lhs - rhs
				default:
					ans = -999
				}
				stack.push(ExpressionWithRange(expression: Expression.numeric(ans), range: range))
			}
		}
	} while popped != nil
	
	var ans = 0.0
	popped = stack.pop()
	let expr = popped!.expression
	switch expr {
	case let .numeric(value):
		ans = value
	default:
		break
	}
	
	return PhysicalValue(ans, .unitless)
}
