//
//  ServiceData.swift
//  JustOrders
//
//  Created by Victor Santos on 3/15/16.
//  Copyright © 2016 Victor Santos. All rights reserved.
//


protocol PointSaleType {
    
    var client: ClientSelection { get set }
    var selection: [InventorySelectionItem] { get set }
    
    var inventory : [ProductItems]{ get }
    var paymentMethod: PaymentMethod { get }
    
    var totalOrder: Double { get set}
    var totalTax: Double { get set }
    var subTotal: Double { get set }
    var amountPaid: Double { get set }
    var amountChange: Double { get set }
    
    init(inventory: [ProductItems])
    
    func vend(selection: InventorySelectionItem) throws
    func removeItem(index: Int) throws
    func editItem(quantity: Double, price: Double, indexPath:Int) throws
    func mergeItems(selection: InventorySelectionItem)throws ->Bool
    func itemForCurrentSelection(selection: InventorySelectionItem)
    
    func setPaymentMethod(method: PaymentMethod)
    func updateBalance()
    func save()
}


enum ClientClasification: String {
    case Personal
    case Company
    case Special
    case Government
}


protocol ClientSelectionType {
    
    var code: String { get set }
    var name: String { get set }
    var email: String  { get set }
    var address: String  { get set}
    var phone: String { get set }
    var celPhone: String { get set }
    var taxId: String { get set }
    var city: String { get set }
    var clasification: String { get set }
    var taxeable: Bool { get set }
    
    
}

struct ClientSelection: ClientSelectionType {
    
    var code: String
    var name: String
    var email: String
    var address: String
    var phone: String
    var celPhone: String
    var taxId: String
    var city: String
    var clasification: String
    var taxeable: Bool
    
}

protocol ProductType{
    var code: String { get }
    var description: String { get }
    var unit: String { get }
    var price: Double { get  }
}

protocol InventoryType: ProductType {
    
    var code: String { get }
    var description: String { get }
    var unit: String { get }
    var line: String { get }
    var barCode: String { get }
    var tax: Double { get }
    var cost: Double { get  }
    var stock: Double { get  }
    var price: Double { get  }
    var price2: Double { get  }
    var price3: Double { get  }
    var price4: Double { get  }
    var price5: Double { get  }
    
}

struct InventoryItems: ProductType {
    var code: String
    var description: String
    var unit: String
    var line: String
    var barCode: String
    var tax: Double
    var cost: Double
    var stock: Double
    var price: Double
    var price2: Double
    var price3: Double
    var price4: Double
    var price5: Double
}


protocol InventoryItemType: ProductType {
    var code: String { get }
    var description: String { get }
    var unit: String { get }
    var amountTax: Double { get set }
    var quantity: Double { get set }
    var price: Double { get set }
    var discount1: Double { get set }
    var discountPorcent: Double { get set }
    
}

struct InventorySelectionItem: InventoryItemType {
    
    let code: String
    let description: String
    let unit: String
    var amountTax: Double
    var quantity: Double
    var price: Double
    var discount1: Double
    var discountPorcent: Double
}

enum PointSaleError: ErrorType {
    case InvalidSelection
    case InvalidItemIndex
    case InvalidMarge
}


enum PaymentMethod {
    case NoPayment, Cash, CreditCard
    
}


enum KeyNumbers {
    case one
    case two
    case three
    case four
    case five
    case six
    case seven
    case eight
    case nine
    case zero
    case zeroZero
    case point
}


class PointSale: PointSaleType {
    
    var client: ClientSelection = ClientSelection(code: "", name: "", email: "", address: "'", phone: "'", celPhone: "", taxId: "", city: "", clasification: "", taxeable: false)
    
    var selection: [InventorySelectionItem] = []
    
    var totalOrder: Double = 0.0
    var totalTax: Double = 0.0
    var subTotal: Double = 0.0
    var amountPaid: Double = 0.0
    var amountChange: Double = 0.0
    
    var inventory : [ProductItems]
    var paymentMethod: PaymentMethod = PaymentMethod.NoPayment
    
    required init(inventory: [ProductItems]){
        
        self.inventory = inventory
    }
    
    func vend(selection: InventorySelectionItem) throws {
        
        do {
          if try !mergeItems(selection) {
            self.selection.append(selection)
            updateBalance()
        }
        }catch{
            throw PointSaleError.InvalidMarge
        }
        
    }
    
    func removeItem(index: Int) throws {
        
        guard self.selection.indices.contains(index) else {
            throw PointSaleError.InvalidItemIndex
        }
        
        self.selection.removeAtIndex(index)
        updateBalance()
    }
    func editItem(quantity: Double, price: Double, indexPath:Int) throws {
        
        selection[indexPath].price = price
        selection[indexPath].quantity = quantity
        updateBalance()
    }
    
    func mergeItems(selection: InventorySelectionItem)throws ->Bool {
    
        for (index, currentSelection) in self.selection.enumerate() {
            
            //Looking for item inserted return true whether found
            if currentSelection.code == selection.code {
                let newQty = currentSelection.quantity + selection.quantity
                
                let newProduct = InventorySelectionItem(code: currentSelection.code, description: currentSelection.description, unit: currentSelection.unit, amountTax: currentSelection.amountTax, quantity: newQty, price: currentSelection.price, discount1: currentSelection.discount1, discountPorcent: currentSelection.discountPorcent)
                
                
                do{
                    try removeItem(index)
                    try vend(newProduct)
                    
                    return true
                }catch{
                    print("error removing object:\(error)")
                }
                
            }
        }
        
        return false
    }
    
    func itemForCurrentSelection(selection: InventorySelectionItem){}
    
    func setPaymentMethod(method: PaymentMethod){
        self.paymentMethod = method
    }
    
    func updateBalance() {  //Automatic updating
        self.totalOrder = 0
        self.totalTax = 0
         self.subTotal = 0
        
        for item in selection {
            
            self.totalOrder += item.quantity * (item.price + item.amountTax)
            self.totalTax += item.amountTax
        }
        
        self.subTotal = totalOrder - totalTax
                
    }
    
    
    
    func save(){
        
    }
    
}
