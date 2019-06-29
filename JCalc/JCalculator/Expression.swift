//
//  Expression.swift
//  JCalc
//
//  Created by Soonkyu Jeong on 2019/06/24.
//  Copyright © 2019 Soonkyu Jeong. All rights reserved.
//

import Foundation

enum Error {
	case noError
	case invalidExpression(Location)
	case divisionByZero(Location)
}

typealias Whitespace = String
typealias NumericValue = Double

enum MathObject {
	case whitespace(Whitespace)
	case numeric(NumericValue)
	case physical(PhysicalValue)
	case unit(Unit)
	case mathOperator(MathOperator)
	//    case function(Function)
	//    case variable(Variable)
	
	var isNotWhitespace: Bool {
		switch self {
		case .whitespace: return false
		default: return true
		}
	}
	var isNotNumeric: Bool {
		switch self {
		case .numeric: return false
		default: return true
		}
	}
	var isNotPhysical: Bool {
		switch self {
		case .physical: return false
		default: return true
		}
	}
	var isNotUnit: Bool {
		switch self {
		case .unit: return false
		default: return true
		}
	}
	var isNotOperator: Bool {
		switch self {
		case .mathOperator: return false
		default: return true
		}
	}
	var isOperator: Bool { !isNotOperator }
	
	var description: String {
		switch self {
		case .whitespace(let s):
			return s
		case .numeric(let value):
			return String(value)
		case .mathOperator(let op):
			return mathOperators[op]!
		default:
			return ""
		}
	}
}

typealias Location = Int

struct Expression {
	var objects = [MathObject]()
	var locations = [Location]()
	
	var stack = Stack<MathObject>()
	var queue = Queue<MathObject>()
	
	// placed outside of parse() to speed up parsing
	let whitespaceRegex = try? NSRegularExpression(pattern: #"^[ \t]"#)
	let numericRegex = try? NSRegularExpression(pattern: #"^[+-]?(\d+(\.\d+)?|\.\d+)([eE][+-]?\d+)?"#)
	let unitRegex = try? NSRegularExpression(pattern: #"^[a-zA-Z]+(([*/][a-zA-Z]+)|(\^-?\d+))*"#)
	let operatorRegex = try? NSRegularExpression(pattern: #"^[\(\)^\*\/+\-]"#)
	let functionRegex = try? NSRegularExpression(pattern: #"^[a-zA-Z_][a-zA-Z0-9_]*\("#)
	let variableRegex = try? NSRegularExpression(pattern: #"^[a-zA-Z_][a-zA-Z0-9_]*"#)
	
	mutating func parse(_ string: String) -> Bool {
		var objectRange: StringRange = 0..<0
		var remainRange: StringRange = 0..<string.count
		var object: MathObject?
		var previous: MathObject = MathObject.whitespace(" ")
		while !remainRange.isEmpty {
			object = nil
			if previous.isNotWhitespace {
				if let match = whitespaceRegex?.firstMatch(in: string, range: NSRange(remainRange)) {
					objectRange = StringRange(match.range)
					let value = string[objectRange]
					object = MathObject.whitespace(value)
				}
			}
			if previous.isNotNumeric && object == nil {
				if let match = numericRegex?.firstMatch(in: string, range: NSRange(remainRange)) {
					objectRange = StringRange(match.range)
					let value = NumericValue(string[objectRange])!
					object = MathObject.numeric(value)
				}
			}
			if previous.isNotOperator && object == nil { // binary operator
				if let match = operatorRegex?.firstMatch(in: string, range: NSRange(remainRange)) {
					objectRange = StringRange(match.range)
					let value = mathOperators[string[objectRange]]!
					object = MathObject.mathOperator(value)
				}
			}
			if previous.isOperator && object == nil { // unary operator
			}
			
			if object != nil {
				objects.append(object!)
				locations.append(objectRange.lowerBound)
				remainRange.removeFirst(objectRange.width)
				previous = object!
			} else {
				locations.append(objectRange.upperBound) // error location
				return false
			}
		}
		return true
	}

	mutating func infixToPostfix() -> Bool {
		for object in objects {
			switch object {
			case .whitespace:
				break
			case .numeric:
				queue.push(object)
			case .physical:
				queue.push(object)
			case .unit:
				break
			case let .mathOperator(mathOperator):
				let priority = mathOperator.priority
				compareLoop: while true {
					if let poppedObject = stack.pop() {
						switch poppedObject {
						case let .mathOperator(poppedOperator):
							let poppedPriority = poppedOperator.priority
							if poppedPriority >= priority {
								queue.push(poppedObject)
							} else {
								stack.push(poppedObject)
								stack.push(object)
								break compareLoop
							}
						default:
							break compareLoop
						}
					} else {
						stack.push(object)
						break compareLoop
					}
				}
			}
		}
		// pop every operators in stack
		popAll: while true {
			if let poppedObject = stack.pop() {
				queue.push(poppedObject)
			} else {
				break popAll
			}
		}
		
		return true
	}

	mutating func evaluate(_ string: String) -> String {
		guard parse(string) else {
			return "Syntax error"
		}
		guard infixToPostfix() else {
			return "Internal error"
		}
		
		calcLoop: while true {
			if let poppedObject = queue.pop() {
				print(poppedObject.description)
				
				switch poppedObject {
				case .whitespace:
					break
				case .numeric:
					stack.push(poppedObject)
				case let .physical(value):
					break
				case let .unit(unit):
					break
				case let .mathOperator(mathOperator):
					var lhs = 0.0
					var rhs = 0.0
					if let rightOperand = stack.pop() {
						switch rightOperand {
						case let .numeric(value):
							rhs = value
						default:
							break calcLoop
						}
					} else {
						return "Stack is empty while popping right operand."
					}
					if let leftOperand = stack.pop() {
						switch leftOperand {
						case let .numeric(value):
							lhs = value
						default:
							break calcLoop
						}
					} else {
						return "Stack is empty while popping left operand."
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
					stack.push(MathObject.numeric(ans))
				}
			} else {
				break calcLoop
			}
		}
		
		var ans = 0.0
		switch stack.pop()! {
		case let .numeric(value):
			ans = value
		default:
			break
		}
		
		return String(ans)
	}
}
