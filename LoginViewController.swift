//
//  LoginViewController.swift
//  JustOrders
//
//  Created by Victor Santos on 3/31/16.
//  Copyright © 2016 Victor Santos. All rights reserved.
//

import UIKit




class LoginViewController: UIViewController {
    
    @IBOutlet weak var passwordField: DesignableTextField!
    @IBOutlet weak var enterPasswordLabel: SpringLabel!
    
    var passwordArr = [Character]()
    
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
    
    
    // Action Button
    @IBAction func enterBtnAction(sender: AnyObject) {
    }
    
    @IBAction func deleteBtnAction(sender: AnyObject) {
        if passwordArr.count > 0 {
            passwordArr.removeLast()
            updateTextField(passwordArr)
        }
        
        if passwordArr.count == 0 {
            enterPasswordLabel.hidden = false
            enterPasswordLabel.animation = "fadeIn"
            enterPasswordLabel.animate()
        }
        
    }
    
    
    //MASK: HELPERS
    
    func updateTextField(codeData:[Character]) {
        passwordField.text = String(codeData)
    }
    
    func setNumber(number:KeyNumbers) {
        
        //Reset Password
        if passwordArr.count == 4 {
            passwordArr.removeAll()
            updateTextField(passwordArr)
        }
        
        
        if passwordArr.count == 0 {
            
            enterPasswordLabel.autohide = true
            enterPasswordLabel.animation = "fadeOut"
            enterPasswordLabel.duration = 0.5
            enterPasswordLabel.animate()
        }
        
        if passwordArr.count <= 3 {
            
        switch number {
        case .one:
            passwordArr.append("1")
            updateTextField(passwordArr)
            
        case .two:
            passwordArr.append("2")
            updateTextField(passwordArr)
        
        case .three:
            passwordArr.append("3")
            updateTextField(passwordArr)
            
        case .four:
            passwordArr.append("4")
            updateTextField(passwordArr)
        
        case .five:
            passwordArr.append("5")
            updateTextField(passwordArr)
            
        case .six:
            passwordArr.append("6")
            updateTextField(passwordArr)
            
        case .seven:
            passwordArr.append("7")
            updateTextField(passwordArr)
            
        case .eight:
            passwordArr.append("8")
            updateTextField(passwordArr)
            
        case .nine:
            passwordArr.append("9")
            updateTextField(passwordArr)
            
        case .zero:
            passwordArr.append("0")
            updateTextField(passwordArr)
            
        default:
            break
        
        }
        
        }
        
        //Validate Password and enter
        if passwordArr.count == 4 {
            //Default Password
            if (UserDefaultModel().validateLogin(String(passwordArr)))  {
                
                let userData = UserDefaultModel().getDataUser()
                let ser = ServicesData()
                
                ser.getToken(userData.username , password: userData.password)
                
                performSegueWithIdentifier("home", sender: nil)
                
            }else{
                passwordField.animation = "shake"
                passwordField.duration = 1
                passwordField.animate()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }

}
