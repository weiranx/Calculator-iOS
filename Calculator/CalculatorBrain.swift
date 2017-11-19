//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by Weiran Xiong on 11/4/17.
//  Copyright © 2017 Weiran Xiong. All rights reserved.
//

import Foundation

struct CalculatorBrain {
    
    private var accumulator: Double? {
        willSet {
            if (pendingBinaryOperationpend == nil) {
                descrption = String(describing: newValue!)
            } else {
                var lastOperand = ""
                if (newValue != nil) {
                    lastOperand = String(newValue!)
                }
                descrption = String(pendingBinaryOperationpend!.firstOperand) + " " + pendingBinaryOperationpend!.symbol + " " + lastOperand
            }
        }
    }
    
    public var resultIsPending: Bool {
        get {
            if (pendingBinaryOperationpend != nil) {
                return true
            } else {
                return false
            }
        }
    }
    
    public var descrption: String = ""

    mutating public func clear() {
        accumulator = 0
        pendingBinaryOperationpend = nil
    }
    
    private enum Operation {
        case constant(Double)
        case unaryOperation( (Double) -> Double )
        case binaryOperation( (Double, Double) -> Double )
        case equals
    }
    
    private var operations: Dictionary<String, Operation> = [
        "π": Operation.constant(Double.pi),
        "e": Operation.constant(M_E),
        "√": Operation.unaryOperation(sqrt),
        "cos": Operation.unaryOperation(cos),
        "sin": Operation.unaryOperation(sin),
        "×": Operation.binaryOperation({ $0 * $1 }),
        "÷": Operation.binaryOperation({ $0 / $1 }),
        "+": Operation.binaryOperation({ $0 + $1 }),
        "−": Operation.binaryOperation({ $0 - $1 }),
        "=": Operation.equals
    ]
    
    mutating func performOperation(_ symbol: String) {
        if let operation = operations[symbol] {
            switch operation {
            case .constant(let value):
                accumulator = value
                break
            case .unaryOperation(let function):
                if accumulator != nil {
                    accumulator = function(accumulator!)
                }
                break
            case .binaryOperation(let function):
                if accumulator != nil {
                    pendingBinaryOperationpend = PendingBinaryOperation(function: function, firstOperand: accumulator!, symbol: symbol)
                    accumulator = nil
                }
                break
            case .equals:
                performPendingBinaryOperation()
            }
        }
    }
    private mutating func performPendingBinaryOperation() {
        if  pendingBinaryOperationpend != nil && accumulator != nil {
            accumulator = pendingBinaryOperationpend!.perform(with: accumulator!)
            pendingBinaryOperationpend = nil
        }
    }
    
    private var pendingBinaryOperationpend: PendingBinaryOperation?
    
    private struct PendingBinaryOperation {
        let function: (Double, Double) -> Double
        let firstOperand: Double
        let symbol: String
        func perform(with secondOperand: Double) -> Double {
            return function(firstOperand, secondOperand)
        }
    }
    
    mutating func setOperand(_ operand: Double) {
        accumulator = operand
    }
    
    var result: Double? {
        get {
            return accumulator
        }
    }
    
}
