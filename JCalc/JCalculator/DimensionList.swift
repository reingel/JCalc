//
//  DimensionList.swift
//  JCalc
//
//  Created by Soonkyu Jeong on 2019/06/23.
//  Copyright © 2019 Soonkyu Jeong. All rights reserved.
//

struct DimensionList {
    let dims: [Dimension: DimensionalExponent] = [
        .unitless:                  DimensionalExponent([0, 0, 0, 0, 0, 0, 0]),
        
        .length:                    DimensionalExponent([1, 0, 0, 0, 0, 0, 0]),
        .mass:                      DimensionalExponent([0, 1, 0, 0, 0, 0, 0]),
        .time:                      DimensionalExponent([0, 0, 1, 0, 0, 0, 0]),
        .electricCurrent:           DimensionalExponent([0, 0, 0, 1, 0, 0, 0]),
        .temperature:               DimensionalExponent([0, 0, 0, 0, 1, 0, 0]),
        .amountOfSubstance:         DimensionalExponent([0, 0, 0, 0, 0, 1, 0]),
        .luminousIntensity:         DimensionalExponent([0, 0, 0, 0, 0, 0, 1]),
        
        .area:                      DimensionalExponent([2, 0, 0, 0, 0, 0, 0]),
        .volume:                    DimensionalExponent([3, 0, 0, 0, 0, 0, 0]),
        
        .frequency:                 DimensionalExponent([0, 0, 0, 0, 0, 0, 0]),
        .energy:                    DimensionalExponent([0, 0, 0, 0, 0, 0, 0]),
        .power:                     DimensionalExponent([0, 0, 0, 0, 0, 0, 0]),
        
        .velocity:                  DimensionalExponent([1, 0, -1, 0, 0, 0, 0]),
        .acceleration:              DimensionalExponent([0, 0, 0, 0, 0, 0, 0]),
        .force:                     DimensionalExponent([0, 0, 0, 0, 0, 0, 0]),
        .pressure:                  DimensionalExponent([0, 0, 0, 0, 0, 0, 0])
    ]
    
    func contains(_ dim: Dimension) -> Bool { dims[dim] != nil }
    subscript (_ dim: Dimension) -> DimensionalExponent? { dims[dim] }
    subscript (_ exp: DimensionalExponent) -> Dimension? {
        for (key, value) in dims {
            if exp == value {
                return key
            }
        }
        return nil
    }
}

let dims = DimensionList()
