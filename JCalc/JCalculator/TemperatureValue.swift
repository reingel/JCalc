//
//  TemperatureValue.swift
//  JCalc
//
//  Created by Soonkyu Jeong on 2019/06/22.
//  Copyright © 2019 Soonkyu Jeong. All rights reserved.
//

struct TemperatureValue {
    var value: Double // in Kelvin
    
    static let factorCelcius = 1.0
    static let offsetCelcius = -273.15
    static let factorFahrenheit = 9.0 / 5.0
    static let offsetFahrenheit = -459.67
    
    init() {
        value = TemperatureValue.offsetCelcius
    }
    
    subscript(_ unit: String) -> Double? {
        get {
            switch unit {
            case "K", "Kelvin":
                return value
            case "C", "degC", "Celcius":
                return value * TemperatureValue.factorCelcius + TemperatureValue.offsetCelcius
            case "F", "degF", "Fahrenheit":
                return value * TemperatureValue.factorFahrenheit + TemperatureValue.offsetFahrenheit
            case "R", "degR", "Rankine":
                return value * TemperatureValue.factorFahrenheit
            default:
                return nil
            }
        }
        set(newValue) {
            switch unit {
            case "K", "Kelvin":
                value = newValue!
            case "C", "degC", "Celcius":
                value = (newValue! - TemperatureValue.offsetCelcius) / TemperatureValue.factorCelcius
            case "F", "degF", "Fahrenheit":
                value = (newValue! - TemperatureValue.offsetFahrenheit) / TemperatureValue.factorFahrenheit
            case "R", "degR", "Rankine":
                value = newValue! / TemperatureValue.factorFahrenheit
            default:
                break;
            }
        }
    }
}
