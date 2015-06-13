//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by Aydalvo Nery on 24/03/15.
//  Copyright (c) 2015 Aydalvo Nery. All rights reserved.
//

import Foundation

class CalculatorBrain
{
                     //Protocol like interface
    private enum Op: Printable {
        case Operand(Double)
        case UnaryOperation(String, Double -> Double)
        case BinaryOperation(String, (Double, Double) -> Double)
        
        var description: String {
            get {
                switch self {
                case .Operand(let operand):
                    return "\(operand)"
                case .UnaryOperation(let symbol, _):
                    return symbol
                case .BinaryOperation(let symbol, _):
                    return symbol
                }
            }
        }
    }
    
    // declaração de array
    private var opStack = [Op]() // passados por valor
    
    private var knownOps = [String:Op]() //var knownOps = Dictionary<String, Op>() May also be like this
    
    init() {
        func learnOp(op: Op) {
            knownOps[op.description] = op
        }
        learnOp(Op.BinaryOperation("×", *))
//        knownOps["×"] = Op.BinaryOperation("×", *)
        knownOps["÷"] = Op.BinaryOperation("÷") { $1 / $0}
        knownOps["−"] = Op.BinaryOperation("−") { $1 - $0}
        knownOps["+"] = Op.BinaryOperation("+", +)
    }
    
    
    typealias PropertyList = AnyObject
    
    var program: PropertyList { // guaranteed to be a PropertyList
        get {
            
            /*
             *   PropertyList only can be NSString, NSArray, NSDictionary, NSNumber, NSData, NSDate
             */
            
            /*
            var returnValue = Array<String>()
            for op in opStack {
                returnValue.append(op.description)
            }
            return returnValue
             */
            
            // todo o bloco anterior pode ser alterado por este.
            return opStack.map { $0.description }
            
        }
        set {
            
            if let OP_SYMBOLS = newValue as? Array<String>{
                var newOpStack = [Op]()
                for opSimbol in OP_SYMBOLS {
                    if let OP = knownOps[opSimbol] {
                        newOpStack.append(OP)
                    } else if let operand = NSNumberFormatter().numberFromString(opSimbol)?.doubleValue {
                        newOpStack.append(.Operand(operand))
                    }
                }
                opStack = newOpStack
            }
            
        }
    }
    
    // let define a constant
    //let brain = CalculatorBrain()
    
    // utiliando o var passa o parametro por referencia - private func evaluate(var ops: [Op]) -> (result: Double?, remainingOps: [Op])
    private func evaluate (ops: [Op]) -> (result: Double?, remainingOps: [Op])
    {
        if !ops.isEmpty {
            var remainingOps = ops
            let op = remainingOps.removeLast()
            
            switch op {
            case .Operand(let operand):
                return (operand, remainingOps)
            
            case .UnaryOperation(_, let operation):
                let operandEvaluation = evaluate(remainingOps) //recursion
                if let operand = operandEvaluation.result {
                    return (operation(operand), operandEvaluation.remainingOps)
                }
            
            case .BinaryOperation(_, let operation):
                let op1Evaluation = evaluate(remainingOps) //recursion
                if let operand1 = op1Evaluation.result {
                    let op2Evaluation = evaluate(op1Evaluation.remainingOps)
                        if let operand2 = op2Evaluation.result {
                            return (operation(operand1, operand2), op2Evaluation.remainingOps)
                        }
                }
            }
            
        }
        return (nil, ops)
    }
    
    private func evaluate() -> Double? {
        let (result, remainder) = evaluate(opStack)
        // conversão para String \(opStack)
        println("\(opStack) = \(result) with \(remainder) leftover")
        return result
    }
    
    func pushOperand(operand: Double) -> Double?
    {
        opStack.append(Op.Operand(operand))
        return evaluate()
    }
    
    func performOperation(symbol: String) -> Double? {
        if let operation = knownOps[symbol] {
            opStack.append(operation)
        }
        return evaluate()
    }
}
