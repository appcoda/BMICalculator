//
//  Structures.swift
//  BMI Calculator
//
//  Created by Gabriel Theodoropoulos.
//  Copyright © 2019 Appcoda. All rights reserved.
//

import Foundation

enum MeasurementSystem {
    case metric
    case imperial
}


struct WHData {
    var weightInKg: Double = 0.0
    var weightInPounds: Double = 0.0
    var heightInCM: Double = 0.0
    var heightInInches: Double = 0.0
    var feet: Double = 0.0
    var inches: Double = 0.0
 
    
    mutating func calculateForMetricSystem() {
        weightInKg = weightInPounds * 0.45359237
        heightInCM = heightInInches * 2.54
    }
    
    
    mutating func calculateForImperialSystem() {
        weightInPounds = weightInKg * 2.20462262
        heightInInches = heightInCM * 0.393700787
        feet = floor(heightInInches / 12)
        inches = heightInInches.truncatingRemainder(dividingBy: 12)
    }
    
}
