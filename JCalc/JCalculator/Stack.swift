//
//  Stack.swift
//  JCalc
//
//  Created by Soonkyu Jeong on 2019/06/18.
//  Copyright © 2019 Soonkyu Jeong. All rights reserved.
//

struct Stack<T> {
	var array = [T]()
	var count: Int {
		return array.count
	}
	var isEmpty: Bool {
		return array.isEmpty
	}
	
	mutating func push(_ item: T) {
		array.append(item)
	}
	mutating func pop() -> T? {
		if isEmpty {
			return nil
		} else {
			let item = array[array.endIndex - 1]
			array.remove(at: array.endIndex - 1)
			return item
		}
	}
}
