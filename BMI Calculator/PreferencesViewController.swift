//
//  PreferencesViewController.swift
//  BMI Calculator
//
//  Created by Gabriel Theodoropoulos.
//  Copyright © 2019 Appcoda. All rights reserved.
//

import Cocoa

class PreferencesViewController: NSViewController {

    // MARK: - IBOutlet Properties
    
    @IBOutlet weak var metricRadio: NSButton!
    
    @IBOutlet weak var imperialRadio: NSButton!
    
    
    // MARK: - Properties
    
    var selectedRadio: NSButton?
    
    
    // MARK: - Default Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        
        selectedRadio = metricRadio
        
        loadSettings()
    }
    
    
    // MARK: - Custom Methods
    
    func loadSettings() {
        if let preferredSystem = UserDefaults.standard.value(forKey: "measurementSystem") as? String {
            if  preferredSystem == "metric" {
                metricRadio.state = .on
                selectedRadio = metricRadio
            } else {
                imperialRadio.state = .on
                selectedRadio = imperialRadio
            }
        }
    }
    
    
    // MARK: - IBAction Methods
    
    @IBAction func changeMeasurementSystem(_ sender: Any) {
        if let radio = sender as? NSButton, let selectedRadio = selectedRadio {
            if radio != selectedRadio {
                if radio == metricRadio {
                    UserDefaults.standard.setValue("metric", forKey: "measurementSystem")
                    
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "didChangeMeasurementSystem"), object: "metric")
                    
                } else {
                    UserDefaults.standard.setValue("imperial", forKey: "measurementSystem")
                    
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "didChangeMeasurementSystem"), object: "imperial")
                
                }
                
                self.selectedRadio = radio
            }
        }
    }
    
}
