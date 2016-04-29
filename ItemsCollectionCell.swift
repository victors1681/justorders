//
//  ItemsCollectionCell.swift
//  JustOrders
//
//  Created by Victor Santos on 3/15/16.
//  Copyright © 2016 Victor Santos. All rights reserved.
//

import UIKit
import Kingfisher

class ItemsCollectionCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView : UIImageView!
    @IBOutlet weak var sectionName : UILabel!
    @IBOutlet weak var checked : SpringImageView!
    @IBOutlet weak var selectedView: SpringView!
    @IBOutlet weak var descriptionItem: UILabel!
    
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
  
    override func awakeFromNib() {
        super.awakeFromNib()
        
       // contentView.layer.borderColor = UIColor.redColor().CGColor
       // contentView.layer.borderWidth = 0.5
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
         
    
    }
    
    var url: String? {
        
        didSet{
            setImage(url!)
        }
    }
     
    //Save cache.. default a week
    //more info https://github.com/onevcat/Kingfisher
    
    func setImage(url: String){
        
        self.imageView.kf_setImageWithURL(NSURL(string: url)!, placeholderImage:UIImage(named: "NoImage")!, optionsInfo: [.Transition(ImageTransition.Fade(1))])
        
    }
    
    
    
}