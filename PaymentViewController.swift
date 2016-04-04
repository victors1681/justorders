//
//  PaymentViewController.swift
//  JustOrders
//
//  Created by Victor Santos on 4/3/16.
//  Copyright © 2016 Victor Santos. All rights reserved.
//

import UIKit
protocol PaymentViewDelegate: class {
    func billPaid(controller:PaymentViewController)
}

class PaymentViewController: UIViewController {
    
    weak var delegate: PaymentViewDelegate?

    @IBOutlet weak var amountReceivedLabel: UITextField!
    
    @IBOutlet weak var subTotalLabel: UITextField!
    @IBOutlet weak var taxLabel: UITextField!
    @IBOutlet weak var paymentLabel: UITextField!
    @IBOutlet weak var changeLabel: UITextField!
    
    var  amountArr = [Character]()
    
    //Number Action Numbers
    @IBAction func oneBtnAction(sender: AnyObject) {
        setNumber(.one)
    }
    
    @IBAction func twoBtnAction(sender: AnyObject) {
        setNumber(.two)
    }
    
    @IBAction func threeBtnAction(sender: AnyObject) {
        setNumber(.three)
    }
    
    @IBAction func fourBtnAction(sender: AnyObject) {
        setNumber(.four)
    }
    
    @IBAction func fiveBtnAction(sender: AnyObject) {
        setNumber(.five)
    }
    
    @IBAction func sixBtnAction(sender: AnyObject) {
        setNumber(.six)
    }
    
    @IBAction func sevenBtnAction(sender: AnyObject) {
        setNumber(.seven)
    }
    
    @IBAction func eightBtnAction(sender: AnyObject) {
        setNumber(.eight)
    }
    
    @IBAction func nineBtnAction(sender: AnyObject) {
        setNumber(.nine)
    }
    
    @IBAction func zeroBtnAction(sender: AnyObject) {
        setNumber(.zero)
    }
    
    @IBAction func zeroZeroBtnAction(sender: AnyObject) {
        setNumber(.zeroZero)
    }
    
    @IBAction func  pointBtnAction(sender: AnyObject) {
        setNumber(.point)
    }
    
    @IBAction func cashPaymentAction(sender: AnyObject) {
        
    }
    
    @IBAction func creditCarPaymentAction(sender: AnyObject) {
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    @IBAction func closeView(sender: AnyObject) {
        
        dismissViewControllerAnimated(true, completion: nil)
    }

    @IBOutlet weak var clientName: UITextField!
    @IBOutlet weak var observation: UITextField!
    
    
    
    // Action Button
    
    @IBAction func deleteBtnAction(sender: AnyObject) {
        if amountArr.count > 0 {
            amountArr.removeLast()
            updateTextField(amountArr)
        }
    
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    //MASK: HELPERS
    
    func updateTextField(dataValue:[Character]) {
        
        if amountArr.count == 0 {
            amountReceivedLabel.text = "0"
        }else{
            let amount : Double = Double(String(dataValue))!
            
            amountReceivedLabel.text = amount.FormatNumberCurrencyVS

        }
        
    }
    
    func validateDesimalNumber()->Bool{
    
        let amount = String(amountArr)
        let arr = amount.componentsSeparatedByString(".")
        if arr.count > 1 { //has desimal
           let charArr =  arr[1].characters
            if charArr.count == 2 {
                return false   //Do not add more than 2 number after point
            }
        }
        
        return true // Add value
    }
    
    
    func setNumber(number:KeyNumbers) {
        
        
        if validateDesimalNumber() {
        
            switch number {
            case .one:
                amountArr.append("1")
                updateTextField(amountArr)
                
            case .two:
                amountArr.append("2")
                updateTextField(amountArr)
                
            case .three:
                amountArr.append("3")
                updateTextField(amountArr)
                
            case .four:
                amountArr.append("4")
                updateTextField(amountArr)
                
            case .five:
                amountArr.append("5")
                updateTextField(amountArr)
                
            case .six:
                amountArr.append("6")
                updateTextField(amountArr)
                
            case .seven:
                amountArr.append("7")
                updateTextField(amountArr)
                
            case .eight:
                amountArr.append("8")
                updateTextField(amountArr)
                
            case .nine:
                amountArr.append("9")
                updateTextField(amountArr)
                
            case .zero:
                amountArr.append("0")
                updateTextField(amountArr)
                
            case .zeroZero:
                amountArr.append("0")
                amountArr.append("0")
                updateTextField(amountArr)
                
            case .point:
                //Validate if point first
                if amountArr.count == 0 {
                    amountArr.append("0")
                    amountArr.append(".")
            
                }else if !amountArr.contains("."){ //No point duplicate
                 amountArr.append(".")
                }
                updateTextField(amountArr)
                
        }
        
        }
    }

}
