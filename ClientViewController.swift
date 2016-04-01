//
//  ClientViewController.swift
//  JustOrders
//
//  Created by Victor Santos on 3/30/16.
//  Copyright © 2016 Victor Santos. All rights reserved.
//

import UIKit




class ClientViewController: UIViewController {
    
    
    @IBOutlet weak var optionalPanelView: SpringView!
    @IBOutlet weak var containerView: DesignableView!
    @IBOutlet weak var clientOptionButton: SpringButton!
    @IBOutlet weak var segment: UISegmentedControl!
    
    @IBAction func segmentAction(sender: AnyObject) {
        
        switch segment.selectedSegmentIndex {
        case 0:
            //Personal
            print("selection: \(ClientClasification.Personal.rawValue)")
            break
        case 1:
            //Company
            print("Empresa")
            break
            
        case 2:
            //Special
            
            break
        case 3:
            //Gob
            
            
            break
            
        default:
            break
        }
    }
    
    @IBAction func closeView(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func doneAction(sender: AnyObject) {
        
        
    }
    
    @IBAction func clientOption(sender: AnyObject) {
        
        clientOptionButton.animation = "fall"
        clientOptionButton.animate()
        
        
        
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
