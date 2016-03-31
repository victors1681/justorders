//
//  ItemsTableViewCell.swift
//  JustOrders
//
//  Created by Victor Santos on 3/20/16.
//  Copyright © 2016 Victor Santos. All rights reserved.
//

import UIKit
import Kingfisher

class ItemsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var itemImageView : UIImageView!
    @IBOutlet weak var sectionName : UILabel!
    @IBOutlet weak var quantity : UILabel!
    @IBOutlet weak var price : UILabel!
    @IBOutlet weak var subTotal : UILabel!
    
    @IBOutlet weak var checked : SpringImageView!
    @IBOutlet weak var selectedView: SpringView!
    
    
    
    var url: String? {
        
        didSet{
            setImageItem(url!)
        }
    }
    
    
    //Save cache.. default a week
    //more info https://github.com/onevcat/Kingfisher
    
    func setImageItem(url: String){
       
        self.itemImageView.kf_setImageWithURL(NSURL(string: url)!, placeholderImage:UIImage(named: "NoImage")!, optionsInfo: [.Transition(ImageTransition.Fade(1))])
        
    }
    
    
    
}