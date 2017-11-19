//
//  ViewController.swift
//  Calculator
//
//  Created by Weiran Xiong on 11/4/17.
//  Copyright © 2017 Weiran Xiong. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var display: UILabel!
    @IBOutlet weak var descrptionLabel: UILabel!
    
    var userIsInMiddleOfTyping = false
    var dotEntered = false
    
    @IBAction func appendDigit(_ sender: UIButton) {
        let digit = sender.currentTitle!
        if userIsInMiddleOfTyping {
            display.text! += digit
        } else {
            display.text = digit
            userIsInMiddleOfTyping = true
        }
    }
    
    
    @IBAction func enter(_ sender: Any) {
        
        userIsInMiddleOfTyping = false
        brain.setOperand(displayValue)
        
        descrptionLabel.text = brain.descrption
        
        brain.performOperation((sender as! UIButton).currentTitle!)
        if let result = brain.result {
            displayValue = result
        }
    }
    
    private var brain = CalculatorBrain()
    
    @IBAction func performOperation(_ sender: UIButton) {
        if userIsInMiddleOfTyping {
            brain.setOperand(displayValue)
            userIsInMiddleOfTyping = false
        }
        if let mathSymbol = sender.currentTitle {
            brain.performOperation(mathSymbol)
        }
        if let result = brain.result {
            displayValue = result
        }
        dotEntered = false
        descrptionLabel.text = brain.descrption
    }
    
    @IBAction func dotButtonPressed(_ sender: UIButton) {
        if dotEntered == false {
            if (userIsInMiddleOfTyping) {
                display.text! += "."
            } else {
                display.text = "0."
            }
            userIsInMiddleOfTyping = true
            dotEntered = true
        }
    }
    
    @IBAction func clear(_ sender: UIButton) {
        brain.clear()
        displayValue = 0
        descrptionLabel.text = ""
    }
    
    var displayValue: Double {
        get {
            return Double(display.text!)!
        }
        set {
            display.text = "\(newValue)"
            userIsInMiddleOfTyping = false
        }
    }
    
}

