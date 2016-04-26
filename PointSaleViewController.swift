//
//  PointSaleViewController.swift
//  JustOrders
//
//  Created by Victor Santos on 3/15/16.
//  Copyright © 2016 Victor Santos. All rights reserved.
//

import UIKit
import Kingfisher
import Crashlytics

class PointSaleViewController: UIViewController, PriceQuantityViewControllerDelegate, ClientViewDelegate, PaymentViewDelegate {
    
    var pointSale: PointSaleType
    var randomImg: [String] = []
    
    let reuseIdentifier = "collectionCell"
    let reuseIdentifierTable = "tableCell"
    
    
    @IBOutlet weak var clientButton: SpringButton!
    @IBOutlet weak var clientInformationView: SpringView!
    @IBOutlet weak var clientPhone: UILabel!
    @IBOutlet weak var clientEmail: UILabel!
    @IBOutlet weak var clientName: UILabel!
    @IBOutlet weak var totalOrderLabel: UILabel!
    @IBOutlet weak var itemQty: DesignableLabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var searchText: UITextField!
    
    
    var isFilter: Bool = false
    var filterProducts: [ProductItems] = []
    
    private var alertTitle = ""
    private var alertMessage = ""
    private var alertIdentifier = ""
    
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
    
    @IBAction func goToEditClient(sender: AnyObject) {
        
        performSegueWithIdentifier("Client", sender: nil)
    }
    
    @IBAction func goToPaymentAction(sender: AnyObject) {
        
        if pointSale.selection.count > 0{
            
            if !pointSale.client.name.isEmpty {
                performSegueWithIdentifier("Payment", sender: sender)
            }else{
                performSegueWithIdentifier("Client", sender: sender)
            }
            
        }else{
            
            alertTitle = "Ups..."
            alertMessage = "Por favor escoja los productos que desea vender!"
            alertIdentifier = "SeleccionarProducto"
        
            self.view.showCustomeAlert(title:"Ups...", message:"Por favor escoja los productos que desea vender!")
            
        }
    }
    
 
    required  init?(coder aDecoder: NSCoder) {
        
        let productItems = InventoryModel().getInventory()
        self.pointSale = PointSale(inventory: productItems)
        
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        randomImg = ["http://cdn.kiwilimon.com/recetaimagen/262/1286.jpg",
                     "http://topinspired.com/wp-content/uploads/2013/08/healthy-food-recipes-for-kids_01.jpg",
                     "http://cdn.aarp.net/content/dam/aarp/food/recipes/2013-02/740-low-fat-recipes-by-pam-anderso.imgcache.rev1360943709278.jpg/_jcr_content/renditions/cq5dam.web.420.270.jpeg",
                     "http://foodnetwork.sndimg.com/content/dam/images/food/fullset/2012/10/26/0/FNK_Healthy-Hot-Chocolate-Banana-Nut-Oatmeal_s4x3.jpg.rend.snigalleryslide.jpeg",
                     "http://www.livestrong.com/wp-content/uploads/2014/08/comfortfood.jpg",
                     "http://del.h-cdn.co/assets/16/07/shanghai-noodles-6-sm3.jpg",
                     "http://lilluna.com/wp-content/uploads/2012/01/chinese-1.jpg",
                     "http://www.perfectspice.com/image/data/recipe/Spicy%20Ribs.jpg",
                     "http://therawchef.com/wp-content/uploads/2007/01/raw-food-recipe-lasagne.jpg",
                     "http://3.bp.blogspot.com/-OYy3CYSsuz4/UlNOp8jKqeI/AAAAAAAAJlE/PtfiX4B3s1g/s1600/dashi+poached+salmon.jpg",
                     "http://www.thefullhelping.com/wp-content/uploads/2012/09/IMG_2581.jpg",
                     "http://www.glutenfreecat.com/wp-content/uploads/2012/07/Raw-Pakoras-by-Gluten-Free-Cat.jpg",
                     "http://www.zandyrestaurant.com/images/food/_MG_2661.jpg",
                     "http://www.topchinatravel.com/Pic/china-guide/cuisine/jiangsu-cuisine-1.jpg",
                     "http://www.thesaigoncafe.com/wp-content/uploads/2014/09/a1.jpg"]
        
        let ser = ServicesData()
      //  ser.getToken("victor", password: "genio1681")

        
        //Clear Cache
        let cache = KingfisherManager.sharedManager.cache
        cache.clearMemoryCache()
        cache.clearMemoryCache()
        
        
        do{
            
           
          //  try ser.getDataInventory()
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
        
        if segue.identifier == "PriceQuantityEdit" {
            
            let indexPath = self.tableView.indexPathForSelectedRow
            
            let toView = segue.destinationViewController as! PriceQuantityViewController
            toView.delegate = self
            toView.selection = pointSale.selection[(indexPath?.row)!]
            toView.indexPath = indexPath
            toView.isEdit = true
        }
        
        if segue.identifier == "Client" {
            
            let toView = segue.destinationViewController as! ClientViewController
            toView.delegate = self
            toView.client = pointSale.client
            
            
            //This option identifier whether client button was pressed or pay button
            //Whether pay button is pressed without client the client view will appear
            //and then payment view will appear automatically
            
            guard let id = sender?.restorationIdentifier! else{
                return
            }
            
            if id == "PayBtn" {
                toView.isButtonPayPressed = true
            }
        }
        
        if segue.identifier == "Payment" {
            
            
            let toPayment = segue.destinationViewController as! PaymentViewController
            toPayment.delegate = self
            
            toPayment.totalOrder = pointSale.totalOrder
            toPayment.totalTax = pointSale.totalTax
            toPayment.subTotal = pointSale.subTotal
            toPayment.clientName = pointSale.client.name
            
            toPayment.pointSaleData = pointSale
        }
        
        
        
    }
    
    
    //MARK: View Effect
    func minimizeView(sender: AnyObject) {
        SpringAnimation.spring(0.7, animations: {
            self.view.transform = CGAffineTransformMakeScale(0.955, 0.955)
        })
        
    }
    
    func maximizeView(sender: AnyObject) {
        SpringAnimation.spring(0.7, animations: {
            self.view.transform = CGAffineTransformMakeScale(1, 1)
        })
        
    }
    
    
    //MARK: Payment Delegate
    func billPaid(controller: PaymentViewController, pointData:PointSaleType) {
        pointSale = pointData
        OrderModel().insertOrder(pointSale)
        cleanView()
    }
    
    func cleanView() {
        let productItems = InventoryModel().getInventory()
        self.pointSale = PointSale(inventory: productItems)
        tableView.reloadData()
        
        //show Client Button
        clientButton.animation = "fadeIn"
        clientButton.animate()
        
        //hide Information
        clientInformationView.hidden = true
        clientInformationView.animation = "fadeOut"
        clientInformationView.animate()
        
        totalOrderLabel.text = 0.0.FormatNumberCurrencyVS
    }
    
    
   
    //MARK: Client Delegate
    
    func clientReload(controller: ClientViewController, clientSelected: ClientSelection, isButtonPayPressed:Bool) {
        
        pointSale.client = clientSelected
        
        //Hide Client Button
        clientButton.animation = "fadeOut"
        clientButton.animate()
        
        //Show Information
        clientInformationView.hidden = false
        clientInformationView.animation = "fadeIn"
        clientInformationView.animate()
        
        
        //Set text
        clientName.text = clientSelected.name
        clientEmail.text = clientSelected.email
        clientPhone.text = clientSelected.phone
        
        //Load Payment View whether pay button was pressed
        if isButtonPayPressed {
            performSegueWithIdentifier("Payment", sender: nil)
        }
        
        print(clientSelected.name)
        
    }
    
    //MARK: Delegate Price & Quantity
    func updatePriceQuantity(controller: PriceQuantityViewController, netPrice: Double, amountTax:Double,  quantity: Double, selectedItem:ProductItems?, indexPath:Int?){
        
        
        if selectedItem != nil {
            //Add Select Item
            
            let selectedItem  = InventorySelectionItem(code: selectedItem!.code, description: selectedItem!.description, unit: selectedItem!.und, amountTax: amountTax, quantity: quantity, price: netPrice , discount1: 0.0, discountPercent: 0.0)
            
            do{
                try pointSale.vend(selectedItem)
                
                
            }catch let e{
                print("Something happen \(e)")
            }
            
        }else{
            //Edit Product
            
            do{
                try pointSale.editItem(quantity, price: netPrice, indexPath: indexPath!)
            }catch{
                print("error: \(error))")
            }
        }
        
        
        self.tableView?.reloadData()
        
        //show Total
        totalOrderLabel.text = pointSale.totalOrder.FormatNumberCurrencyVS
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
        
        let range = UInt32(randomImg.count)
        let ranNum =  Int(arc4random_uniform(range))
        
        
        cell.url = (randomImg[ranNum])  //"http:/)/cdn.kiwilimon.com/recetaimagen/262/1286.jpg"
        
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
        
        
        cell.price.text = "\(price.FormatNumberCurrencyVS)"
        cell.quantity.text = "\(qty.FormatNumberNumberVS)"
        cell.subTotal.text = "\(subTotal.FormatNumberCurrencyVS)"
        
        cell.url = "http://cdn.kiwilimon.com/recetaimagen/262/1286.jpg";
        
        return cell
        
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        performSegueWithIdentifier("PriceQuantityEdit", sender: nil)
        
    }
    
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == UITableViewCellEditingStyle.Delete {
            
            do{
                try pointSale.removeItem(indexPath.row)
                totalOrderLabel.text = pointSale.totalOrder.FormatNumberCurrencyVS
                
            }catch{
                print("Error: \(error)")
            }
            
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
        }
    }
    
}