//
//  PhysicalValue.swift
//  JCalc
//
//  Created by Soonkyu Jeong on 2019/06/23.
//  Copyright © 2019 Soonkyu Jeong. All rights reserved.
//

struct PhysicalValue: Equatable {
	var value: NumericValue
	let dim: Dimension
	
	init(_ value: NumericValue, _ dim: Dimension) {
		self.value = value
		self.dim = dim
	}
	
	// TODO: move to Expression code
	init(_ value: NumericValue, _ unitString: String) {
		if let unit = units[unitString] {
			self.value = value * unit.factor + unit.offset
			self.dim = unit.dim
		} else {
			self.value = 0.0
			self.dim = Dimension.unitless
			print("PhysicalValue initialization error!")
		}
	}
	
	func valueIn(_ unitString: String) -> NumericValue {
		if let unit = units[unitString] {
			return (value - unit.offset) / unit.factor
		} else {
			// TODO: throw error
			return 0.0
		}
	}
	
	static func ==(lhs: PhysicalValue, rhs: PhysicalValue) -> Bool {
		return lhs.value == rhs.value && lhs.dim == rhs.dim
	}
	
	static func +(lhs: PhysicalValue, rhs: PhysicalValue) -> PhysicalValue? {
		if lhs.dim == rhs.dim {
			return PhysicalValue(lhs.value + rhs.value, lhs.dim)
		}
		return nil
	}
	
	static func -(lhs: PhysicalValue, rhs: PhysicalValue) -> PhysicalValue? {
		if lhs.dim == rhs.dim {
			return PhysicalValue(lhs.value - rhs.value, lhs.dim)
		}
		return nil
	}
	
	static func *(lhs: PhysicalValue, rhs: PhysicalValue) -> PhysicalValue? {
		if let expLeft = dims[lhs.dim], let expRight = dims[rhs.dim] {
			let exponent = expLeft + expRight
			if let dim = dims[exponent] {
				return PhysicalValue(lhs.value * rhs.value, dim)
			}
		}
		return nil
	}
	
	static func /(lhs: PhysicalValue, rhs: PhysicalValue) -> PhysicalValue? {
		// TODO: division by zero
		if let expLeft = dims[lhs.dim], let expRight = dims[rhs.dim] {
			let exponent = expLeft - expRight
			if let dim = dims[exponent] {
				return PhysicalValue(lhs.value / rhs.value, dim)
			}
		}
		return nil
	}
}
