//
//  CustomAlertView.swift
//  JustOrders
//
//  Created by Victor Santos on 4/4/16.
//  Copyright © 2016 Victor Santos. All rights reserved.
//
//

import UIKit

public enum AlertViewType {
    case information
    case error
    case caution
    case question
}

public protocol  CustomAlertViewDelegate: class  {
    func alertBack(controller:CustomAlertView, acction:Bool, tag:Int)
}

public class CustomAlertView: UIView {
    
    var alertViewType:AlertViewType = AlertViewType.information
    var alertTitle:String = ""
    var alertMesage:String = ""
    weak var delegate:CustomAlertViewDelegate?
    
    @IBOutlet weak var titleLabel: UITextField!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var cancelButton: SpringButton!
    @IBOutlet weak var aceptarButtonRight: SpringButton!
    @IBOutlet weak var aceptarButtonCenter: SpringButton!
    @IBOutlet weak var topAlertTitle: UIView!
    internal var innerTag: Int = 0
    
    @IBAction func closeView(sender: AnyObject) {
        
        hideCustomeAlert()
    }
    
    
    @IBAction func doneButton(sender: AnyObject) {
        
        
        delegate?.alertBack(self, acction: true, tag:innerTag )
        
        //Whether information / error / caution just show OK button
        hideCustomeAlert()

    }
    
    override public func awakeFromNib() {
        
    }
    
    class func designCodeAlertView()-> CustomAlertView {
        return NSBundle(forClass: self).loadNibNamed("CustomAlertView", owner: self, options: nil)[0] as! CustomAlertView
    }
    
}

public extension UIView {
    
    struct CustomAlertViewConstants {
        static let Tag = 1000
    }
    
    public func showCustomeAlert(alertViewType:AlertViewType? = .information, delegate:CustomAlertViewDelegate? = nil, title:String, message:String, tag:Int? = 0) {
        
        let customAlertXibView = CustomAlertView.designCodeAlertView()
        customAlertXibView.frame = self.bounds
        customAlertXibView.tag = CustomAlertViewConstants.Tag
        
        customAlertXibView.titleLabel.text = title
        customAlertXibView.messageLabel.text = message
        customAlertXibView.alertViewType = alertViewType!
        customAlertXibView.delegate = delegate
        customAlertXibView.innerTag = tag!
        
        selectTop(alertViewType!, customAlertXibView: customAlertXibView)
        self.addSubview(customAlertXibView)
        
        
        customAlertXibView.alpha = 0
        SpringAnimation.spring(0.7) {
            customAlertXibView.alpha = 1
        }
    }
    
    internal func selectTop(alertViewType:AlertViewType,customAlertXibView:CustomAlertView)
    {
        
        switch alertViewType {
            
        case  AlertViewType.question :
            customAlertXibView.aceptarButtonCenter.hidden = true
            break
            
        case AlertViewType.caution:
            customAlertXibView.topAlertTitle.backgroundColor = UIColor(red:0.941, green:0.889, blue:0.3, alpha:1)
            customAlertXibView.cancelButton.hidden = true
            customAlertXibView.aceptarButtonRight.hidden = true
            break
            
        case AlertViewType.error:
            customAlertXibView.topAlertTitle.backgroundColor = UIColor(red:0.948, green:0.439, blue:0.439, alpha:1)
            customAlertXibView.cancelButton.hidden = true
            customAlertXibView.aceptarButtonRight.hidden = true
            break
            
        default:
            customAlertXibView.cancelButton.hidden = true
            customAlertXibView.aceptarButtonRight.hidden = true
        }
    }
    
    
    public func hideCustomeAlert() {
        
        if let customAlertXibView = self.viewWithTag(CustomAlertViewConstants.Tag) {
            customAlertXibView.alpha = 1
            
            SpringAnimation.springWithCompletion(0.7, animations: {
                customAlertXibView.alpha = 0
                }, completion: { (completed) -> Void in
                    customAlertXibView.removeFromSuperview()
            })
        }
    }
}







