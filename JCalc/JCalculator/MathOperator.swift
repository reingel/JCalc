//
//  MathOperator.swift
//  JCalc
//
//  Created by Soonkyu Jeong on 2019/06/26.
//  Copyright © 2019 Soonkyu Jeong. All rights reserved.
//

typealias OperatorPriority = UInt8

enum MathOperator {
    case leftParenthesis, rightParenthesis
    case power
    case multiplication, division
    case addition, subtraction
    
    var priority: OperatorPriority {
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
