//
//  ViewController.swift
//  Calc
//
//  Created by Evgeniy Kolesin on 14.04.16.
//  Copyright © 2016 Evgeniy Kolesin. All rights reserved.
//

import Foundation
import UIKit

fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

class CalcVC: UIViewController {
    
    @IBOutlet var menuButton: UIButton!
    
    @IBOutlet var displayResultLabel: UILabel!
    var stillTyping = false
    var dotIsPlaced = false
    var firstOperand: Double = 0
    var secondOperand: Double = 0
    var operationSign: String = ""
    
    var currentInput: Double {
        
        get {
             return Double(displayResultLabel.text!)!
            }
        
        set {
                let value = "\(newValue)"
                let valueArray = value.components(separatedBy: ".")
            
            if valueArray[1] == "0" {
                displayResultLabel.text = "\(valueArray[0])"
    }
            
        else {
                displayResultLabel.text = "\(newValue)"
    }
            
                stillTyping = false
            }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if self.revealViewController() != nil {

            menuButton.addTarget(self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: UIControlEvents.touchUpInside)
            
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
    }
    
    @IBAction func numberPressed(_ sender: UIButton) {
        
        let number = sender.currentTitle!
        
        if stillTyping {
            
            if displayResultLabel.text?.characters.count < 20 {
                displayResultLabel.text = displayResultLabel.text! + number
            }
            
        }
            
        else {
            
            displayResultLabel.text = number
            stillTyping = true
            
        }
    }
    
    @IBAction func twoOperandsSignPressed(_ sender: UIButton) {
    
        operationSign = sender.currentTitle!
        firstOperand = currentInput
        stillTyping = false
        dotIsPlaced = false
        
    }
    
    func operateWithTwoOperands (_ operation: (Double, Double) -> Double){
        currentInput = operation (firstOperand, secondOperand)
        stillTyping = false
    }
    
    @IBAction func equalitySignPressed(_ sender: UIButton) {
        
        if stillTyping {
            secondOperand = currentInput
        }
        
        dotIsPlaced = false
        
        switch operationSign {
            case "+":
                operateWithTwoOperands{$0 + $1}
            case "-":
                operateWithTwoOperands{$0 - $1}
            case "×":
                operateWithTwoOperands{$0 * $1}
            case "÷":
                operateWithTwoOperands{$0 / $1}
        default: break
        
        }
        
    }
    
    @IBAction func ClearButtonPressed(_ sender: UIButton) {
        firstOperand = 0
        secondOperand = 0
        currentInput = 0
        displayResultLabel.text = "0"
        stillTyping = false
        dotIsPlaced = false
        operationSign = ""
        
    }
    
    @IBAction func PlusMinusButtonPressed(_ sender: UIButton) {
        currentInput = -currentInput
    }
    
    @IBAction func PercentageButtonPressed(_ sender: UIButton) {
        if firstOperand == 0{
            currentInput = currentInput / 100
        } else {
            secondOperand = firstOperand * currentInput / 100
        }
        
        stillTyping = false
    }
    
    @IBAction func DotButtonPressed(_ sender: UIButton) {
        if stillTyping && !dotIsPlaced {
            displayResultLabel.text = displayResultLabel.text! + "."
            dotIsPlaced = true
        }
        
        else if !stillTyping && !dotIsPlaced {
            displayResultLabel.text = "0."
        }
    }
    
    @IBAction func SquareRootButtonPressed(_ sender: UIButton) {
        
        currentInput = sqrt(currentInput)
    }
}
