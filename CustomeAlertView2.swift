//
//  CustomAlertView.swift
//  JustOrders
//
//  Created by Victor Santos on 4/4/16.
//  Copyright © 2016 Victor Santos. All rights reserved.
//

import UIKit


enum AlertViewType2 {
    case information
    case error
    case caution
    case question
}

protocol CustomAlertDelegate2: class {
    func alertAction(controller:CustomAlertView2, alertIdentifier:String, action:Bool)
}

class CustomAlertView2: UIViewController {
    
    var alertViewType:AlertViewType = AlertViewType.information
    var alertTitle:String = ""
    var alertMesage:String = ""
    var alertIdentifier:String = ""
    weak var delegate:CustomAlertDelegate2?
    
    
    @IBOutlet weak var titleLabel: UITextField!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var cancelButton: SpringButton!
    @IBOutlet weak var aceptarButtonRight: SpringButton!
    @IBOutlet weak var aceptarButtonCenter: SpringButton!
    
    
    @IBAction func closeView(sender: AnyObject) {
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func doneButton(sender: AnyObject) {
        
        delegate?.alertAction(self, alertIdentifier: alertIdentifier, action: true)
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleLabel.text = alertTitle
        messageLabel.text = alertMesage
        
        switch alertViewType {
            
        case  AlertViewType.question :
            aceptarButtonCenter.hidden = true
            break
            
        default:
            cancelButton.hidden = true
            aceptarButtonRight.hidden = true
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
    }
}
