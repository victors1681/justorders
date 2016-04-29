//
//  Price&QuantityViewController.swift
//  JustOrders
//
//  Created by Victor Santos on 3/29/16.
//  Copyright © 2016 Victor Santos. All rights reserved.
//

import UIKit

protocol PriceQuantityViewControllerDelegate:
class {
    func updatePriceQuantity(controller: PriceQuantityViewController, netPrice: Double, amountTax:Double,  quantity: Double, selectedItem:ProductItems?, indexPath:Int?)
}


class PriceQuantityViewController: UIViewController {

    weak var delegate: PriceQuantityViewControllerDelegate?
    var selectedItem : ProductItems?
    var selection: InventorySelectionItem?
    var isEdit = false
    var indexPath:NSIndexPath?
    
    @IBAction func closeView(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var priceText: UITextField!
    @IBOutlet weak var quantityText: UITextField!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var containerView: DesignableView!
    
    @IBAction func lessAction(sender: AnyObject) {
       
        let qty:Double? = Double(quantityText.text!.RemoveSymbolVS)
        if qty != nil && Int(qty!) >= 1 {
            let result = qty! - 1
            quantityText.text = result.FormatNumberNumberVS
        }
        updateTotal(self)
    }
    
    @IBAction func plusAcction(sender: AnyObject) {
      
        
        let qty:Double? = Double((quantityText.text?.RemoveSymbolVS)!)
        if qty != nil {
            let result = qty! + 1
            quantityText.text = result.FormatNumberNumberVS
        }
        
        updateTotal(self)
        
    }
    
    @IBAction func doneButtonAction(sender: AnyObject) {
        
        let qty:Double? = Double((quantityText.text?.RemoveSymbolVS)!)
        let price:Double? = Double((priceText.text?.RemoveSymbolVS)!)
        var tax: Double? = selectedItem?.tax
        
        if(qty != nil && price != nil){
            
            if tax == nil {
                tax = 0
            }
            
            let netPrice = subtractTaxes(price!, tax: tax!)
            
            let taxes = price! - netPrice
            
            if isEdit {
                delegate?.updatePriceQuantity(self, netPrice: netPrice, amountTax: taxes, quantity: qty!, selectedItem: selectedItem, indexPath: indexPath?.row)
            }else{
           
        delegate?.updatePriceQuantity(self,netPrice: netPrice, amountTax:taxes, quantity: qty!, selectedItem: selectedItem!, indexPath: nil)
            }
       
            dismissViewControllerAnimated(true, completion: nil)
        }else{
            containerView.animation = "shake"
            containerView.curve = "easeIn"
            containerView.duration = 1
            containerView.animate()
        }
    }
    
    @IBAction func updateTotal(sender: AnyObject){
        
        let qty:Double? = Double(quantityText.text!)
        let price:Double? = Double((priceText.text?.RemoveSymbolVS)!)
        
        
        if(qty != nil && price != nil){
            
            let total:Double = qty! * price!
            
            totalLabel.text = total.FormatNumberCurrencyVS
        }
        
    }
   
    
    //MARCK: Load View
    override func viewDidLoad() {
        
        super.viewDidLoad()
        // Do view setup here.
        
        //Check whether user can change prices
        
        if !UserDefaultModel().getConfiguration().changePrice {
            priceText.enabled = false
        }
        
        if((selectedItem?.prices.price1) != nil && selectedItem?.tax != nil){
            
            let result = taxesCalculate(selectedItem!.prices.price1, tax: selectedItem!.tax)
            
            priceText.text = result.pricePlusTax.FormatNumberCurrencyVS
            descriptionLabel.text = selectedItem?.description
            
            
            updateTotal(self)
        }else{
            priceText.text = "0.0"
        }
        
        if isEdit { 
            
            quantityText.text =  selection!.quantity.FormatNumberNumberVS
            priceText.text =  selection!.price.FormatNumberCurrencyVS
            descriptionLabel.text = selection!.description
            
            updateTotal(self)
        }
        
    }
    
    //MASK: Taxes Calculate
    
    func taxesCalculate(price:Double, tax: Double) -> (pricePlusTax:Double, amountTax:Double)
    {
        //Convert integer to porcent 
        let decimalTax = (tax / 100) + 1
        
        let pricePlusTax = price * decimalTax
        let amountTax = pricePlusTax - pricePlusTax
        
        return (pricePlusTax, amountTax)
        
    }
    
    //Return price without tax
    func subtractTaxes(price: Double, tax: Double)-> Double {
        //Convert integer to porcent
        let decimalTax = (tax / 100) + 1
        
        let netPrice = price / decimalTax
        
        return netPrice
    }
    
}
