//
//  PointSaleViewController.swift
//  JustOrders
//
//  Created by Victor Santos on 3/15/16.
//  Copyright © 2016 Victor Santos. All rights reserved.
//

import UIKit
import Kingfisher

class PointSaleViewController: UIViewController, PriceQuantityViewControllerDelegate {
    
    let pointSale: PointSaleType
    
    let reuseIdentifier = "collectionCell"
    let reuseIdentifierTable = "tableCell"
    
    @IBOutlet weak var itemQty: DesignableLabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var searchText: UITextField!
    var isFilter: Bool = false
    var filterProducts: [ProductItems] = []
    
    @IBAction func search(sender: AnyObject) {
        
        let searchInput = searchText.text
        
        if !(searchInput?.isEmpty)!{
         filterProducts = pointSale.inventory.filter { ProductItems in
            return ProductItems.description.lowercaseString.containsString(searchInput!)
        }
            isFilter = true
        }else{
            isFilter = false
        }
        
        collectionView.reloadData()
    }
    
    required  init?(coder aDecoder: NSCoder) {
        
        let productItems = InventoryModel().getInventory()
        self.pointSale = PointSale(inventory: productItems)
        
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
    
        super.viewDidLoad()
        
       let ser = ServicesData()
        
        ser.getToken("victor", password: "genio1681")
        
        //Clear Cache
        let cache = KingfisherManager.sharedManager.cache
        cache.clearMemoryCache()
        cache.clearMemoryCache()
        do{
            
        try ser.getDataInventory()
        }catch let error {
            print("error Something bad: \(error)")
        }
        
        //Load Point of Sale
       // inventory = InventoryModel().getInventory()
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
       
        if segue.identifier == "PriceQuantity" {
            let indexPath = self.collectionView.indexPathForCell(sender as! UICollectionViewCell)
            
            let toView = segue.destinationViewController as! PriceQuantityViewController
            toView.delegate = self
            
            toView.selectedItem = pointSale.inventory[(indexPath?.row)!]
        }
    }
    
    //MARK: Dlelegate Price & Quantity
    func updatePriceQuantity(controller: PriceQuantityViewController, netPrice: Double, amountTax:Double,  quantity: Double, selectedItem:ProductItems){
        
        //Add Select Item
        
        let selectedItem  = InventorySelectionItem(code: selectedItem.code, description: selectedItem.description, unit: selectedItem.und, amountTax: amountTax, quantity: quantity, price: netPrice , discount1: 0.0, discountPorcent: 0.0)
        
        do{
            try pointSale.vend(selectedItem, quantity: 0.0)
            
            
        }catch let e{
            print("Something happen \(e)")
        }
        
        
        self.tableView?.reloadData()
        
        print("price:\(netPrice), qty:\(quantity)")
    }
 
}

extension PointSaleViewController :  UICollectionViewDataSource, UICollectionViewDelegate {
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if isFilter {
            return filterProducts.count
        }
        return pointSale.inventory.count
    }
    
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! ItemsCollectionCell
        /*
        let business = selectedBusiness[indexPath.row]
        
        business.imageURL
        
        cell.imageView.setURL(business.imageURL, placeholderImage: UIImage(named: "content-avatar-default"))
        */
        
        // Configure the cell
        
        let currentItem: ProductItems
        
        if isFilter {
            currentItem = filterProducts[indexPath.row]
        }else{
        
            currentItem = pointSale.inventory[indexPath.row]
        }
       
        cell.descriptionItem.text = currentItem.description
        cell.url = "http://www.milescollins.com/images/pt-lb.jpg"
        
        cell.selectedView.hidden = true
        cell.selectedView.alpha = 0
        cell.checked.hidden = true
        
        
        return cell
        
    }
    
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        let cell : ItemsCollectionCell = collectionView.cellForItemAtIndexPath(indexPath) as! ItemsCollectionCell
        
       
        if !cell.checked.hidden {
            
            cell.checked.hidden = true
            cell.checked.animation = "zoomIn"
            cell.checked.animate()
            
            cell.selectedView.animation = "fadeOut"
            cell.selectedView.animate()
            cell.selectedView.hidden = true
        }else{
            
            
            cell.checked.animation = "zoomOut"
            cell.checked.animate()
            cell.checked.animateNext({ () -> () in
            cell.checked.hidden = false
            })
            
            cell.selectedView.hidden = false
            cell.selectedView.animation = "fadeIn"
            cell.selectedView.animate()
            cell.selectedView.alpha = 0.5
        }
    }

}


//TableView

extension PointSaleViewController: UITableViewDelegate, UITableViewDataSource {
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let selectionQty = pointSale.selection.count
        //Update Label Quantity
        itemQty.text = "\(selectionQty)"
        return selectionQty
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier(reuseIdentifierTable) as! ItemsTableViewCell
        
           // cell.selectedView.hidden = false
           // cell.checked.hidden = true
        
        let currenSelectedItem = pointSale.selection[indexPath.row]
        
        cell.sectionName.text = currenSelectedItem.description
        let price = currenSelectedItem.price
        let tax = currenSelectedItem.amountTax
        let qty = currenSelectedItem.quantity
        let subTotal = price * qty
        
        cell.price.text = "\(price)"
        cell.quantity.text = "\(qty)"
        cell.subTotal.text = "\(subTotal)"
    
            cell.url = "http://www.milescollins.com/images/pt-lb.jpg";
        
            return cell
        
        
    }
    
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == UITableViewCellEditingStyle.Delete {
           
            do{
                try pointSale.removeItem(indexPath.row)
                
            }catch{
                print("Error: \(error)")
            }
            
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
        }
    }

}