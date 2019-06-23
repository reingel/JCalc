//
//  Dimension.swift
//  JCalc
//
//  Created by Soonkyu Jeong on 2019/06/23.
//  Copyright © 2019 Soonkyu Jeong. All rights reserved.
//

enum Dimension: CaseIterable {
	case unitless
	case length, mass, time,electricCurrent,temperature, amountOfSubstance, luminousIntensity
	case area, volume
	case frequency, energy, power
	case velocity, acceleration, force, pressure
	case planeAngle, solidAngle, torque, angularVelocity, angularAcceleration
	case electricCharge, voltage, capacitance, resistance, electricConductance
}

struct DimensionalExponent: Equatable {
	let exponents: [Int8] // [length, mass, time, electricCurrent, temperature, amountOfSubstance, luminousIntensity]
	let angle: Int8 // plane angle = 1, solid angle = 2
	
	init(_ exponents: [Int8], angle: Int8 = 0) {
		assert(exponents.count == 7)
		self.exponents = exponents
		self.angle = angle
	}
	
	static func ==(lhs: DimensionalExponent, rhs: DimensionalExponent) -> Bool {
		return
			lhs.exponents[0] == rhs.exponents[0] &&
				lhs.exponents[1] == rhs.exponents[1] &&
				lhs.exponents[2] == rhs.exponents[2] &&
				lhs.exponents[3] == rhs.exponents[3] &&
				lhs.exponents[4] == rhs.exponents[4] &&
				lhs.exponents[5] == rhs.exponents[5] &&
				lhs.exponents[6] == rhs.exponents[6] &&
				lhs.angle == rhs.angle
	}
	
	static func +(lhs: DimensionalExponent, rhs: DimensionalExponent) -> DimensionalExponent {
		return DimensionalExponent([
			lhs.exponents[0] + rhs.exponents[0],
			lhs.exponents[1] + rhs.exponents[1],
			lhs.exponents[2] + rhs.exponents[2],
			lhs.exponents[3] + rhs.exponents[3],
			lhs.exponents[4] + rhs.exponents[4],
			lhs.exponents[5] + rhs.exponents[5],
			lhs.exponents[6] + rhs.exponents[6]
			], angle: lhs.angle + rhs.angle)
	}
	
	static func -(lhs: DimensionalExponent, rhs: DimensionalExponent) -> DimensionalExponent {
		return DimensionalExponent([
			lhs.exponents[0] - rhs.exponents[0],
			lhs.exponents[1] - rhs.exponents[1],
			lhs.exponents[2] - rhs.exponents[2],
			lhs.exponents[3] - rhs.exponents[3],
			lhs.exponents[4] - rhs.exponents[4],
			lhs.exponents[5] - rhs.exponents[5],
			lhs.exponents[6] - rhs.exponents[6]
			], angle: lhs.angle - rhs.angle)
	}
}
