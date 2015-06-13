//
//  ViewController.swift
//  Calculator
//
//  Created by Aydalvo Nery on 24/03/15.
//  Copyright (c) 2015 Aydalvo Nery. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var display: UILabel!
    
    var userIsInTheMidleTypingANumber: Bool = false
    
    var brain = CalculatorBrain()
    
    @IBAction func clear() {
    }
    
    @IBAction func operation(sender: UIButton) {
        if userIsInTheMidleTypingANumber {
            enter()
        }
        
        if let operators = sender.currentTitle {
            if let results = brain.performOperation(operators) {
                displayDouble = results
            } else {
                displayDouble = 0
            }
        }
    }
    
    @IBAction func enter() {
        userIsInTheMidleTypingANumber = false
        var returnDouble = brain.pushOperand(displayDouble)
        if let results = returnDouble {
            displayDouble = results
        } else {
            displayDouble = 0
        }
    }
    
    @IBAction func appendDigit(sender: UIButton) {
        let digit = sender.currentTitle!
        println("digit = \(digit)")
        if userIsInTheMidleTypingANumber {
            display.text = display.text! + digit
        } else  {
            display.text = digit
            userIsInTheMidleTypingANumber = true
        }
    }
    
    var displayDouble: Double {
        get {
            return 6().numberFromString(display.text!)!.doubleValue
        }
        set {
            display.text = "\(newValue)"
            userIsInTheMidleTypingANumber = false
        }
    }
    
//    var operandStack = Array<Double>()
    /*
    * May alse be: var operandStack: Array<Double> = Array<Double>()
    */
    
//    func performOperation(operation: (Double, Double) -> Double ) {
//        if operandStack.count >= 2 {
//            displayDouble = operation(operandStack.removeLast(), operandStack.removeLast())
//            enter()
//        }
//    }

//    override func viewDidLoad() {
//        super.viewDidLoad()
//        // Do any additional setup after loading the view, typically from a nib.
//    }
//
//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//        // Dispose of any resources that can be recreated.
//    }
}

