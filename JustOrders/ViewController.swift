//
//  ViewController.swift
//  JustOrders
//
//  Created by Victor Santos on 3/14/16.
//  Copyright © 2016 Victor Santos. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let dataInventory = ServicesData()
       
        do{
        try dataInventory.getDataClient()
            
        }catch{
            
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

