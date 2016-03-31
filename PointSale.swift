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
    
    init(inventory: [ProductItems])
    
    func vend(selection: InventorySelectionItem, quantity: Double) throws
    func removeItem(index: Int) throws
    func editItem(selection: InventorySelectionItem, quantity: Double) throws
    func mergeItems(selection: InventorySelectionItem) throws
    func itemForCurrentSelection(selection: InventorySelectionItem)
    
    func setPaymentMethod(method: PaymentMethod)
    func save()
}

protocol ClientSelectionType {
    
    var name: String { get set }
    var email: String  { get set }
    var address: String  { get set}
    var phone: String { get set }
    var celPhone: String { get set }
    
}

struct ClientSelection: ClientSelectionType {
    var name: String
    var email: String
    var address: String
    var phone: String
    var celPhone: String
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
}


enum PaymentMethod {
    case NoPayment, Cash, CreditCard
    
}


class PointSale: PointSaleType {
    
    var client: ClientSelection = ClientSelection(name: "", email: "", address: "", phone: "", celPhone: "")
    var selection: [InventorySelectionItem] = []
    
    var totalOrder: Double = 0.0
    var totalTax: Double = 0.0
    
    var inventory : [ProductItems]
    var paymentMethod: PaymentMethod = PaymentMethod.NoPayment
    
    required init(inventory: [ProductItems]){
        
        self.inventory = inventory
    }
    
    func vend(selection: InventorySelectionItem, quantity: Double) throws {
        
        self.selection.append(selection)
    }
    
    func removeItem(index: Int) throws {
        
        guard self.selection.indices.contains(index) else {
            throw PointSaleError.InvalidItemIndex
        }
        
        self.selection.removeAtIndex(index)
    }
    func editItem(selection: InventorySelectionItem, quantity: Double) throws {}
    func mergeItems(selection: InventorySelectionItem) throws {}
    func itemForCurrentSelection(selection: InventorySelectionItem){}
    
    func setPaymentMethod(method: PaymentMethod){
        self.paymentMethod = method
    }
    func save(){
        
    }
    
}