//
//  UnitList.swift
//  JCalc
//
//  Created by Soonkyu Jeong on 2019/06/23.
//  Copyright © 2019 Soonkyu Jeong. All rights reserved.
//

struct UnitList {
	let units: [String: Unit] = [
		"m": Unit(dim: .length),
		"km": Unit(dim: .length, factor: 1000.0),
		
		"m^2": Unit(dim: .area, factor: 1.0),
		
		"degC": Unit(dim: .temperature, factor: 1.0, offset: -273.15),
		"degF": Unit(dim: .temperature, factor: 1.8, offset: -459.67),
	]
	
	func contains(_ unitString: String) -> Bool { units[unitString] != nil }
	subscript (_ unitString: String) -> Unit? { units[unitString] }
	
	//    func startsWith(_ string: String) -> [String] {
	//        var results: [String] = []
	//
	//        for unit in units.keys() {
	//            if string in unit {
	//                results.append(unit)
	//            }
	//        }
	//        return results
	//    }
}

let units = UnitList()
