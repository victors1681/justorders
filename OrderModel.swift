//
//  OrderModel.swift
//  JustOrders
//
//  Created by Victor Santos on 4/10/16.
//  Copyright © 2016 Victor Santos. All rights reserved.
//

import SQLite 

class OrderModel {

    enum FindOrderBy {
        case Id
        case AllOrders
        case Sync
        case NoSync
        case Client
        case Date
    }
    
    
    func insertOrder(order:PointSaleType) -> Bool {
        
        let dbModel = DBModel.init()
        let db = dbModel?.getDB()
        
        
        if((db) != nil){
            
            
            let userDef = UserDefaultModel()
            
            let orderSec:String = userDef.getOrderSec()
            let clientId: String = order.client.code
            let newClient: Bool = order.client.newClient
            let terminalNo: Int = Int(userDef.getDataUser().terminal) ?? 0
            let totalOrder: Double = order.totalOrder
            let totalTax: Double = order.totalTax
            let subTotal:Double = order.subTotal
            let amountPaid:Double = order.amountPaid
            let amountChange:Double = order.amountChange
            let paymentMethod :String = order.paymentMethod.rawValue
            let totalDiscount:Double = order.totalDiscount
            let discountPercent:Double = order.discountPercent
            let documentType:String = order.documentType.rawValue
            let ncf:String = order.ncf
            let orderNote:String = order.orderNote
            let sendTo:String = order.sendTo
            let userName:String = userDef.getDataUser().localUser ?? ""
            
            do{
                
                try db!.run("INSERT INTO Orders (orderId, clientId, newClient, terminalNo, totalOrder, totalTax, subTotal, amountPaid, amountChange, paymentMethod, totalDiscount, discountPercent, documentType, ncf, orderNote, username, sendTo, date) VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?, date('now')) ", orderSec, clientId, newClient, terminalNo, totalOrder, totalTax, subTotal, amountPaid, amountChange, paymentMethod, totalDiscount, discountPercent, documentType, ncf, orderNote, userName, sendTo)
                
                //Insert Detailts
                insertOrderDetail(order.selection, orderId: orderSec)
                //Increase Order number
                userDef.increaseOrderSec()
                //Whether is a new client insert
                if order.client.newClient {
                    ClientModel().insertClient(order.client)
                }
                
            }catch{
                print("error insert Order : \(error)")
                return false
            }
            
        }
        
        return true
    }
    
    
    internal func insertOrderDetail(orderDetails:[InventorySelectionItem], orderId: String) ->Int  {
        
        let userDef = UserDefaultModel()
        let terminalNo  = userDef.getDataUser().terminal
        
        let dbModel = DBModel.init()
        let db = dbModel?.getDB()
        
        var detailQty = 0;
        
        if((db) != nil){
            
            
            for row in orderDetails {
                do{
                    
                    try db!.run("INSERT INTO orderDetail (orderId, terminalNo, code, description, unit, amountTax, quantity, price, discount1, discountPercent) VALUES (?,?,?,?,?,?,?,?,?,?)", orderId, terminalNo, row.code, row.description, row.unit, row.amountTax, row.quantity, row.price, row.discount1, row.discountPercent )
                    
                    detailQty += 1
                    
                }catch{
                    print("error insert Order details : \(error)")
                    return 0
                }
            }
        }
        
        return detailQty
        
    }
    
    
    
    func getOrders(getBy:FindOrderBy? = .AllOrders, parameter: String? = "0", dateIn:String?="",dateEnd:String?="") -> [PointSale] {
        
        let dbModel = DBModel.init()
        let db = dbModel?.getDB()
        let products: [ProductItems] = []
        var ordersArr:[PointSale] = []
        
        if((db) != nil){
            
            let orders = Table("orders")
            
            let orderId = Expression<Int>("orderId")
            let clientId = Expression<String>("clientId")
            let terminalNo  = Expression<Int>("terminalNo")
            let totalOrder = Expression<Double>("totalOrder")
            let totalTax = Expression<Double>("totalTax")
            let subTotal = Expression<Double>("subTotal")
            let amountPaid = Expression<Double>("amountPaid")
            let amountChange = Expression<Double>("amountChange")
            let paymentMethod  = Expression<String>("paymentMethod")
            let totalDiscount = Expression<Double>("totalDiscount")
            let discountPercent = Expression<Double>("discountPercent")
            let documentType  = Expression<String>("documentType")
            let ncf  = Expression<String>("ncf")
            let orderNote  = Expression<String>("orderNote")
            let userName  = Expression<String>("userName")
            let date  = Expression<String>("date")
            let sendTo  = Expression<String>("sendTo")
            let sync  = Expression<Bool>("sync")
            let syncDate  = Expression<String>("syncDate")
            
          
            switch getBy! {
            case .Client:
               orders
                break
                
            case .Id:
                orders.filter(orderId == Int(parameter!)!)
                break
                
            case .NoSync:
                orders.filter(sync == false)
                break
                
            case .Sync:
                orders.filter(sync == true)
                break
            case .Date:
                guard dateIn != nil && dateEnd != nil  else {
                    print("date In or date End are empty")
                    break
                }
                
                if !dateIn!.isEmpty && dateEnd!.isEmpty {
                    orders.filter(date >=  dateIn!)
                }else if dateIn!.isEmpty && !dateEnd!.isEmpty{
                    orders.filter(date <= dateEnd!)
                }else{
                    orders.filter(date >= dateIn! && date <= dateEnd!)
                }
                
                break
            default: //All orders
                
                break
                
            }
            
            do{
                
                
                for order in try db!.prepare(orders) {
                    
                    let orderObj = PointSale(inventory: products)
                    
                    orderObj.orderId = order[orderId]
                    orderObj.terminalNo = order[terminalNo]
                    orderObj.totalOrder = order[totalOrder]
                    orderObj.totalTax = order[totalTax]
                    orderObj.subTotal = order[subTotal]
                    orderObj.amountPaid = order[amountPaid]
                    orderObj.amountChange = order[amountChange]
                    orderObj.paymentMethod = setPaymentMethodToEnum(order[paymentMethod])
                    orderObj.totalDiscount = order[totalDiscount]
                    orderObj.discountPercent = order[discountPercent]
                    orderObj.documentType = setDocumentTypeToEnum(order[documentType])
                    orderObj.ncf = order[ncf]
                    orderObj.orderNote = order[orderNote]
                    orderObj.userName = order[userName]
                    orderObj.date = order[date]
                    orderObj.sendTo = order[sendTo]
                    orderObj.sync = order[sync]
                    orderObj.syncDate = order[syncDate]
                    orderObj.selection = getOrderDetail(order[orderId])
                    orderObj.client = ClientModel().getClient(order[clientId])
                    ordersArr.append(orderObj)
                    
                }
            }catch{
                print("Error to load Orders \(error)")
            }
            
        }
        
        return ordersArr
        
    }
    
    func setPaymentMethodToEnum(payment:String) -> PaymentMethod {
        switch payment {
        case PaymentMethod.Cash.rawValue:
            return .Cash
           
        case PaymentMethod.CreditCard.rawValue:
            return .CreditCard
            
        case PaymentMethod.NoPayment.rawValue:
            return .NoPayment
            
        default:
            return .NoPayment
        }
    }
    
    func setDocumentTypeToEnum(document:String) -> DocumentType {
        
        switch document {
        case DocumentType.Invoice.rawValue:
            return .Invoice
        default:
            return .Order
        }
    }
    
    
    internal func getOrderDetail(orderIdIn: Int)->[InventorySelectionItem] {
        
        let dbModel = DBModel.init()
        let db = dbModel?.getDB()
        var products: [InventorySelectionItem] = []
        
        if((db) != nil){
            
            let orderDetail = Table("orderDetail")
            
            //let numReg = Expression<Int>("numReg")
            let orderId = Expression<Int>("orderId")
            let terminalNo  = Expression<Int>("terminalNo")
            
            let code = Expression<String>("code")
            let description = Expression<String>("description")
            let unit = Expression<String>("unit")
            let amountTax = Expression<Double>("amountTax")
            let quantity = Expression<Double>("quantity")
            let price  = Expression<Double>("price")
            let discount1 = Expression<Double>("discount1")
            let discountPercent = Expression<Double>("discountPercent")
            
            do{
                
                let query = orderDetail.select(terminalNo, code, description, unit, amountTax, quantity, price, discount1,discountPercent)
                    .filter(orderId == orderIdIn)
                
                for row in try db!.prepare(query) {
                    
                    let detail = InventorySelectionItem(code: row[code], description: row[description], unit: row[unit], amountTax: row[amountTax], quantity: row[quantity], price: row[price], discount1: row[discount1], discountPercent: row[discountPercent])
                    
                    products.append(detail)
                    
                }
            }catch{
                print("Error to load inventory \(error)")
            }
            
        }
        return products
        
    }
    
    
    func getLastOrderNumber() -> Int {
        let dbModel = DBModel.init()
        let db = dbModel?.getDB()
   
        
        if((db) != nil){
            let orders = Table("orders")
            let orderId = Expression<Int>("orderId")
           
            let max:Int =  db!.scalar(orders.select(orderId.max))!
            return max
        }
        
        return 0
    }
    
    
    func sendOrders() {
        
       let orders = getOrders()
        
        var ordersObj = [[String: AnyObject]]()
        for order in orders {
            
            let client = order.client
            
            //Get Client
            let clientObj = ["code":client.code,
                             "name":client.name,
                             "email":client.email,
                             "address":client.address,
                             "phone":client.phone,
                             "cellphone":client.cellPhone,
                             "taxId":client.taxId,
                             "city":client.city,
                             "clasification":client.clasification,
                             "taxeable":client.taxeable]
            
            //Order details
            var selectionDic = [[String:AnyObject]]()
            for selection in order.selection {
                let selectionObj = ["code": selection.code,
                                    "description":selection.description,
                                    "unit":selection.unit,
                                    "amountTax":selection.amountTax,
                                    "quantity":selection.quantity,
                                    "price":selection.price,
                                    "discount1":selection.discount1,
                                    "discountPercent":selection.discountPercent]
                selectionDic.append(selectionObj as! [String : AnyObject])
            }
            
            //another data
            
            
            let dic:[String:AnyObject] = ["client": clientObj,
                       "selection": selectionDic,
                       "orderId": order.orderId,
                       "totalOrder": order.totalOrder,
                       "subTotal": order.subTotal,
                       "amountPaid": order.amountPaid,
                       "amountChange": order.amountChange,
                       "paymentMethod": order.paymentMethod.rawValue,
                       "orderNote": order.orderNote,
                       "userName": order.userName,
                       "totalDiscount": order.totalDiscount,
                       "discountPercent": order.discountPercent,
                       "documentType": order.documentType.rawValue,
                       "ncf": order.ncf,
                       "terminalNo": order.terminalNo,
                       "date": order.date,
                       "sendTo": order.sendTo]
            
            ordersObj.append(dic)
            
        }
       
        
        //Group
        let data:[String:AnyObject] = ["data":ordersObj]
        print(JSON(data))
        
        ServicesData().sendOrders(JSON(data)) { (response) in
           // print(response);)
        }
        
    }
    
    
}







