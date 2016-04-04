//
//  ClientViewController.swift
//  JustOrders
//
//  Created by Victor Santos on 3/30/16.
//  Copyright © 2016 Victor Santos. All rights reserved.
//

import UIKit



protocol ClientViewDelegate : class{

    func clientReload(controller:ClientViewController, clientSelected: ClientSelection)
    
}


class ClientViewController: UIViewController {
    
    var client:ClientSelection?
    weak var delegate: ClientViewDelegate?
    
    @IBOutlet weak var name: DesignableTextField!
    @IBOutlet weak var phone: DesignableTextField!
    @IBOutlet weak var email: DesignableTextField!
    @IBOutlet weak var city: DesignableTextField!
    @IBOutlet weak var address: DesignableTextField!
    @IBOutlet weak var taxId: DesignableTextField!
    
    
    @IBOutlet weak var panelButtonView: SpringView!
    @IBOutlet weak var optionalPanelView: SpringView!
    @IBOutlet weak var containerView: DesignableView!
    @IBOutlet weak var clientOptionButton: SpringButton!
    @IBOutlet weak var segment: UISegmentedControl!
    @IBAction func segmentAction(sender: AnyObject) {
        
        
        switch segment.selectedSegmentIndex {
        case 0:
            //Personal
            client?.clasification = ClientClasification.Personal.rawValue
            break
        case 1:
            //Company
            client?.clasification = ClientClasification.Company.rawValue
            break
            
        case 2:
            //Special
            client?.clasification = ClientClasification.Special.rawValue
            break
        case 3:
            //Gob
            client?.clasification = ClientClasification.Government.rawValue
            break
            
        default:
            break
        }
    }
    
    @IBAction func closeView(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func doneAction(sender: AnyObject) {
        
        client?.name = name.text!
        client?.phone = phone.text!
        client?.email = email.text!
        client?.taxId = taxId.text!
        client?.address = address.text!
        client?.city = city.text!
        
        delegate?.clientReload(self, clientSelected: client!)
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func clientOption(sender: AnyObject) {
        
        
        //Set value 
        
        client?.taxeable = true
        
        panelButtonView.animation = "fadeOut"
        panelButtonView.animate()
        
        optionalPanelView.hidden = false
        optionalPanelView.alpha = 0
        optionalPanelView.animation = "fadeIn"
        optionalPanelView.animate()
        
    }
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
