//
//  MathOperator.swift
//  JCalc
//
//  Created by Soonkyu Jeong on 2019/06/26.
//  Copyright © 2019 Soonkyu Jeong. All rights reserved.
//

enum MathOperator: Comparable {
    case leftParenthesis, rightParenthesis
    case power
    case multiplication, division
    case addition, subtraction
	
	var priority: Int {
		switch self {
		case .leftParenthesis, .rightParenthesis:
			return 0
		case .addition, .subtraction:
			return 1
		case .multiplication, .division:
			return 2
		case .power:
			return 3
		}
	}
	
	static func < (lhs: MathOperator, rhs: MathOperator) -> Bool {
		return lhs.priority < rhs.priority
	}
	
	static func == (lhs: MathOperator, rhs: MathOperator) -> Bool {
		return lhs.priority == rhs.priority
	}
}

struct MathOperatorList {
    let mathOperators: [String: MathOperator] = [
        "(": .leftParenthesis,
        ")": .rightParenthesis,
        "^": .power,
        "*": .multiplication,
        "/": .division,
        "+": .addition,
        "-": .subtraction
    ]
    
    func contains(_ string: String) -> Bool { mathOperators[string] != nil }
    subscript (_ string: String) -> MathOperator? { mathOperators[string] }
	subscript (_ mathOperator: MathOperator) -> String? {
		for (key, value) in mathOperators {
			if mathOperator == value {
				return key
			}
		}
		return nil
	}
}

let mathOperators = MathOperatorList()
