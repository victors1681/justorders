//
//  File.swift
//  JustOrders
//
//  Created by Victor Santos on 4/6/16.
//  Copyright © 2016 Victor Santos. All rights reserved.
//

import UIKit


class MenuViewController: UIViewController {
    
    
    @IBOutlet weak var panelMenuView: DesignableView!
    @IBOutlet weak var darkBackground: SpringView!
    @IBOutlet weak var configBtn: UIButton!
    
    @IBAction func closeView(sender: AnyObject) {
        
       // UIApplication.sharedApplication().sendAction(#selector(PointSaleViewController.maximizeView(_:)), to: nil, from: self, forEvent: nil)
        
        darkBackground.animation = "fadeOut"
        darkBackground.animate()
        panelMenuView.animation = "squeezeLeft"
        panelMenuView.animateFrom = false
        panelMenuView.animateToNext {
            self.dismissViewControllerAnimated(false, completion: nil)
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Validate user
        if UserDefaultModel().getLastPasswordLogin() != UserDefaultModel().getAdministratorPassword() {
            configBtn.enabled = false
        }
        
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        
      //   UIApplication.sharedApplication().sendAction(#selector(PointSaleViewController.minimizeView(_:)), to: nil, from: self, forEvent: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
}