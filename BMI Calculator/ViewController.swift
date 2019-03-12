//
//  ViewController.swift
//  BMI Calculator
//
//  Created by Gabriel Theodoropoulos.
//  Copyright © 2019 Appcoda. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {

    // MARK: - IBOutlet Properties
    
    @IBOutlet weak var weightTextfield: NSTextField!
    
    @IBOutlet weak var heightTextfield: NSTextField!
    
    @IBOutlet weak var inchesTextfield: NSTextField!
    
    @IBOutlet weak var resultsView: NSView!
    
    @IBOutlet weak var resultsLabel: NSTextField!
    
    
    // MARK: - Properties
    
    var measurementSystem: MeasurementSystem = .metric
    
    var whData = WHData()
    
    
    // MARK: - Default Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleDidChangeMeasurementSystem(notification:)), name: NSNotification.Name(rawValue: "didChangeMeasurementSystem"), object: nil)
    }

    
    override func viewWillAppear() {
        super.viewWillAppear()
        
        getPreferences()
        setupUI()
    }
    
    
    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }

    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    
    
    // MARK: - Custom Methods
    
    func getPreferences() {
        if let preferredSystem = UserDefaults.standard.value(forKey: "measurementSystem") as? String {
            measurementSystem = (preferredSystem == "metric") ? .metric : .imperial
        }
    }
    
    
    func setupUI() {
        resultsView.wantsLayer = true
        resultsView.layer?.backgroundColor = NSColor(named: NSColor.Name(stringLiteral: "statusDefault"))?.cgColor
        
        updateTextfields()
    
        weightTextfield.delegate = self
        heightTextfield.delegate = self
        inchesTextfield.delegate = self
    }
    
    
    
    func updateTextfields() {
        if measurementSystem == .metric {
            weightTextfield.placeholderString = "Weight (Kg)"
            heightTextfield.placeholderString = "Height (cm)"
            inchesTextfield.isHidden = true
            
            if whData.weightInKg > 0.0 {
                weightTextfield.stringValue = String(format: "%.0f", whData.weightInKg)
            }
            if whData.heightInCM > 0.0 {
                heightTextfield.stringValue = String(format: "%.0f", whData.heightInCM)
            }
            
        } else {
            weightTextfield.placeholderString = "Weight (Pounds)"
            heightTextfield.placeholderString = "Height (Feet)"
            inchesTextfield.isHidden = false
            
            if whData.weightInPounds > 0.0 {
                weightTextfield.stringValue = String(format: "%.0f", whData.weightInPounds)
            }
            if whData.heightInInches > 0.0 {
                heightTextfield.stringValue = String(format: "%.0f", whData.feet)
                inchesTextfield.stringValue = String(format: "%.2f", whData.inches)
            }
            
        }
    }
    
    
    
    func validateTextfields() {
        if let window = view.window {
            window.makeFirstResponder(window)
        }
    }
    
    
    
    func presentResults(forBMI bmi: Double) {
        let bmiString = String(format: "%.1f", bmi)
        var color: NSColor?
        
        if bmi < 18.5 {
            resultsLabel.stringValue = "\(bmiString) - Underweight"
            color = NSColor(named: NSColor.Name(stringLiteral: "statusUnderweight"))
        } else if bmi <= 24.9 {
            resultsLabel.stringValue = "\(bmiString) - Normal"
            color = NSColor(named: NSColor.Name(stringLiteral: "statusNormal"))
        } else if bmi <= 29.9 {
            resultsLabel.stringValue = "\(bmiString) - Overweight"
            color = NSColor(named: NSColor.Name(stringLiteral: "statusOverweight"))
        } else {
            resultsLabel.stringValue = "\(bmiString) - Obese"
            color = NSColor(named: NSColor.Name(stringLiteral: "statusObese"))
        }
        
        if let color = color {
            resultsView.layer?.backgroundColor = color.cgColor
        }
    }
    
    
    
    @objc func handleDidChangeMeasurementSystem(notification: Notification) {
        if let system = notification.object as? String {
            validateTextfields()
            
            if system == "metric" {
                measurementSystem = .metric
                whData.calculateForMetricSystem()
            } else {
                measurementSystem = .imperial
                whData.calculateForImperialSystem()
            }
            
            updateTextfields()
        }
    }
    
    
    
    // MARK: - IBAction Methods
    
    @IBAction func calculateBMI(_ sender: Any) {
        var allValuesExist = false
        var bmi: Double?
        
        validateTextfields()
        
        if weightTextfield.stringValue.count > 0 && heightTextfield.stringValue.count > 0 {
            if measurementSystem == .imperial {
                if inchesTextfield.stringValue.count > 0 {
                    allValuesExist = true
                }
            } else {
                allValuesExist = true
            }
        }
        
        if allValuesExist {
            if measurementSystem == .imperial {
                whData.calculateForMetricSystem()
            }
            
            if whData.heightInCM != 0.0 {
                bmi = whData.weightInKg / pow(whData.heightInCM / 100.0, 2)
            }
        }
        
        
        if let bmi = bmi {
            presentResults(forBMI: bmi)
        }
    }
    
}



// MARK: - NSTextFieldDelegate
extension ViewController: NSTextFieldDelegate {
    func control(_ control: NSControl, textShouldEndEditing fieldEditor: NSText) -> Bool {
        if let textField = control as? NSTextField {
            if measurementSystem == .metric {
                
                if textField == weightTextfield {
                    if let weight = Double(weightTextfield.stringValue) {
                        whData.weightInKg = weight
                    } else {
                        whData.weightInKg = 0.0
                    }
                } else if textField == heightTextfield {
                    if let height = Double(heightTextfield.stringValue) {
                        whData.heightInCM = height
                    } else {
                        whData.heightInCM = 0.0
                    }
                }
                
            } else {
                
                if textField == weightTextfield {
                    if let weight = Double(weightTextfield.stringValue) {
                        whData.weightInPounds = weight
                    } else {
                        whData.weightInPounds = 0.0
                    }
                } else if textField == heightTextfield {
                    if let height = Double(heightTextfield.stringValue) {
                        whData.feet = height
                        whData.heightInInches = height * 12.0
                        
                        if whData.inches != 0.0 {
                            whData.heightInInches += whData.inches
                        }
                        
                    } else {
                        if whData.feet != 0.0 {
                            whData.heightInInches -= whData.feet * 12
                        }
                        whData.feet = 0.0
                    }
                    
                } else {
                    if let inches = Double(inchesTextfield.stringValue) {
                        whData.inches = inches
                        whData.heightInInches += inches
                    } else {
                        if whData.inches != 0.0 {
                            whData.heightInInches -= whData.inches
                        }
                        whData.inches = 0.0
                    }
                    
                }
                
            }
        }
        
        return true
    }
}
