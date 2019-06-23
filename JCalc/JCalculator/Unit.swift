//
//  Unit.swift
//  JCalc
//
//  Created by Soonkyu Jeong on 2019/06/23.
//  Copyright © 2019 Soonkyu Jeong. All rights reserved.
//

struct Unit {
	let dim: Dimension
	let factor: NumericValue
	let offset: NumericValue
	
	init(dim: Dimension, factor: NumericValue = 1.0, offset: NumericValue = 0.0) {
		self.dim = dim
		self.factor = factor
		self.offset = offset
	}
}
