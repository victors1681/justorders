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

enum Selector {
    case paid
    case discount
}

class PaymentViewController: UIViewController {
    
    weak var delegate: PaymentViewDelegate?
    
    var totalOrder:Double = 0.0
    var subTotal: Double = 0.0
    var totalTax: Double = 0.0
    var amountPaid: Double = 0.0
    var amountChange: Double = 0.0
    var totalDiscount: Double = 0.0
    var discountPercent: Double = 0.0
    var orderNote: String = ""
    
    var clientName = ""
    var sendTo = ""
    let pickerData = ["Independencia","Bolivar","Los Jardines","Otras"]
    
    @IBOutlet weak var amountReceivedLabel: UITextField!
    
    @IBOutlet weak var paymentView: DesignableView!
    @IBOutlet weak var totalOrderLabel: UITextField!
    @IBOutlet weak var subTotalLabel: UITextField!
    @IBOutlet weak var taxLabel: UITextField!
    @IBOutlet weak var paymentLabel: UITextField!
    @IBOutlet weak var changeLabel: UITextField!
    @IBOutlet weak var discountText: UITextField!
    @IBOutlet weak var keypadTopBg: UIView!
    @IBOutlet weak var keypadView: DesignableView!
    @IBOutlet weak var keypadTextLabel: UILabel!
    @IBOutlet weak var discountBtn: UIButton!
    @IBOutlet weak var pickerContainer: SpringView!
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var sendToText: UITextField!
    @IBOutlet weak var chooseSendMethod: UIButton!
    @IBOutlet weak var activePaidView: SpringView!
    @IBOutlet weak var activeDiscrountView: SpringView!
    
    var amountArr = [Character]()
    var discountArr = [Character]()
    
    var selectorBtn = Selector.paid
    
    @IBAction func paidButton(sender: AnyObject) {
        chooseButton(Selector.paid)
        
    }
    @IBAction func discountButton(sender: AnyObject) {
        chooseButton(Selector.discount)
    }
    
    @IBAction func orderNoteAction(sender: AnyObject) {
        orderNote = observation.text!
    }
    
    
    @IBAction func chooseSendMethodAction(sender: AnyObject) {
        showPickerView()
    }
    
    @IBAction func hideChooseSendMethod(sender: AnyObject) {
        
        hidePickerView()
    }
    
    
    func chooseButton(selector:Selector) {
        
        //Update globar var
        selectorBtn = selector
        
        switch selector {
        case Selector.paid:
            
            //Show Paid & hide Discount
            activePaidView.animation = "fadeIn"
            activePaidView.animate()
            activeDiscrountView.animation = "fadeOut"
            activeDiscrountView.animate()
            
            //Change Keypad color Green Color
            keypadTopBg.backgroundColor = UIColor(red:0.46, green:0.75, blue:0.33, alpha:1.00)
            keypadTextLabel.text = "RECIBIDO"
            updateTextField(amountArr)
            
            break
            
        case Selector.discount:
            
            //Hide Paid & show Discount
            activePaidView.animation = "fadeOut"
            activePaidView.animate()
            activeDiscrountView.animation = "fadeIn"
            activeDiscrountView.animate()
            keypadTextLabel.text = "DESCUENTO"
            //Change Keypad color Red Color
            keypadTopBg.backgroundColor = UIColor(red:0.92, green:0.36, blue:0.38, alpha:1.00)
            
            updateTextField(discountArr)
            
            break
            
        }
        
    }
    
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
        
        payNow()
    }
    
    @IBAction func creditCarPaymentAction(sender: AnyObject) {
        payNow()
    }
    
    
    @IBAction func closeView(sender: AnyObject) {
        
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    
    @IBOutlet weak var clientNameLabel: UITextField!
    @IBOutlet weak var observation: UITextField!
    
    
    
    // Action Button
    
    @IBAction func deleteBtnAction(sender: AnyObject) {
        
        if selectorBtn == Selector.paid {
            if amountArr.count > 0 {
                amountArr.removeLast()
                updateTextField(amountArr)
            }else{
                amountArr.removeAll()
                updateTextField(amountArr)
            }
        }else if selectorBtn == Selector.discount {
            if discountArr.count > 0 {
                discountArr.removeLast()
                updateTextField(discountArr)
            }else{
                discountArr.removeAll()
                updateTextField(discountArr)
            }
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if !UserDefaultModel().getConfiguration().discount {
            discountBtn.enabled = false
        }
        
        totalOrderLabel.text = totalOrder.FormatNumberCurrencyVS
        subTotalLabel.text = subTotal.FormatNumberCurrencyVS
        taxLabel.text = totalTax.FormatNumberCurrencyVS
        clientNameLabel.text = clientName
        
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    
    
    //MASK: HELPERS
    
    
    func payNow(){
        
        sendTo = sendToText.text!
        
        if Double(String(amountArr)) > 0 || !sendTo.isEmpty {
            
            subTotal =  Double((subTotalLabel.text?.RemoveSymbolVS)!)!
            
            print("Total:\(totalOrder)\n Subtotal:\(subTotal) \n AmountRecibe: \(amountPaid)\n Change: \(amountChange)\n Discount: \(totalDiscount) \n DiscountPercent\(discountPercent)")
            
            delegate?.billPaid(self)
            dismissViewControllerAnimated(true, completion: nil)
            
        }else{
            paymentView.animation = "shake"
            paymentView.duration = 1
            paymentView.animate()
            
        }
        
    }
    
    
    func updatePayment(amountIn:[Character]) {
        
        if let amountPaidDo:Double = Double(String(amountIn)) {
            
            if selectorBtn == Selector.paid {
                
                self.amountPaid = amountPaidDo
                
                
                //update labels
                
                if amountPaidDo <= totalOrder {
                    paymentLabel.text = amountPaidDo.FormatNumberCurrencyVS
                }else{
                    paymentLabel.text = totalOrder.FormatNumberCurrencyVS
                }
                
                var amountChange = 0.0
                amountChange = amountPaid - ((subTotal - totalDiscount) + totalTax)
                
                if amountChange < 0  {
                    amountChange = 0
                }
                
                changeLabel.text = amountChange.FormatNumberCurrencyVS
                
                self.amountChange = amountChange
                
            } else if selectorBtn == Selector.discount {
                
                let percent = amountPaidDo
                
                discountPercent = percent
                
                totalDiscount = subTotal * (percent/100.00)
                
                var amountChange = 0.0
                amountChange = amountPaid - ((subTotal - totalDiscount) + totalTax)
                
                if amountChange < 0  {
                    amountChange = 0
                }
                
                 self.amountChange = amountChange
                
                discountText.text = totalDiscount.FormatNumberCurrencyVS
                changeLabel.text = amountChange.FormatNumberCurrencyVS
            }
            
            //Set subtotal and change without set variable
            subTotalLabel.text = (subTotal - totalDiscount).FormatNumberCurrencyVS
            
            
            
        }else{
            if selectorBtn == Selector.paid {
                paymentLabel.text = (0.0).FormatNumberCurrencyVS
                changeLabel.text = (0.0).FormatNumberCurrencyVS
            }else if selectorBtn == Selector.discount {
                discountText.text = (0).FormatNumberNumberVS
                subTotalLabel.text = (subTotal).FormatNumberCurrencyVS
                changeLabel.text = amountChange.FormatNumberCurrencyVS
                
            }
        }
        
        
    }
    
    
    func updateTextField(dataValue:[Character]) {
        
        
        if dataValue.count == 0 {
            amountReceivedLabel.text = "0"
            
            if Selector.paid == selectorBtn {
                amountChange = 0
                amountPaid = 0
                updatePayment(amountArr)
            }else if Selector.discount == selectorBtn {
                //Update calculations
                totalDiscount = 0
                updatePayment(discountArr)
            }
            
        }else{
            
            if Selector.paid == selectorBtn {
                let amount : Double = Double(String(dataValue))!
                amountReceivedLabel.text = amount.FormatNumberCurrencyVS
                
                //Update calculations
                updatePayment(amountArr)
                
            } else if Selector.discount == selectorBtn {
                let percent : Double = Double(String(dataValue))!
                amountReceivedLabel.text = percent.FormatNumberPorcentVS
                
                //Update calculations
                updatePayment(discountArr)
            }
            
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
        
        //Validate percent no more than 99%
        
        if selectorBtn == Selector.discount {
            if discountArr.count >= 2 {
                return false
            }
        }
        
        return true // Add value
    }
    
    
    func setNumber(number:KeyNumbers) {
        
        
        var dataCharArr: [Character] = []
        
        if selectorBtn == Selector.paid{
            dataCharArr = amountArr
        }else if selectorBtn == Selector.discount{
            dataCharArr = discountArr
        }
        
        if validateDesimalNumber() {
            
            switch number {
            case .one:
                dataCharArr.append("1")
                
                if selectorBtn == Selector.paid{
                    amountArr = dataCharArr
                }else if selectorBtn == Selector.discount{
                    discountArr = dataCharArr
                }
                updateTextField(dataCharArr)
                
            case .two:
                dataCharArr.append("2")
                if selectorBtn == Selector.paid{
                    amountArr = dataCharArr
                }else if selectorBtn == Selector.discount{
                    discountArr = dataCharArr
                }
                updateTextField(dataCharArr)
                
            case .three:
                dataCharArr.append("3")
                if selectorBtn == Selector.paid{
                    amountArr = dataCharArr
                }else if selectorBtn == Selector.discount{
                    discountArr = dataCharArr
                }
                updateTextField(dataCharArr)
                
            case .four:
                dataCharArr.append("4")
                if selectorBtn == Selector.paid{
                    amountArr = dataCharArr
                }else if selectorBtn == Selector.discount{
                    discountArr = dataCharArr
                }
                updateTextField(dataCharArr)
                
            case .five:
                dataCharArr.append("5")
                if selectorBtn == Selector.paid{
                    amountArr = dataCharArr
                }else if selectorBtn == Selector.discount{
                    discountArr = dataCharArr
                }
                updateTextField(dataCharArr)
                
            case .six:
                dataCharArr.append("6")
                if selectorBtn == Selector.paid{
                    amountArr = dataCharArr
                }else if selectorBtn == Selector.discount{
                    discountArr = dataCharArr
                }
                updateTextField(dataCharArr)
                
            case .seven:
                dataCharArr.append("7")
                if selectorBtn == Selector.paid{
                    amountArr = dataCharArr
                }else if selectorBtn == Selector.discount{
                    discountArr = dataCharArr
                }
                updateTextField(dataCharArr)
                
            case .eight:
                dataCharArr.append("8")
                if selectorBtn == Selector.paid{
                    amountArr = dataCharArr
                }else if selectorBtn == Selector.discount{
                    discountArr = dataCharArr
                }
                updateTextField(dataCharArr)
                
            case .nine:
                dataCharArr.append("9")
                if selectorBtn == Selector.paid{
                    amountArr = dataCharArr
                }else if selectorBtn == Selector.discount{
                    discountArr = dataCharArr
                }
                updateTextField(dataCharArr)
                
            case .zero:
                dataCharArr.append("0")
                if selectorBtn == Selector.paid{
                    amountArr = dataCharArr
                }else if selectorBtn == Selector.discount{
                    discountArr = dataCharArr
                }
                updateTextField(dataCharArr)
                
            case .zeroZero:
                dataCharArr.append("0")
                dataCharArr.append("0")
                if selectorBtn == Selector.paid{
                    amountArr = dataCharArr
                }else if selectorBtn == Selector.discount{
                    discountArr = dataCharArr
                }
                updateTextField(dataCharArr)
                break
                
            case .point:
                //Validate if point first
                if dataCharArr.count == 0 {
                    dataCharArr.append("0")
                    dataCharArr.append(".")
                    if selectorBtn == Selector.paid{
                        amountArr = dataCharArr
                    }else if selectorBtn == Selector.discount{
                        discountArr = dataCharArr
                    }
                    
                }else if !dataCharArr.contains("."){ //No point duplicate
                    dataCharArr.append(".")
                    if selectorBtn == Selector.paid{
                        amountArr = dataCharArr
                    }else if selectorBtn == Selector.discount{
                        discountArr = dataCharArr
                    }
                }
                
                updateTextField(dataCharArr)
                break
            }
            
        }else{
            keypadView.animation = "shake"
            keypadView.duration = 1
            keypadView.animate()
        }
    }
    
    
    func showPickerView() {
        pickerContainer.hidden = false
        
        pickerContainer.transform = CGAffineTransformMakeTranslation(0, 200)
        
        SpringAnimation.spring(0.5){
            
            self.pickerContainer.transform = CGAffineTransformMakeTranslation(0, 0)
        }
        
    }
    
    func hidePickerView(){
        
        
        SpringAnimation.springWithCompletion(0.5, animations: { 
             self.pickerContainer.transform = CGAffineTransformMakeTranslation(0, 250)
            }) { (true) in
                self.pickerContainer.hidden = true
        }
        
        
        
    }
    
    
}



extension PaymentViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
   
    //MARK: - Delegates and data sources
    //MARK: Data Sources
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    //MARK: Delegates
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        sendToText.text = pickerData[row]
    }
    
    func pickerView(pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        let titleData = pickerData[row]
        let myTitle = NSAttributedString(string: titleData, attributes: [NSFontAttributeName:UIFont(name: "Avenir", size: 26.0)!,NSForegroundColorAttributeName:UIColor(red:0.42, green:0.64, blue:0.89, alpha:1.00)])
        return myTitle
    }
    
}






















